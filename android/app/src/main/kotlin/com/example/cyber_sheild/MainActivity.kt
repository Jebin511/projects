package com.example.cyber_sheild

import android.media.MediaRecorder
import android.os.Environment
import android.os.Handler
import android.media.MediaScannerConnection
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.yourapp.protection"
    private var mediaRecorder: MediaRecorder? = null
    private var outputFilePath: String? = null
    private val handler by lazy { Handler(mainLooper) }  // Lazy initialization to avoid NPE

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startMonitoring" -> {
                    val started = startRecording()
                    if (started) {
                        result.success("Recording started")
                    } else {
                        result.error("START_FAILED", "Failed to start recording", null)
                    }
                }
                "stopMonitoring" -> {
                    stopRecording()
                    result.success("Recording stopped, saved to: $outputFilePath")
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startRecording(): Boolean {
        try {
            val musicDir = getExternalFilesDir(Environment.DIRECTORY_MUSIC)
            if (musicDir != null && !musicDir.exists()) {
                musicDir.mkdirs()
            }

            val fileName = "protection_record.m4a"
            val file = File(musicDir, fileName)
            outputFilePath = file.absolutePath

            mediaRecorder = MediaRecorder().apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setAudioSamplingRate(44100)
                setAudioEncodingBitRate(128000)
                setOutputFile(outputFilePath)
                prepare()
                start()
            }

            Log.d("Recorder", "Recording started: $outputFilePath")
            return true

        } catch (e: IOException) {
            Log.e("Recorder", "startRecording failed: ${e.message}")
            return false
        } catch (e: IllegalStateException) {
            Log.e("Recorder", "startRecording illegal state: ${e.message}")
            return false
        }
    }

    private fun stopRecording() {
        try {
            mediaRecorder?.apply {
                stop()  // Finalize recording, write data
            }

            // Delay a bit to let file finalize properly
            handler.postDelayed({
                mediaRecorder?.apply {
                    reset()
                    release()
                }
                mediaRecorder = null

                // Trigger media scan so file is visible to other apps immediately
                outputFilePath?.let { path ->
                    MediaScannerConnection.scanFile(
                        this@MainActivity,
                        arrayOf(path),
                        arrayOf("audio/mp4"),
                        null
                    )
                }

                Log.d("Recorder", "Recording stopped and finalized, saved at: $outputFilePath")
            }, 500) // 500 ms delay before releasing

        } catch (e: RuntimeException) {
            Log.e("Recorder", "stopRecording failed: ${e.message}")
        }
    }
}
