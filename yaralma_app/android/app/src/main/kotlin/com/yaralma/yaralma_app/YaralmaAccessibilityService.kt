package com.yaralma.yaralma_app

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.FrameLayout
import android.widget.TextView
import androidx.core.content.ContextCompat

/**
 * YARALMA Shield: overlay over YouTube and Netflix when lock is active.
 * Also monitors YouTube search for blocked keywords (YouTube Guardian).
 */
class YaralmaAccessibilityService : AccessibilityService() {

    private var overlayView: FrameLayout? = null
    private var searchBlockOverlay: FrameLayout? = null
    private var windowManager: WindowManager? = null
    private var currentPackage: String? = null

    private val targetPackages = setOf(
        "com.google.android.youtube",
        "com.netflix.mediaclient"
    )

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                         AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED or
                         AccessibilityEvent.TYPE_VIEW_FOCUSED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS or
                    AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
            packageNames = targetPackages.toTypedArray()
        }
        serviceInfo = info
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val pkg = event.packageName?.toString() ?: return
        currentPackage = pkg

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                if (targetPackages.contains(pkg)) {
                    updateOverlay(isLocked(), pkg)
                    removeSearchBlockOverlay()
                } else {
                    removeOverlay()
                    removeSearchBlockOverlay()
                }
            }
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED -> {
                if (pkg == "com.google.android.youtube") {
                    checkSearchText(event)
                }
            }
        }
    }

    private fun checkSearchText(event: AccessibilityEvent) {
        val text = event.text?.joinToString(" ")?.lowercase() ?: return
        if (text.isEmpty()) {
            removeSearchBlockOverlay()
            return
        }

        val blockedKeywords = getBlockedKeywords()
        val foundBlocked = blockedKeywords.any { keyword ->
            text.contains(keyword.lowercase())
        }

        if (foundBlocked) {
            showSearchBlockOverlay()
            incrementSearchBlocked()
        } else {
            removeSearchBlockOverlay()
        }
    }

    override fun onInterrupt() {
        removeOverlay()
    }

    override fun onUnbind(intent: Intent?): Boolean {
        removeOverlay()
        return super.onUnbind(intent)
    }

    private fun isLocked(): Boolean {
        return getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getBoolean(KEY_IS_LOCKED, false)
    }

    private fun updateOverlay(locked: Boolean, currentPackage: String) {
        if (locked) {
            showOverlay()
        } else {
            removeOverlay()
        }
    }

    private fun showOverlay() {
        if (overlayView != null) return
        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0
            y = 0
        }
        val view = FrameLayout(this).apply {
            setBackgroundColor(ContextCompat.getColor(this@YaralmaAccessibilityService, android.R.color.holo_red_dark))
            alpha = 0.3f
        }
        overlayView = view
        windowManager?.addView(view, layoutParams)
    }

    private fun removeOverlay() {
        overlayView?.let {
            windowManager?.removeView(it)
            overlayView = null
        }
    }

    private fun getBlockedKeywords(): Set<String> {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val keywordsJson = prefs.getString(KEY_BLOCKED_KEYWORDS, null)
        if (keywordsJson != null) {
            return keywordsJson.split(",").map { it.trim().lowercase() }.toSet()
        }
        // Default fallback keywords
        return DEFAULT_BLOCKED_KEYWORDS
    }

    private fun showSearchBlockOverlay() {
        if (searchBlockOverlay != null) return

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
        }

        val view = FrameLayout(this).apply {
            setBackgroundColor(Color.argb(230, 0, 0, 0))

            val textView = TextView(this@YaralmaAccessibilityService).apply {
                text = "🦁 YARALMA Guardian\n\nThis search is not allowed.\nTap back to continue."
                setTextColor(Color.WHITE)
                textSize = 18f
                gravity = Gravity.CENTER
                setPadding(48, 48, 48, 48)
            }
            addView(textView, FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            ).apply {
                gravity = Gravity.CENTER
            })
        }

        searchBlockOverlay = view
        windowManager?.addView(view, layoutParams)
    }

    private fun removeSearchBlockOverlay() {
        searchBlockOverlay?.let {
            try {
                windowManager?.removeView(it)
            } catch (e: Exception) {
                // View might not be attached
            }
            searchBlockOverlay = null
        }
    }

    private fun incrementSearchBlocked() {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val count = prefs.getInt(KEY_SEARCHES_BLOCKED, 0)
        prefs.edit().putInt(KEY_SEARCHES_BLOCKED, count + 1).apply()
    }

    companion object {
        const val PREFS_NAME = "yaralma_override"
        const val KEY_IS_LOCKED = "is_locked"
        const val KEY_BLOCKED_KEYWORDS = "blocked_keywords"
        const val KEY_SEARCHES_BLOCKED = "searches_blocked_today"

        val DEFAULT_BLOCKED_KEYWORDS = setOf(
            "porn", "porno", "xxx", "sex", "sexe", "nude", "naked", "nu", "nue",
            "seins", "drogue", "drugs", "violence", "arme", "gun",
            "casino", "pari", "gambling"
        )
    }
}
