package com.example.cyber_sheild

import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.MediaRecorder
import android.os.Environment
import android.os.IBinder
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.util.Log
import kotlinx.coroutines.*
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.File
import java.io.IOException

class CallMonitorService : Service() {
    private var recorder: MediaRecorder? = null
    private var recordingFile: File? = null
    private val coroutineScope = CoroutineScope(Dispatchers.IO)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        telephonyManager.listen(CallListener(), PhoneStateListener.LISTEN_CALL_STATE)
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    inner class CallListener : PhoneStateListener() {
        override fun onCallStateChanged(state: Int, incomingNumber: String?) {
            when (state) {
                TelephonyManager.CALL_STATE_OFFHOOK -> {
                    startRecording()
                }
                TelephonyManager.CALL_STATE_IDLE -> {
                    stopRecordingAndSend()
                }
            }
        }
    }

    private fun startRecording() {
        val dir = getExternalFilesDir(Environment.DIRECTORY_MUSIC)
        recordingFile = File(dir, "call_recording_${System.currentTimeMillis()}.3gp")

        recorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)
            setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)
            setOutputFile(recordingFile!!.absolutePath)
            prepare()
            start()
        }

        Log.d("CallMonitorService", "Recording started: ${recordingFile?.absolutePath}")
    }

    private fun stopRecordingAndSend() {
        try {
            recorder?.apply {
                stop()
                release()
            }
            recorder = null

            recordingFile?.let {
                coroutineScope.launch {
                    uploadAndScanRecording(it)
                }
            }

        } catch (e: Exception) {
            Log.e("CallMonitorService", "Error stopping recording: ${e.message}")
        }
    }

    private fun uploadAndScanRecording(file: File) {
        val audioBytes = file.readBytes()

        val client = OkHttpClient()
        val mediaType = "audio/3gpp".toMediaTypeOrNull()
        val requestBody = audioBytes.toRequestBody(mediaType)

        val request = Request.Builder()
            .url("https://your-api.com/stream") // 🔁 Replace with your actual streaming endpoint
            .post(requestBody)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("Stream", "Failed to upload: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                val result = response.body?.string() // ✅ body is now a property
                Log.d("Stream", "API Response: $result")

                if (result?.contains("scam", ignoreCase = true) == true) {
                    Log.e("CallMonitorService", "⚠️ Scam call detected!")
                    // TODO: Alert logic (notification, broadcast, etc.)
                }
            }
        })
    }

    override fun onDestroy() {
        coroutineScope.cancel()
        super.onDestroy()
    }
}