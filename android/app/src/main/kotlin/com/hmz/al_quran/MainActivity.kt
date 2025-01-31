package com.sahlaty.byAmrAlaa

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val CHANNEL = "timezone"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        /// Define the MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalTimezone") {
                try {
                    /// Get the IANA time zone ID
                    val timeZoneId = TimeZone.getDefault().id
                    result.success(timeZoneId) // Return the time zone to Flutter
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Failed to get time zone", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
