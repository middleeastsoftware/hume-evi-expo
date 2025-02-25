#import <ExpoModulesCore/ExpoModulesCore.h>
#import "HumeEviExpoModule.h"
#import <HumeEviSDK/HumeEviSDK.h>

@interface HumeEviExpoModule ()
@property (nonatomic, strong) id eviClient;
@property (nonatomic, strong) id eviStream;
@end

@implementation HumeEviExpoModule

EX_EXPORT_MODULE(HumeEviExpo)

- (void)definition {
  // The actual implementation is in Swift
}

- (const NSString *)name {
  return @"HumeEviExpo";
}

- (NSDictionary *)constantsToExport {
  return @{};
}

EX_EXPORT_METHOD_AS(initialize,
                    initialize:(NSDictionary *)config
                    resolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  NSString *apiKey = config[@"apiKey"];
  NSString *baseUrl = config[@"baseUrl"];
  
  self.eviClient = [[HumeEviClient alloc] initWithApiKey:apiKey baseUrl:baseUrl];
  resolve(nil);
}

EX_EXPORT_METHOD_AS(startStream,
                    startStream:(NSDictionary *)config
                    resolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  NSNumber *sampleRate = config[@"sampleRate"];
  NSNumber *channels = config[@"channels"] ?: @1;
  NSNumber *bitsPerSample = config[@"bitsPerSample"] ?: @16;
  
  HumeEviStreamConfig *streamConfig = [[HumeEviStreamConfig alloc] 
    initWithSampleRate:[sampleRate intValue]
    channels:[channels intValue]
    bitsPerSample:[bitsPerSample intValue]];
    
  self.eviStream = [self.eviClient createStreamWithConfig:streamConfig];
  
  [self.eviStream setResultHandler:^(HumeEviResult *result) {
    [self sendEventWithName:@"onEviResult" body:@{
      @"score": @(result.score),
      @"confidence": @(result.confidence),
      @"timestamp": @(result.timestamp)
    }];
  }];
  
  resolve(nil);
}

EX_EXPORT_METHOD_AS(stopStream,
                    stopStream:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  [self.eviStream stop];
  self.eviStream = nil;
  resolve(nil);
}

EX_EXPORT_METHOD_AS(processAudioChunk,
                    processAudioChunk:(NSString *)audioData
                    resolver:(EXPromiseResolveBlock)resolve
                    rejecter:(EXPromiseRejectBlock)reject) {
  NSData *data = [[NSData alloc] initWithBase64EncodedString:audioData options:0];
  [self.eviStream processAudioData:data];
  resolve(nil);
}

@end 