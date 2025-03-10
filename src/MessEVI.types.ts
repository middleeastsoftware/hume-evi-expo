
export type MessEVIModuleEvents = {
  onAudioInput: (params: AudioEventPayload) => void;
  onError: (params: { message: string }) => void;
};

export type AudioEventPayload = {
  base64EncodedAudio: string;
};
