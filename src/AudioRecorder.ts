import { requireNativeModule } from 'expo-modules-core';

const AudioRecorderModule = requireNativeModule('AudioRecorder');

export type AudioRecorderConfig = {
  sampleRate: number;
  channels?: number;
  bitsPerSample?: number;
};

export class AudioRecorder {
  static async requestPermissions(): Promise<boolean> {
    return await AudioRecorderModule.requestPermissions();
  }

  static async startRecording(config: AudioRecorderConfig): Promise<void> {
    return await AudioRecorderModule.startRecording(config);
  }

  static async stopRecording(): Promise<void> {
    return await AudioRecorderModule.stopRecording();
  }
}

export default AudioRecorder; 