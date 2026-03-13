package com.yaralma.yaralma_app

import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val settingsChannel = "com.yaralma.yaralma_app/settings"
    private val prefsChannel = "com.yaralma.yaralma_app/prefs"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Settings channel (accessibility)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, settingsChannel).setMethodCallHandler { call, result ->
            if (call.method == "openAccessibilitySettings") {
                try {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }

        // SharedPreferences channel (for syncing data to Accessibility Service)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, prefsChannel).setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences("yaralma_override", Context.MODE_PRIVATE)

            when (call.method) {
                "setBlockedKeywords" -> {
                    val keywords = call.argument<String>("keywords") ?: ""
                    prefs.edit().putString("blocked_keywords", keywords).apply()
                    result.success(true)
                }
                "setIsLocked" -> {
                    val locked = call.argument<Boolean>("locked") ?: false
                    prefs.edit().putBoolean("is_locked", locked).apply()
                    result.success(true)
                }
                "getSearchesBlockedToday" -> {
                    val count = prefs.getInt("searches_blocked_today", 0)
                    result.success(count)
                }
                "resetSearchesBlockedToday" -> {
                    prefs.edit().putInt("searches_blocked_today", 0).apply()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
