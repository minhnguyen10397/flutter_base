package com.example.androidexample

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object FlutterMethodCaller {
    private const val CHANNEL_NAME = "com.example.flutter/method_channel"
    
    /**
     * Gọi Flutter method và nhận kết quả (asynchronous)
     * 
     * @param flutterEngine FlutterEngine đã được cache
     * @param methodName Tên method cần gọi trong Flutter
     * @param arguments Arguments truyền vào Flutter method (có thể là Map, List, String, Int, etc.)
     * @param onSuccess Callback khi method call thành công
     * @param onError Callback khi có lỗi xảy ra
     * 
     * Ví dụ:
     * FlutterMethodCaller.callFlutterMethod(
     *     flutterEngine = engine,
     *     methodName = "getData",
     *     arguments = mapOf("key" to "value"),
     *     onSuccess = { result -> 
     *         // Xử lý kết quả
     *     },
     *     onError = { exception ->
     *         // Xử lý lỗi
     *     }
     * )
     */
    fun callFlutterMethod(
        flutterEngine: FlutterEngine,
        methodName: String,
        arguments: Any? = null,
        onSuccess: (Any?) -> Unit,
        onError: (Exception) -> Unit
    ) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel.invokeMethod(methodName, arguments, object : MethodChannel.Result {
            override fun success(result: Any?) {
                onSuccess(result)
            }
            
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                onError(Exception("Flutter error: $errorCode - $errorMessage"))
            }
            
            override fun notImplemented() {
                onError(Exception("Method $methodName not implemented in Flutter"))
            }
        })
    }
}

