package com.coinerapp.coiner

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.util.Log

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        private val LOG_CHANNEL = "coiner/log"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "nativeLog") {
                val level = call.argument<String>("level")
                val message = call.argument<String>("message")

                when (level) {
                    "ERROR" -> Log.e("Coiner", message ?: "Unknown Error")
                    "WARNING" -> Log.w("Coiner", message ?: "Unknown Warning")
                    "DEBUG" -> Log.d("Coiner", message ?: "Debug Log")
                    else -> Log.i("Coiner", message ?: "Info Log")
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
