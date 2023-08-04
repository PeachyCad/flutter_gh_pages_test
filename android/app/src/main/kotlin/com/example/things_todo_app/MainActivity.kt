package com.example.things_todo_app

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter/device_info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
 
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getDeviceInfo") {
                val deviceInfo: HashMap<String, String> = getDeviceInfo()
                if (deviceInfo.isNotEmpty()) {
                    result.success(deviceInfo)
                } else {
                    result.error("UNAVAILABLE", "Device info not available.", null)
                }
            } else {
                result.notImplemented()
            }
 
        }
    }
 
    private fun getDeviceInfo(): HashMap<String, String> {
        val deviceInfo = HashMap<String, String>()
        deviceInfo["version"] = System.getProperty("os.version").toString() 
        deviceInfo["device"] = android.os.Build.DEVICE         
        deviceInfo["model"] = android.os.Build.MODEL
        deviceInfo["product"] = android.os.Build.PRODUCT          
        return deviceInfo
    }
}