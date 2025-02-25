import { NativeModule, requireNativeModule } from 'expo';
import { MessEVIModuleEvents } from './MessEVI.types';

declare class MessEVIModule extends NativeModule<MessEVIModuleEvents> {
  getPermissions(): Promise<void>;
  startRecording(): Promise<void>;
  enqueueAudio(base64EncodedAudio: string): Promise<void>;
  stopPlayback(): Promise<void>;
  mute(): Promise<void>;
  unmute(): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<MessEVIModule>('MessEVI');
