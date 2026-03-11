package com.yaralma.yaralma_app

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.FrameLayout
import androidx.core.content.ContextCompat

/**
 * YARALMA Shield: overlay over YouTube and Netflix when lock is active.
 * Listens for Supabase is_locked via SharedPreferences (written by Flutter when realtime updates).
 */
class YaralmaAccessibilityService : AccessibilityService() {

    private var overlayView: FrameLayout? = null
    private var windowManager: WindowManager? = null

    private val targetPackages = setOf(
        "com.google.android.youtube",
        "com.netflix.mediaclient"
    )

    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
            packageNames = targetPackages.toTypedArray()
        }
        serviceInfo = info
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        event.packageName?.toString()?.let { pkg ->
            if (targetPackages.contains(pkg)) {
                updateOverlay(isLocked(), pkg)
            } else {
                removeOverlay()
            }
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

    companion object {
        const val PREFS_NAME = "yaralma_override"
        const val KEY_IS_LOCKED = "is_locked"
    }
}
