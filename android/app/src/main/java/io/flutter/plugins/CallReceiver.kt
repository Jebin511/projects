package com.example.cyber_sheild

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.MediaRecorder
import android.telephony.TelephonyManager
import android.util.Log

class CallReceiver : BroadcastReceiver() {

    companion object {
        private var lastState = TelephonyManager.CALL_STATE_IDLE
        private var recorder: MediaRecorder? = null
    }

    override fun onReceive(context: Context, intent: Intent) {
        val stateStr = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
        val number = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

        var state = TelephonyManager.CALL_STATE_IDLE
        when (stateStr) {
            TelephonyManager.EXTRA_STATE_IDLE -> state = TelephonyManager.CALL_STATE_IDLE
            TelephonyManager.EXTRA_STATE_OFFHOOK -> state = TelephonyManager.CALL_STATE_OFFHOOK
            TelephonyManager.EXTRA_STATE_RINGING -> state = TelephonyManager.CALL_STATE_RINGING
        }

        Log.d("CallReceiver", "State: $stateStr, Number: $number")

        when (state) {
            TelephonyManager.CALL_STATE_RINGING -> {
                Log.i("CallReceiver", "📞 Incoming call from: $number")
                // You can notify Flutter here
            }
            TelephonyManager.CALL_STATE_OFFHOOK -> {
                Log.i("CallReceiver", "✅ Call started or answered")

                // 🎙️ Start recording
                try {
                    recorder = MediaRecorder().apply {
                        setAudioSource(MediaRecorder.AudioSource.VOICE_COMMUNICATION) // Or MIC if fails
                        setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)
                        setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)
                        setOutputFile("${context.filesDir.absolutePath}/recorded_call.3gp")
                        prepare()
                        start()
                    }
                    Log.d("CallReceiver", "🎙️ Recording started")
                } catch (e: Exception) {
                    Log.e("CallReceiver", "Recording failed: ${e.localizedMessage}")
                }
            }
            TelephonyManager.CALL_STATE_IDLE -> {
                if (lastState == TelephonyManager.CALL_STATE_OFFHOOK) {
                    Log.i("CallReceiver", "📴 Call ended")

                    // 🛑 Stop recording
                    try {
                        recorder?.apply {
                            stop()
                            release()
                        }
                        recorder = null
                        Log.d("CallReceiver", "🛑 Recording stopped")
                    } catch (e: Exception) {
                        Log.e("CallReceiver", "Stopping recording failed: ${e.localizedMessage}")
                    }
                }
            }
        }

        lastState = state
    }
}