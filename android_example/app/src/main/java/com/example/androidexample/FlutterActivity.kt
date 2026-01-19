package com.example.androidexample

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs

class FlutterHostActivity : FragmentActivity() {
    companion object {
        private const val EXTRA_ENGINE_ID = "engine_id"

        fun createIntent(context: Context, engineId: String): Intent {
            return Intent(context, FlutterHostActivity::class.java)
                .putExtra(EXTRA_ENGINE_ID, engineId)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
        }
    }
    
    private var flutterFragment: io.flutter.embedding.android.FlutterFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        // Set theme trước super.onCreate()
        setTheme(R.style.Theme_Android_example_Transparent)
        super.onCreate(savedInstanceState)
        
        // Đảm bảo window background transparent
        window.setBackgroundDrawableResource(android.R.color.transparent)
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.navigationBarColor = android.graphics.Color.TRANSPARENT
        
        // Remove dialog background dim
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
        
        // Enable drawing behind status bar
        window.setFlags(
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        )
        
        // QUAN TRỌNG: FLAG_NOT_TOUCH_MODAL cho phép touch events đi qua vùng transparent
        // về window bên dưới (MainActivity)
        // Tuy nhiên, với Activity, MainActivity đã bị pause nên không thể nhận events trực tiếp
        // Đây là hạn chế của Android Activity lifecycle
        window.setFlags(
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        )
        
        // FLAG_WATCH_OUTSIDE_TOUCH để biết khi user click outside
        window.setFlags(
            WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
            WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
        )
        
        // Clear decor view background
        window.decorView.setBackgroundColor(android.graphics.Color.TRANSPARENT)
        window.decorView.setBackgroundDrawable(null)
        
        // Đảm bảo content view cũng transparent
        window.decorView.post {
            val contentView = window.decorView.findViewById<View>(android.R.id.content)
            contentView?.setBackgroundColor(android.graphics.Color.TRANSPARENT)
            contentView?.setBackgroundDrawable(null)
        }
        
        // Setup FlutterFragment
        val engineId = intent.getStringExtra(EXTRA_ENGINE_ID) ?: return
        
        flutterFragment = io.flutter.embedding.android.FlutterFragment
            .withCachedEngine(engineId)
            .shouldAttachEngineToActivity(false)
            .build<io.flutter.embedding.android.FlutterFragment>()
        
        supportFragmentManager.beginTransaction()
            .replace(android.R.id.content, flutterFragment!!)
            .commit()
    }
    
    override fun onStart() {
        super.onStart()
        // Ensure window is full screen and transparent
        window.setLayout(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        window.setBackgroundDrawableResource(android.R.color.transparent)
        
        // Đảm bảo content view transparent sau khi Flutter view được attach
        window.decorView.post {
            val contentView = window.decorView.findViewById<View>(android.R.id.content)
            contentView?.setBackgroundColor(android.graphics.Color.TRANSPARENT)
            contentView?.setBackgroundDrawable(null)
        }
    }
    
    /**
     * Flag để kiểm soát khi nào cho phép Flutter tương tác
     * Tương tự allowFlutterInteraction trong iOS
     */
    var allowFlutterInteraction: Boolean = true
    
    /**
     * Override dispatchTouchEvent để forward touch events về MainActivity
     * khi touch ở vùng transparent hoặc không cho phép Flutter tương tác
     * 
     * Tương tự TransparentPassThroughWindow.hitTest trong iOS:
     * - Nếu allowFlutterInteraction == false, return nil (false) để events đi qua
     * - Nếu touch ở vùng transparent, return nil (false) để events đi qua
     * - Nếu touch vào Flutter content, xử lý bình thường
     */
    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        // Nếu không cho phép Flutter tương tác, forward events về MainActivity
        // Tương tự hitTest return nil trong iOS
        if (!allowFlutterInteraction) {
            return false
        }
        
        // Cho Flutter xử lý touch event trước
        // Với HitTestBehavior.translucent, Flutter sẽ return false nếu touch ở vùng transparent
        val handled = super.dispatchTouchEvent(ev)
        
        // Nếu Flutter không xử lý event (vùng transparent), forward về MainActivity
        // Tương tự hitTest return nil trong iOS khi touch ở vùng transparent
        if (!handled) {
            // Forward event về MainActivity
            // Với FLAG_NOT_TOUCH_MODAL, return false sẽ cho phép event đi qua về window bên dưới
            return false
        }
        
        return handled
    }
    
    /**
     * Tìm view tại vị trí touch
     */
    private fun findViewAt(view: View?, x: Int, y: Int): View? {
        if (view == null) return null
        
        // Kiểm tra xem touch có trong bounds của view không
        val location = IntArray(2)
        view.getLocationOnScreen(location)
        val viewX = x - location[0]
        val viewY = y - location[1]
        
        if (viewX >= 0 && viewX < view.width && viewY >= 0 && viewY < view.height) {
            // Touch trong bounds của view này
            if (view is ViewGroup) {
                // Tìm child view tại vị trí touch (từ trên xuống dưới)
                for (i in view.childCount - 1 downTo 0) {
                    val child = view.getChildAt(i)
                    if (child.visibility == View.VISIBLE) {
                        val childView = findViewAt(child, x, y)
                        if (childView != null) return childView
                    }
                }
            }
            return view
        }
        
        return null
    }
    
    /**
     * Kiểm tra xem view có phải là Flutter view không
     */
    private fun isFlutterView(view: View?): Boolean {
        if (view == null) return false
        val className = view.javaClass.simpleName
        return className.contains("FlutterView") || 
               className.contains("FlutterSurfaceView") ||
               className.contains("FlutterTextureView")
    }
    
    /**
     * Tìm Flutter view trong view hierarchy
     */
    private fun findFlutterView(view: View?): View? {
        if (view == null) return null
        
        // Flutter view thường có class name chứa "FlutterView" hoặc "FlutterSurfaceView"
        val className = view.javaClass.simpleName
        if (className.contains("FlutterView") || className.contains("FlutterSurfaceView")) {
            return view
        }
        
        // Tìm trong children
        if (view is ViewGroup) {
            for (i in 0 until view.childCount) {
                val child = findFlutterView(view.getChildAt(i))
                if (child != null) return child
            }
        }
        
        return null
    }
    
    override fun finish() {
        super.finish()
        // Không có animation khi finish
        overridePendingTransition(0, 0)
    }
}