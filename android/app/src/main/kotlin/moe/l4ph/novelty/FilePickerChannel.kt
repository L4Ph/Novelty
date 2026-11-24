package moe.l4ph.novelty

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.OpenableColumns
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * Backup export/import on Android.
 *
 * Both operations go through the Storage Access Framework, so the app needs no
 * storage permission and never writes to a raw path:
 *
 * - saveFile: ACTION_CREATE_DOCUMENT, then stream the source file into the
 *   document the user picked.
 * - pickFile: ACTION_OPEN_DOCUMENT, then copy the picked document into the
 *   app's own cache directory and hand the caller a real path.
 *
 * Files are copied on a worker thread: a backup can be hundreds of megabytes
 * and a slow document provider would otherwise block the UI.
 */
class FilePickerChannel(
    private var activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "novelty/file_picker")
    private val mainHandler = Handler(Looper.getMainLooper())
    private val worker = Executors.newSingleThreadExecutor()

    /** Set while an intent is in flight; guards against overlapping calls. */
    private var pendingResult: MethodChannel.Result? = null
    private var pendingSourcePath: String? = null
    private var pendingCacheDirectory: String? = null

    init {
        channel.setMethodCallHandler(this)
    }

    /** The host activity is recreated on configuration changes. */
    fun attach(activity: Activity) {
        this.activity = activity
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error("busy", "A file picker is already open", null)
            return
        }

        when (call.method) {
            "saveFile" -> {
                val sourcePath = call.argument<String>("sourcePath")
                val suggestedName = call.argument<String>("suggestedName")
                if (sourcePath == null || suggestedName == null) {
                    result.error("bad_args", "sourcePath and suggestedName are required", null)
                    return
                }
                pendingResult = result
                pendingSourcePath = sourcePath
                pendingCacheDirectory = null
                val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = mimeTypeFor(suggestedName)
                    putExtra(Intent.EXTRA_TITLE, suggestedName)
                }
                launch(intent, REQUEST_SAVE)
            }

            "pickFile" -> {
                val cacheDirectory = call.argument<String>("cacheDirectory")
                if (cacheDirectory == null) {
                    result.error("bad_args", "cacheDirectory is required", null)
                    return
                }
                pendingResult = result
                pendingSourcePath = null
                pendingCacheDirectory = cacheDirectory
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    // .db has no registered MIME type; the caller filters by
                    // extension once the copy exists.
                    type = "*/*"
                }
                launch(intent, REQUEST_PICK)
            }

            else -> result.notImplemented()
        }
    }

    private fun launch(intent: Intent, requestCode: Int) {
        try {
            activity.startActivityForResult(intent, requestCode)
        } catch (e: Exception) {
            finishWithError("launch_failed", e.message)
        }
    }

    /** Returns true when this result belongs to the picker. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_SAVE && requestCode != REQUEST_PICK) return false
        if (resultCode != Activity.RESULT_OK) {
            finish(null)
            return true
        }
        val uri = data?.data
        if (uri == null) {
            finish(null)
            return true
        }
        if (requestCode == REQUEST_SAVE) {
            saveOnWorker(uri)
        } else {
            pickOnWorker(uri)
        }
        return true
    }

    private fun saveOnWorker(uri: Uri) {
        val sourcePath = pendingSourcePath
        worker.execute {
            try {
                val source = sourcePath?.let(::File)
                if (source == null || !source.exists()) {
                    postError("missing_source", "Source file is gone: $sourcePath")
                    return@execute
                }
                activity.contentResolver.openOutputStream(uri)?.use { out ->
                    source.inputStream().use { input -> input.copyTo(out, BUFFER_SIZE) }
                } ?: throw IllegalStateException("Could not open the destination")
                postSuccess(displayName(uri) ?: uri.toString())
            } catch (e: Exception) {
                postError("io_error", e.message)
            }
        }
    }

    private fun pickOnWorker(uri: Uri) {
        val cacheDirectory = pendingCacheDirectory
        var target: File? = null
        worker.execute {
            try {
                val directory = cacheDirectory
                    ?: throw IllegalStateException("Missing cache directory")
                target = uniqueTarget(
                    File(directory),
                    sanitize(displayName(uri) ?: "picked.db"),
                )
                activity.contentResolver.openInputStream(uri)?.use { input ->
                    target!!.outputStream().use { out -> input.copyTo(out, BUFFER_SIZE) }
                } ?: throw IllegalStateException("Could not read the picked file")
                postSuccess(target!!.path)
            } catch (e: Exception) {
                // Do not leave a half-written copy behind: the caller never
                // learns its path, so nothing else would clean it up.
                target?.delete()
                postError("io_error", e.message)
            }
        }
    }

    private fun postSuccess(value: String?) = mainHandler.post { finish(value) }

    private fun postError(code: String, message: String?) =
        mainHandler.post { finishWithError(code, message) }

    private fun finish(value: String?) {
        val result = pendingResult ?: return
        pendingResult = null
        pendingSourcePath = null
        pendingCacheDirectory = null
        result.success(value)
    }

    private fun finishWithError(code: String, message: String?) {
        val result = pendingResult ?: return
        pendingResult = null
        pendingSourcePath = null
        pendingCacheDirectory = null
        result.error(code, message, null)
    }

    private fun displayName(uri: Uri): String? =
        activity.contentResolver
            .query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
            ?.use { cursor -> if (cursor.moveToFirst()) cursor.getString(0) else null }

    /**
     * The display name comes from the document provider, not from us, so it can
     * contain path separators. `../files/x.db` would otherwise be written
     * outside the cache directory.
     */
    private fun sanitize(name: String): String {
        val base = name.substringAfterLast('/').substringAfterLast('\\')
        val cleaned = base.replace("..", "_").trim()
        return cleaned.ifEmpty { "picked.db" }
    }

    /** Never overwrite an existing file in the cache directory. */
    private fun uniqueTarget(directory: File, name: String): File {
        directory.mkdirs()
        val base = name.substringBeforeLast('.', name)
        val extension = name.substringAfterLast('.', "")
        var candidate = File(directory, name)
        var index = 1
        while (candidate.exists()) {
            val suffix = if (extension.isEmpty()) "" else ".$extension"
            candidate = File(directory, "$base-$index$suffix")
            index++
        }
        if (!candidate.canonicalPath.startsWith(directory.canonicalPath)) {
            throw IllegalStateException("Refusing to write outside the cache")
        }
        return candidate
    }

    private fun mimeTypeFor(fileName: String): String =
        when (fileName.substringAfterLast('.', "").lowercase()) {
            "db", "sqlite", "sqlite3" -> "application/octet-stream"
            else -> "*/*"
        }

    private companion object {
        const val REQUEST_SAVE = 0x4E01
        const val REQUEST_PICK = 0x4E02
        const val BUFFER_SIZE = 64 * 1024
    }
}
