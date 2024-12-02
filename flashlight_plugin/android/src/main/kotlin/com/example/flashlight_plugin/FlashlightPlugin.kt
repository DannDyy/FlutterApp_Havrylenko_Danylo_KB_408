package com.example.flashlight_plugin

import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class FlashlightPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var cameraManager: CameraManager
  private var cameraId: String? = null
  private var isFlashOn = false

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
    channel.setMethodCallHandler(this)

    cameraManager = flutterPluginBinding.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    try {
      for (id in cameraManager.cameraIdList) {
        val hasFlash = cameraManager.getCameraCharacteristics(id)
          .get(android.hardware.camera2.CameraCharacteristics.FLASH_INFO_AVAILABLE)
        val lensFacing = cameraManager.getCameraCharacteristics(id)
          .get(android.hardware.camera2.CameraCharacteristics.LENS_FACING)
        if (hasFlash == true && lensFacing == android.hardware.camera2.CameraCharacteristics.LENS_FACING_BACK) {
          cameraId = id
          break
        }
      }
    } catch (e: CameraAccessException) {
      e.printStackTrace()
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "toggleFlashlight" -> toggleFlashlight(result)
      else -> result.notImplemented()
    }
  }

  private fun toggleFlashlight(result: MethodChannel.Result) {
    if (cameraId == null) {
      result.error("NO_CAMERA", "No camera with flashlight found", null)
      return
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      try {
        cameraManager.setTorchMode(cameraId!!, !isFlashOn)
        isFlashOn = !isFlashOn
        result.success(isFlashOn)
      } catch (e: CameraAccessException) {
        result.error("CAMERA_ERROR", "Error accessing the camera.", null)
      }
    } else {
      result.error("UNSUPPORTED", "Flashlight toggle not supported on this Android version.", null)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
