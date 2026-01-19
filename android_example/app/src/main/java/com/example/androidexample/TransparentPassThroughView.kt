package com.example.androidexample

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup

/**
 * Custom ViewGroup tương tự TransparentPassThroughView trong iOS
 * Cho phép touch events đi qua vùng transparent về MainActivity
 */
class TransparentPassThroughView @JvmOverloads constructor(
    context: Context,
    attrs: android.util.AttributeSet? = null,
    defStyleAttr: Int = 0
) : ViewGroup(context, attrs, defStyleAttr) {
    
    /**
     * Flag để kiểm soát khi nào cho phép Flutter tương tác
     * Tương tự allowFlutterInteraction trong iOS
     */
    var allowFlutterInteraction: Boolean = true
    
    init {
        setBackgroundColor(android.graphics.Color.TRANSPARENT)
    }
    
    override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
        // Layout children
        for (i in 0 until childCount) {
            val child = getChildAt(i)
            child.layout(0, 0, width, height)
        }
    }
    
    /**
     * Override onInterceptTouchEvent để cho phép touch events đi qua
     * khi touch ở vùng transparent hoặc không cho phép Flutter tương tác
     * Tương tự hitTest return nil trong iOS
     */
    override fun onInterceptTouchEvent(ev: MotionEvent): Boolean {
        // Nếu không cho phép Flutter tương tác, cho phép events đi qua
        if (!allowFlutterInteraction) {
            return false
        }
        
        // Kiểm tra xem touch có ở vùng có Flutter content không
        val viewAtTouch = findViewAt(ev.x.toInt(), ev.y.toInt())
        
        // Nếu touch ở vùng transparent (không có view nào), cho phép events đi qua
        if (viewAtTouch == null || viewAtTouch == this) {
            return false
        }
        
        // Nếu touch vào Flutter view, xử lý bình thường
        return super.onInterceptTouchEvent(ev)
    }
    
    /**
     * Override dispatchTouchEvent để forward events về MainActivity
     * khi touch ở vùng transparent
     */
    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        // Nếu không cho phép Flutter tương tác, forward events về MainActivity
        if (!allowFlutterInteraction) {
            return false
        }
        
        // Kiểm tra xem touch có ở vùng có Flutter content không
        val viewAtTouch = findViewAt(ev.x.toInt(), ev.y.toInt())
        
        // Nếu touch ở vùng transparent (không có view nào), forward về MainActivity
        if (viewAtTouch == null || viewAtTouch == this) {
            return false
        }
        
        // Nếu touch vào Flutter view, xử lý bình thường
        return super.dispatchTouchEvent(ev)
    }
    
    /**
     * Tìm view tại vị trí touch
     * Tương tự hitTest trong iOS
     */
    private fun findViewAt(x: Int, y: Int): View? {
        // Tìm từ trên xuống dưới (từ child cuối cùng)
        for (i in childCount - 1 downTo 0) {
            val child = getChildAt(i)
            if (child.visibility == View.VISIBLE) {
                val childX = x - child.left
                val childY = y - child.top
                
                if (childX >= 0 && childX < child.width && 
                    childY >= 0 && childY < child.height) {
                    // Touch trong bounds của child
                    if (child is ViewGroup) {
                        val viewInChild = (child as ViewGroup).findViewAt(childX, childY)
                        if (viewInChild != null) return viewInChild
                    }
                    return child
                }
            }
        }
        
        return null
    }
    
    /**
     * Extension function để tìm view tại vị trí trong ViewGroup
     */
    private fun ViewGroup.findViewAt(x: Int, y: Int): View? {
        for (i in childCount - 1 downTo 0) {
            val child = getChildAt(i)
            if (child.visibility == View.VISIBLE) {
                val childX = x - child.left
                val childY = y - child.top
                
                if (childX >= 0 && childX < child.width && 
                    childY >= 0 && childY < child.height) {
                    if (child is ViewGroup) {
                        val viewInChild = child.findViewAt(childX, childY)
                        if (viewInChild != null) return viewInChild
                    }
                    return child
                }
            }
        }
        return null
    }
}

