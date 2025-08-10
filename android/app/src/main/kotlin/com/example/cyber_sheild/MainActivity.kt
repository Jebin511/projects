package com.example.cyber_sheild

import android.media.MediaRecorder
import android.os.Environment
import android.media.MediaScannerConnection
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.yourapp.protection"
    private var mediaRecorder: MediaRecorder? = null
    private var outputFilePath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startMonitoring" -> {
                    val started = startRecording()
                    if (started) result.success("Recording started")
                    else result.error("START_FAILED", "Failed to start recording", null)
                }
                "stopMonitoring" -> {
                    stopRecording { path ->
                        result.success("Recording stopped, saved to: $path")
                    }
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

            val fileName = "protection_record_${System.currentTimeMillis()}.m4a"
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

    private fun stopRecording(onComplete: (String?) -> Unit) {
        thread { // Run in background thread to avoid blocking UI
            try {
                mediaRecorder?.apply {
                    stop()
                    release()
                }
                mediaRecorder = null

                outputFilePath?.let { path ->
                    MediaScannerConnection.scanFile(
                        this@MainActivity,
                        arrayOf(path),
                        arrayOf("audio/mp4"),
                        null
                    )
                    Log.d("Recorder", "Recording stopped and saved at: $path")
                }

                onComplete(outputFilePath)
            } catch (e: RuntimeException) {
                Log.e("Recorder", "stopRecording failed: ${e.message}")
                onComplete(null)
            }
        }
    }
}