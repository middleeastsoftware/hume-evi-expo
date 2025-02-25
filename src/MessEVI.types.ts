import type { StyleProp, ViewStyle } from 'react-native';

export type OnLoadEventPayload = {
  url: string;
};

export type MessEVIModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
};

export type ChangeEventPayload = {
  value: string;
};

export type MessEVIViewProps = {
  url: string;
  onLoad: (event: { nativeEvent: OnLoadEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
};


export type AudioModuleEvents = {
  onAudioInput: (params: AudioEventPayload) => void;
  onError: (params: { message: string }) => void;
};

export type AudioEventPayload = {
  base64EncodedAudio: string;
};
