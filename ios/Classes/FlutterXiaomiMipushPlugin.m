#import "FlutterXiaomiMipushPlugin.h"  

@implementation FlutterXiaomiMipushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.xiaomi.mipush/flutter" binaryMessenger:[registrar messenger]];
  FlutterXiaomiMipushPlugin* instance = [[FlutterXiaomiMipushPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"registerPush" isEqualToString:call.method]) {
      
      //[MiPushSDK registerMiPush:self type:0 connect:YES];
      
    result(@YES);
  } else if ([@"setUserAccount" isEqualToString:call.method]) {
      result(@YES);
  } else if ([@"unsetUserAccount" isEqualToString:call.method]) {
      
       result(@YES);
  }else  if ([@"getAllUserAccount" isEqualToString:call.method]) {
      NSArray *array = [[NSMutableArray alloc] init];
      result(array);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
