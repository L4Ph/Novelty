import Flutter
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var filePicker: FilePickerChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let picker = FilePickerChannel(messenger: controller.binaryMessenger)
      picker.attach(controller)
      filePicker = picker
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// Backup export/import on iOS.
///
/// - saveFile: `UIDocumentPickerViewController(url:in:)`, so the system copies
///   our temp file out of the sandbox. No security-scoped access and no
///   permission declaration are involved.
/// - pickFile: imports a copy into the app's temporary directory, moves it into
///   the cache directory the caller asked for and returns that path.
final class FilePickerChannel: NSObject {
  init(messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: "novelty/file_picker", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private let channel: FlutterMethodChannel
  private var pendingResult: FlutterResult?
  private var pendingCacheDirectory: String?
  private weak var viewController: UIViewController?

  func attach(_ controller: UIViewController) {
    viewController = controller
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if pendingResult != nil {
      result(FlutterError(code: "busy", message: "A file picker is already open", details: nil))
      return
    }
    guard let presenter = viewController ?? topViewController() else {
      result(FlutterError(code: "no_activity", message: "No view controller", details: nil))
      return
    }
    viewController = presenter

    switch call.method {
    case "saveFile":
      guard let args = call.arguments as? [String: Any],
            let sourcePath = args["sourcePath"] as? String
      else {
        result(FlutterError(code: "bad_args", message: "sourcePath is required", details: nil))
        return
      }
      let source = URL(fileURLWithPath: sourcePath)
      guard FileManager.default.fileExists(atPath: source.path) else {
        result(FlutterError(code: "missing_source", message: "Source file is gone", details: sourcePath))
        return
      }
      pendingResult = result
      pendingCacheDirectory = nil
      let picker = UIDocumentPickerViewController(url: source, in: .exportToService)
      picker.delegate = self
      presenter.present(picker, animated: true)

    case "pickFile":
      guard let args = call.arguments as? [String: Any],
            let cacheDirectory = args["cacheDirectory"] as? String
      else {
        result(FlutterError(code: "bad_args", message: "cacheDirectory is required", details: nil))
        return
      }
      pendingResult = result
      pendingCacheDirectory = cacheDirectory
      let picker: UIDocumentPickerViewController
      if #available(iOS 14.0, *) {
        let types: [UTType] = (args["extensions"] as? [String] ?? [])
          .compactMap { UTType(filenameExtension: $0) }
        picker = UIDocumentPickerViewController(
          forOpeningContentTypes: types.isEmpty ? [.data] : types,
          asCopy: true
        )
      } else {
        // The app still targets iOS 12, where UTType does not exist.
        picker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
      }
      picker.delegate = self
      presenter.present(picker, animated: true)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func finish(_ value: String?) {
    let result = pendingResult
    pendingResult = nil
    pendingCacheDirectory = nil
    result?(value)
  }

  private func finishWithError(_ code: String, _ message: String) {
    let result = pendingResult
    pendingResult = nil
    pendingCacheDirectory = nil
    result?(FlutterError(code: code, message: message, details: nil))
  }

  /// Fallback for the case where attach() ran before the root controller
  /// existed. `connectedScenes` is iOS 13, but the app targets 12.
  private func topViewController() -> UIViewController? {
    var controller: UIViewController?
    if #available(iOS 13.0, *) {
      controller = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }?
        .rootViewController
    } else {
      controller = UIApplication.shared.keyWindow?.rootViewController
    }
    while let presented = controller?.presentedViewController {
      controller = presented
    }
    return controller
  }

  /// The picked name comes from another provider, so never let it escape the
  /// cache directory.
  private func sanitize(_ name: String) -> String {
    let base = (name as NSString).lastPathComponent.replacingOccurrences(of: "..", with: "_")
    return base.isEmpty ? "picked.db" : base
  }

  private func uniqueTarget(directory: URL, name: String) throws -> URL {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let base = (name as NSString).deletingPathExtension
    let ext = (name as NSString).pathExtension
    var candidate = directory.appendingPathComponent(name)
    var index = 1
    while FileManager.default.fileExists(atPath: candidate.path) {
      let suffix = ext.isEmpty ? "" : ".\(ext)"
      candidate = directory.appendingPathComponent("\(base)-\(index)\(suffix)")
      index += 1
    }
    let root = directory.standardizedFileURL.path
    guard candidate.standardizedFileURL.path.hasPrefix(root) else {
      throw NSError(domain: "novelty_file_picker", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Refusing to write outside the cache",
      ])
    }
    return candidate
  }
}

extension FilePickerChannel: UIDocumentPickerDelegate {
  func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    guard let url = urls.first else {
      finish(nil)
      return
    }
    guard let cacheDirectory = pendingCacheDirectory else {
      // Export: the system already copied our file, so the name is enough.
      finish(url.lastPathComponent)
      return
    }
    do {
      let directory = URL(fileURLWithPath: cacheDirectory)
      let target = try uniqueTarget(directory: directory, name: sanitize(url.lastPathComponent))
      try FileManager.default.moveItem(at: url, to: target)
      finish(target.path)
    } catch {
      finishWithError("io_error", error.localizedDescription)
    }
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    finish(nil)
  }
}
