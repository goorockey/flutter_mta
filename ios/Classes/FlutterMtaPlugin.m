#import "FlutterMtaPlugin.h"
#import "MTA.h"
#import "MTA+Account.h"
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
  } else if ([@"trackCustomKVEvent" isEqualToString:call.method]) {
    [self trackCustomKVEvent:call result: result];
  } else if ([@"trackBeginPage" isEqualToString:call.method]) {
    [self trackBeginPage:call result: result];
  } else if ([@"trackEndPage" isEqualToString:call.method]) {
    [self trackEndPage:call result: result];
  } else if ([@"reportCustomAccount" isEqualToString:call.method]) {
    [self reportCustomAccount:call result:result];
  } else if ([@"removeCustomAccount" isEqualToString:call.method]) {
    [self removeCustomAccount:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)reportCustomAccount:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *account = call.arguments[@"accountId"];
    MTAAccountInfo *info = [MTAAccountInfo new];
    info.type = MTAAccountCustom;
    info.account = account;
    info.accountStatus = MTAAccountStatusNormal;
    [MTA reportAccountExt:@[info]];
}

- (void)removeCustomAccount:(FlutterMethodCall*)call result:(FlutterResult)result {
    MTAAccountInfo *info = [MTAAccountInfo new];
    info.type = MTAAccountCustom;
    info.account = call.arguments[@"accountId"];
    info.accountStatus = MTAAccountStatusLogout;
    [MTA reportAccountExt:@[info]];
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *appKey = call.arguments[@"iosAppKey"];
  BOOL debug = call.arguments[@"debug"];

  [[MTAConfig getInstance] setAutoTrackPage:NO];

  [[MTAConfig getInstance] setDebugEnable:debug];
  [MTA startWithAppkey:appKey];
  result(@(YES));
}

- (void)trackCustomKVEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *eventId = call.arguments[@"eventId"];
  NSDictionary *properties = call.arguments[@"properties"];

  [MTA trackCustomKeyValueEvent:eventId props:properties];

  result(@(YES));
}

- (void)trackBeginPage:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *pageName = call.arguments[@"pageName"];

  [MTA trackPageViewBegin:pageName];

  result(@(YES));
}

- (void)trackEndPage:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *pageName = call.arguments[@"pageName"];

  [MTA trackPageViewEnd:pageName];

  result(@(YES));
}

@end
