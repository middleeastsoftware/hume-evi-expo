import { requireNativeModule } from 'expo-modules-core';

const HumeEviExpo = requireNativeModule('HumeEviExpo');

export type HumeEviConfig = {
  apiKey: string;
  baseUrl?: string;
};

export type EviResult = {
  score: number;
  confidence: number;
  timestamp: number;
};

export type StreamConfig = {
  sampleRate: number;
  channels?: number;
  bitsPerSample?: number;
};

export class HumeEviExpoModule {
  static async initialize(config: HumeEviConfig): Promise<void> {
    return await HumeEviExpo.initialize(config);
  }

  static async startStream(config: StreamConfig): Promise<void> {
    return await HumeEviExpo.startStream(config);
  }

  static async stopStream(): Promise<void> {
    return await HumeEviExpo.stopStream();
  }

  static async processAudioChunk(audioData: string): Promise<EviResult> {
    return await HumeEviExpo.processAudioChunk(audioData);
  }

  static addEviListener(callback: (result: EviResult) => void): void {
    HumeEviExpo.addEviListener(callback);
  }

  static removeEviListener(callback: (result: EviResult) => void): void {
    HumeEviExpo.removeEviListener(callback);
  }
}

export default HumeEviExpoModule; 