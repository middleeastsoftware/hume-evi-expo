import ExpoModulesCore

public class HumeEviExpoModuleImpl: Module {
  public func definition() -> ModuleDefinition {
    Name("HumeEvi")  // Keep this the same for JS compatibility

    // Define events that can be emitted to JavaScript
    Events("result", "error")

    Function("on") { [weak self] (eventName: String) in
      // Event handling will be implemented later
    }

    Function("removeAllListeners") { [weak self] in
      // Cleanup will be implemented later
    }

    AsyncFunction("startStream") { [weak self] (config: [String: Any], promise: Promise) in
      guard let sampleRate = config["sampleRate"] as? Int,
            let channels = config["channels"] as? Int,
            let bitsPerSample = config["bitsPerSample"] as? Int
      else {
        promise.reject(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid configuration"]))
        return
      }
      
      // Stream initialization will be implemented later
      promise.resolve(nil)
    }

    AsyncFunction("stopStream") { [weak self] (promise: Promise) in
      // Stream cleanup will be implemented later
      promise.resolve(nil)
    }

    AsyncFunction("sendAudioChunk") { [weak self] (data: [UInt8], promise: Promise) in
      // Audio processing will be implemented later
      promise.resolve(nil)
    }
  }
} 