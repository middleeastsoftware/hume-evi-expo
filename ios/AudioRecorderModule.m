#import <ExpoModulesCore/ExpoModulesCore.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorderModule : EXModule

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioFormat *recordingFormat;

@end

@implementation AudioRecorderModule

EX_REGISTER_MODULE();

- (const NSString *)name {
  return @"AudioRecorder";
}

- (void)setupAudioSession {
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory:AVAudioSessionCategoryRecord error:nil];
  [session setActive:YES error:nil];
}

EX_EXPORT_METHOD_AS(requestPermissions,
                    requestPermissionsWithResolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
    resolve(@(granted));
  }];
}

EX_EXPORT_METHOD_AS(startRecording,
                    startRecording:(NSDictionary *)config
                    resolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  [self setupAudioSession];
  
  NSNumber *sampleRate = config[@"sampleRate"];
  NSNumber *channels = config[@"channels"] ?: @1;
  
  self.audioEngine = [[AVAudioEngine alloc] init];
  AVAudioInputNode *inputNode = self.audioEngine.inputNode;
  
  self.recordingFormat = [[AVAudioFormat alloc] 
    initWithCommonFormat:AVAudioPCMFormatFloat32
    sampleRate:[sampleRate doubleValue]
    channels:[channels unsignedIntegerValue]
    interleaved:NO];
  
  [inputNode installTapOnBus:0 bufferSize:1024 format:self.recordingFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
    // Convert buffer to base64 and send to HumeEviExpoModule
    NSData *audioData = [self convertBufferToData:buffer];
    NSString *base64String = [audioData base64EncodedStringWithOptions:0];
    [[EXModuleRegistry sharedInstance] eventEmitterForModule:@"HumeEviExpo"].sendEventWithName(@"audioData", base64String);
  }];
  
  [self.audioEngine startAndReturnError:nil];
  resolve(nil);
}

EX_EXPORT_METHOD_AS(stopRecording,
                    stopRecordingWithResolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  [self.audioEngine.inputNode removeTapOnBus:0];
  [self.audioEngine stop];
  resolve(nil);
}

- (NSData *)convertBufferToData:(AVAudioPCMBuffer *)buffer {
  // Implementation of buffer conversion
  // This needs to match the format expected by Hume EVI
  return [NSData data]; // Placeholder
}

@end 