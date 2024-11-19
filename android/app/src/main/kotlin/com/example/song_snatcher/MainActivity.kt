package com.example.track_catcher

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.trackcatcher/share"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up the MethodChannel
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getShareData") {
                // Extract shared data (for example, from an Intent)
                if (Intent.ACTION_SEND == intent.action && intent.type != null) {
                    if ("text/plain" == intent.type) {
                        val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
                        if (sharedText != null) {
                            result.success(sharedText)  // Send shared text back to Flutter
                        } else {
                            result.error("UNAVAILABLE", "Shared text not available", null)
                        }
                    } else {
                        result.error("INVALID_TYPE", "Expected text/plain", null)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
