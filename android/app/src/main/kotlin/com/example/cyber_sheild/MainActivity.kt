package com.example.cyber_sheild

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Environment
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourapp.protection"
    private var isRecording = false
    private var audioRecord: AudioRecord? = null
    private var recordingThread: Thread? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 🧠 Cache the engine for background use in services
        FlutterEngineCache
            .getInstance()
            .put("cyber_engine", flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startMonitoring" -> {
                    val context: Context = applicationContext

                    if (ActivityCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO)
                        != PackageManager.PERMISSION_GRANTED) {
                        result.error("PERMISSION_DENIED", "RECORD_AUDIO permission denied", null)
                        return@setMethodCallHandler
                    }

                    val path = startAudioRecording(context)
                    Log.d("MainActivity", "🎙️ Recording started at: $path")
                    result.success(path)
                }

                "stopMonitoring" -> {
                    stopAudioRecording()
                    Log.d("MainActivity", "🛑 Recording stopped")
                    result.success("Recording Stopped")
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startAudioRecording(context: Context): String {
        val sampleRate = 44100
        val channelConfig = AudioFormat.CHANNEL_IN_MONO
        val audioFormat = AudioFormat.ENCODING_PCM_16BIT
        val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)

        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            sampleRate,
            channelConfig,
            audioFormat,
            bufferSize
        )

        val fileName = "recording_${System.currentTimeMillis()}.pcm"
        val file = File(context.getExternalFilesDir(null), fileName)
        val outputStream = FileOutputStream(file)

        audioRecord?.startRecording()
        isRecording = true

        recordingThread = Thread {
            val buffer = ByteArray(bufferSize)
            while (isRecording) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    outputStream.write(buffer, 0, read)
                }
            }

            try {
                outputStream.flush()
                outputStream.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        recordingThread?.start()

        return file.absolutePath
    }

    private fun stopAudioRecording() {
        if (!isRecording) return

        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recordingThread = null
    }
} 