//
//  AppDelegate.m
//  voiceDemo2
//
//  Created by Allen on 2022/3/11.
//

#import "AppDelegate.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
#import "VoiceMerge.h"
#import "Soud.h"
#import "XDAudioManager.h"
#import "XSAudioManager.h"
#import <AVFoundation/AVFoundation.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define APPKEY @"22ce86dfa31ff8f286085298"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Required
     //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
     JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
       // 可以添加自定义 categories
       // NSSet<UNNotificationCategory *> *categories for iOS10 or later
       // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
     }
     [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY
                          channel:@"test"
                 apsForProduction:false
            advertisingIdentifier:nil];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}


-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
     
    NSLog(@"进入 didReceiveNotificationResponse %@",response.notification.request.content.userInfo);
}
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSDictionary * dict =  notification.request.content.userInfo ;
//    [self readNote:dict];
    NSLog(@"进入 willPresentNotification %@",notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge |UNNotificationPresentationOptionSound );//
}
- (void)readNote:(NSDictionary *)dict{
    if(dict[@"amount"] != nil){
//        XDAudioManager * manger = XDAudioManager.sharedInstance ;
//        NSArray * arrM = [manger getMusicFileArrayWithNum:dict[@"amount"]];
//        [manger mergeAVAssetWithSourceURLs:arrM completed:^(NSString * _Nonnull soundName, NSURL * _Nonnull soundsFileURL) {
//
//            NSURL* url = soundsFileURL;
//            AVAudioSession *_audioSession = [AVAudioSession sharedInstance];
//            [_audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
//            [_audioSession setActive:YES error:nil];
//
//            if(!staticAudioPlayer){
//                staticAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//                [staticAudioPlayer prepareToPlay];
//            }
//            staticAudioPlayer.volume = 10;
//            if (!staticAudioPlayer.isPlaying) {
//                [staticAudioPlayer play];
//            }
//        }];
        
        XSAudioManager * xsMangeg = XSAudioManager.sharedInstance;
        NSArray * arr = [xsMangeg getMusicArrayWithNum:dict[@"amount"]];
        [VoiceMerge startMergeWithArr:arr];
        [Sound.sharedInstance play];
    }
    
    
//    [VoiceMerge startMergeWithArr:@[@"4",@"百",@"元"] ];//@[@"user_payment",@"8",@"百",@"元"]
//
//    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
//
//    dispatch_after(timer, dispatch_get_main_queue(), ^{
//
//        [Sound.sharedInstance play];
//
//    });
}
@end
