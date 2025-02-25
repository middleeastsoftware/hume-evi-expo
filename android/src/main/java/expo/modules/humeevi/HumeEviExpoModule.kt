package expo.modules.humeevi

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import com.hume.evi.EviClient
import com.hume.evi.EviStream
import com.hume.evi.EviStreamConfig
import android.util.Base64

class HumeEviExpoModule : Module() {
  private var eviClient: EviClient? = null
  private var eviStream: EviStream? = null

  override fun definition() = ModuleDefinition {
    Name("HumeEviExpo")

    AsyncFunction("initialize") { config: Map<String, Any> ->
      val apiKey = config["apiKey"] as String
      val baseUrl = config["baseUrl"] as? String
      
      eviClient = EviClient.Builder()
        .setApiKey(apiKey)
        .setBaseUrl(baseUrl)
        .build()
    }

    AsyncFunction("startStream") { config: Map<String, Any> ->
      val sampleRate = (config["sampleRate"] as Number).toInt()
      val channels = (config["channels"] as? Number)?.toInt() ?: 1
      val bitsPerSample = (config["bitsPerSample"] as? Number)?.toInt() ?: 16

      val streamConfig = EviStreamConfig.Builder()
        .setSampleRate(sampleRate)
        .setChannels(channels)
        .setBitsPerSample(bitsPerSample)
        .build()

      eviStream = eviClient?.createStream(streamConfig)
      eviStream?.setResultListener { result ->
        sendEvent("onEviResult", mapOf(
          "score" to result.score,
          "confidence" to result.confidence,
          "timestamp" to result.timestamp
        ))
      }
    }

    AsyncFunction("stopStream") {
      eviStream?.stop()
      eviStream = null
    }

    AsyncFunction("processAudioChunk") { audioData: String ->
      val data = Base64.decode(audioData, Base64.DEFAULT)
      eviStream?.processAudioData(data)
    }

    Events("onEviResult")
  }
} 