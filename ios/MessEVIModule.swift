import ExpoModulesCore
import AVFoundation
import Foundation

public class MessEVIModule: Module {

  private var inittedAudioSession: Bool = false

    // These should only be initialized after a call to `getPermissions`.
    private lazy var microphone: Microphone = {
        let microphone = Microphone()
        microphone.onError({ error in
            switch error {
            case MicrophoneError.conversionFailed(let details):
                self.sendEvent("onError", ["error": details])
            default:
                self.sendEvent("onError", ["error": "Unknown recording error"])
            }
        })
        return microphone
    }()
    private lazy var soundPlayer: SoundPlayer = {
        let soundPlayer = SoundPlayer()
        soundPlayer.onError({ error in
            switch error {
            case SoundPlayerError.invalidBase64String:
                self.sendEvent("onError", ["error": "Invalid base64 string"])
            case SoundPlayerError.couldNotPlayAudio:
                self.sendEvent("onError", ["error": "Could not play audio"])
            case SoundPlayerError.decodeError(let details):
                self.sendEvent("onError", ["error": details])
            default:
                self.sendEvent("onError", ["error": "Unknown playback error"])
            }
        })
        return soundPlayer
    }()
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('MessEVI')` in JavaScript.
    Name("MessEVI")
Constants(["sampleRate": Microphone.sampleRate, "isLinear16PCM": Microphone.isLinear16PCM])

        Events("onAudioInput", "onError")

        AsyncFunction("getPermissions") {
            return try await self.getPermissions()
        }

        AsyncFunction("startRecording") {
            try ensureInittedAudioSession()
            try self.microphone.startRecording(onBase64EncodedAudio: { (data: String) in
                self.sendEvent("onAudioInput", ["base64EncodedAudio": data])
            })
        }

        AsyncFunction("stopRecording") {
            try ensureInittedAudioSession()
            self.microphone.stopRecording()
        }

        AsyncFunction("mute") {
            self.microphone.mute()
        }
        AsyncFunction("unmute") {
            self.microphone.unmute()
        }

        AsyncFunction("enqueueAudio") { (base64EncodedAudio: String) in
            try ensureInittedAudioSession()
            return try await self.soundPlayer.enqueueAudio(base64EncodedAudio)
        }
        AsyncFunction("stopPlayback") {
            self.soundPlayer.stopPlayback()
        }
    
  }
  private func getPermissions() async throws -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .granted:
            return true
        case .denied:
            return false
        case .undetermined:
            return await withCheckedContinuation { continuation in
                audioSession.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default:
            throw NSError(
                domain: "AudioModule", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unknown permission state"])
        }
    }

    private func ensureInittedAudioSession() throws {
        if self.inittedAudioSession { return }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(
            .playAndRecord, mode: .voiceChat,
            options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
        try audioSession.setActive(true)
        inittedAudioSession = true
    }
}
