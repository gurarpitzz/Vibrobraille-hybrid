package com.vibrobraille.haptics

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HapticBridge(private val context: Context) : MethodChannel.MethodCallHandler {
    private val vibrator: Vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        (context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager).defaultVibrator
    } else {
        context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
    }

    private var motorScale: Float = 1.0f

    fun setScale(scale: Float) {
        this.motorScale = scale
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "vibrateWaveform" -> {
                val timings = call.argument<List<Long>>("timings")
                val amplitudes = call.argument<List<Int>>("amplitudes")
                android.util.Log.d("VibroHaptics", "Received vibration request: Timings=$timings, Amplitudes=$amplitudes")
                
                if (timings != null && amplitudes != null) {
                    try {
                        playWaveform(timings.toLongArray(), amplitudes.toIntArray())
                        result.success(null)
                    } catch (e: Exception) {
                        android.util.Log.e("VibroHaptics", "Error playing waveform: ${e.message}")
                        // Emergency fallback: standard vibration
                        val totalDuration = timings.map { it }.sum()
                        vibrator.vibrate(totalDuration) 
                        result.success(null) 
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Timings or amplitudes missing", null)
                }
            }
            "setMotorScale" -> {
                val scale = call.argument<Double>("scale")?.toFloat()
                if (scale != null) {
                    motorScale = scale
                    result.success(null)
                }
            }
            "cancel" -> {
                vibrator.cancel()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun playWaveform(timings: LongArray, amplitudes: IntArray) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Apply motor scale to amplitudes
            val scaledAmplitudes = amplitudes.map { (it * motorScale).toInt().coerceIn(0, 255) }.toIntArray()
            
            val effect = VibrationEffect.createWaveform(timings, scaledAmplitudes, -1)
            vibrator.vibrate(effect)
        } else {
            // Fallback for older devices (only timings supported)
            vibrator.vibrate(timings, -1)
        }
    }
}
