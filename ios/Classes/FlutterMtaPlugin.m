#import "FlutterMtaPlugin.h"
#import "MTA.h"
#import "MTAConfig.h"

@implementation FlutterMtaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_mta"
            binaryMessenger:[registrar messenger]];
  FlutterMtaPlugin* instance = [[FlutterMtaPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    [self init:call result: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *appKey = call.arguments[@"iosAppKey"];
  BOOL debug = call.arguments[@"debug"];


  [[MTAConfig getInstance] setDebugEnable:debug];
  [MTA startWithAppkey:appKey];
  result(@(YES));
}

@end
