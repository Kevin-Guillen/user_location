package com.example.user_location_plugin

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


class UserLocationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity


    private lateinit var permissionEventChannel: EventChannel
    private lateinit var permissionEventSource: EventChannel.EventSink
    private var permissionStreamHandler: EventChannel.StreamHandler =
        object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    permissionEventSource = events
                }
            }

            override fun onCancel(arguments: Any?) {

            }
        }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, USER_LOCATION_PLUGIN)
        channel.setMethodCallHandler(this)
        permissionEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, PERMISSION_EVENT_CHANNEL)
        permissionEventChannel.setStreamHandler(permissionStreamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            GET_PLATFORM_VERSION -> getPlatformVersion(result)
            REQUEST_PERMISSION -> requestPermission(result)
            CHECK_PERMISSION -> checkPermission(result)
            else -> result.notImplemented()
        }
    }


    private fun requestPermission(result: Result) {
        context?.run {
            activity?.apply {
                requestPermissions(
                    this,
                    arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ),
                    REQUEST_PERMISSION_CODE
                )
            }
        }
        result.success(null)
    }

    private fun checkPermission(result: Result): Boolean {
        var permitted = false
        context?.run {
            permitted = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
                    && ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            permissionEventSource?.success(
                if (permitted) PERMISSION_GRANTED else permissionEventSource?.success(
                    PERMISSION_DENIED
                )
            )
        }
        result.success(permitted)
        return permitted
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.i("onDetachedConfigChanges", "onDetachedFromConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.i("onReattachedToActivity", "onReattachedToActivityForConfigChanges")
    }

    override fun onDetachedFromActivity() {
        Log.i("onDetachedFromActivty", "onDetachedFromActivity")
    }

    private fun getPlatformVersion(result: Result) {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.i("onActivityResult", "onActivityResult")
        return true
    }

    companion object PluginConstants {
        const val USER_LOCATION_PLUGIN = "user_location_plugin"
        const val PERMISSION_EVENT_CHANNEL = "permission_event_channel"
        const val GET_PLATFORM_VERSION = "getPlatformVersion"
        const val REQUEST_PERMISSION = "requestPermission"
        const val CHECK_PERMISSION = "checkPermission"
        const val PERMISSION_GRANTED = "Permission Granted"
        const val PERMISSION_DENIED = "Permission Denied"
        const val REQUEST_PERMISSION_CODE = 500
    }
}