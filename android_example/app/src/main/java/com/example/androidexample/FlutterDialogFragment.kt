package com.example.androidexample

import android.app.Dialog
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class FlutterDialogFragment : DialogFragment() {
    companion object {
        private const val ARG_ENGINE_ID = "engine_id"
        private const val CHANNEL_NAME = "com.example.flutter/method_channel"

        fun newInstance(engineId: String): FlutterDialogFragment {
            val fragment = FlutterDialogFragment()
            val args = Bundle()
            args.putString(ARG_ENGINE_ID, engineId)
            fragment.arguments = args
            return fragment
        }
    }

    private var flutterFragment: FlutterFragment? = null
    private var methodChannel: MethodChannel? = null
    private val handler = Handler(Looper.getMainLooper())
    private var toggleFlagRunnable: Runnable? = null

    private fun getFlutterEngine(): FlutterEngine? {
        val engineId = arguments?.getString(ARG_ENGINE_ID) ?: return null
        return FlutterEngineCache.getInstance().get(engineId)
    }

    fun callFlutterMethod(methodName: String, arguments: Any? = null, callback: (Any?) -> Unit) {
        val flutterEngine = getFlutterEngine()
        if (flutterEngine != null) {
            FlutterMethodCaller.callFlutterMethod(
                flutterEngine = flutterEngine,
                methodName = methodName,
                arguments = arguments,
                onSuccess = { result ->
                    callback(result)
                },
                onError = { exception ->
                    callback(null)
                }
            )
        } else {
            callback(null)
        }
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = super.onCreateDialog(savedInstanceState)

        dialog.window?.apply {
            setBackgroundDrawableResource(android.R.color.transparent)
            setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
            clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
            setFlags(
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
            )
            setFlags(
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
            )
        }

        dialog.setCanceledOnTouchOutside(false)
        return dialog
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val frameLayout = FrameLayout(requireContext()).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            setBackgroundColor(android.graphics.Color.TRANSPARENT)
            id = View.generateViewId()
        }
        return frameLayout
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val engineId = arguments?.getString(ARG_ENGINE_ID) ?: return

        flutterFragment = FlutterFragment.withCachedEngine(engineId)
            .shouldAttachEngineToActivity(false)
            .build()

        childFragmentManager.beginTransaction()
            .replace(view.id, flutterFragment!!)
            .commit()

        setupMethodChannel()
    }

    private fun setupMethodChannel() {
        val flutterEngine = getFlutterEngine() ?: return
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getNativeData" -> {
                    android.util.Log.d(
                        "FlutterDialogFragment",
                        "Nhận được method call: getNativeData với arguments: $call.arguments"
                    )
                    val nativeData = getNativeData(call.arguments)
                    android.util.Log.d("FlutterDialogFragment", "Trả về dữ liệu: $nativeData")
                    result.success(nativeData)
                }

                else -> {
                    android.util.Log.d("FlutterDialogFragment", "Method không được implement: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    private fun getNativeData(arguments: Any?): Map<String, Any> {
        android.util.Log.d("FlutterDialogFragment", "getNativeData được gọi với arguments: $arguments")

        val data = mutableMapOf<String, Any>()
        data["platform"] = "Android"
        data["timestamp"] = System.currentTimeMillis()
        data["version"] = android.os.Build.VERSION.SDK_INT

        if (arguments is Map<*, *>) {
            val requestType = arguments["type"] as? String
            data["requestType"] = requestType ?: "unknown"

            android.util.Log.d("FlutterDialogFragment", "Request type: $requestType")

            when (requestType) {
                "userInfo" -> {
                    data["userName"] = "Android User"
                    data["userId"] = "android_12345"
                    android.util.Log.d("FlutterDialogFragment", "Trả về userInfo")
                }

                "deviceInfo" -> {
                    data["deviceModel"] = android.os.Build.MODEL
                    data["manufacturer"] = android.os.Build.MANUFACTURER
                    android.util.Log.d("FlutterDialogFragment", "Trả về deviceInfo: ${android.os.Build.MODEL}")
                }

                else -> {
                    data["message"] = "Default native data"
                    android.util.Log.d("FlutterDialogFragment", "Trả về default data")
                }
            }
        }

        android.util.Log.d("FlutterDialogFragment", "Dữ liệu cuối cùng: $data")
        return data
    }

    override fun onStart() {
        super.onStart()
        dialog?.window?.apply {
            setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        }

        toggleFlagRunnable = Runnable {
            toggleTouchFlags()
        }
        handler.postDelayed(toggleFlagRunnable!!, 10000) // 10 giây
    }

    private fun toggleTouchFlags() {
        dialog?.window?.apply {
            clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE)
        }
    }

    override fun onDestroyView() {
        // Cancel toggle flag runnable nếu chưa chạy
        toggleFlagRunnable?.let {
            handler.removeCallbacks(it)
        }
        toggleFlagRunnable = null

        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        flutterFragment = null
        super.onDestroyView()
    }
}