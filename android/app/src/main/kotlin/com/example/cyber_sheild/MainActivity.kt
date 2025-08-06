package com.example.cyber_sheild

import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourapp.protection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startMonitoring" -> {
                    val context: Context = applicationContext
                    val intent = Intent(context, CallMonitorService::class.java)
                    context.startService(intent)
                    result.success("Monitoring Started")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}