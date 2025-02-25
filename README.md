# hume-evi-expo

Hume Evi integration for Expo/React Native applications - Analyze emotions from voice in real-time.

## Installation

```bash
npx expo install hume-evi-expo
```

## Usage

```typescript
import HumeEviExpoModule from 'hume-evi-expo';

// Initialize the module with your API key
await HumeEviExpoModule.initialize({
  apiKey: 'your-hume-api-key-here'
});

// Analyze emotions from audio data
const emotionResult = await HumeEviExpoModule.analyzeEmotion(audioData);
console.log(emotionResult);
```

## API Reference

### initialize(config: HumeEviConfig)
Initializes the Hume Evi module with your API credentials.

```typescript
type HumeEviConfig = {
  apiKey: string;
  baseUrl?: string;
};
```

### analyzeEmotion(audioData: string): Promise<EmotionResult>
Analyzes emotions from the provided audio data.

```typescript
type EmotionResult = {
  joy: number;
  sadness: number;
  anger: number;
  fear: number;
  surprise: number;
};
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT
