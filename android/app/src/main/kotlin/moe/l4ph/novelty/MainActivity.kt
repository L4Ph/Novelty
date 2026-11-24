package moe.l4ph.novelty

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var filePicker: FilePickerChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // The engine outlives configuration changes, so the channel keeps its
        // pending operation and only needs the new activity.
        val existing = filePicker
        if (existing != null) {
            existing.attach(this)
        } else {
            filePicker = FilePickerChannel(this, flutterEngine.dartExecutor.binaryMessenger)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (filePicker?.onActivityResult(requestCode, resultCode, data) == true) {
            return
        }
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
    }
}
