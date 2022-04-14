//
//  NotificationService.m
//  bywdNotificationServiceExtension
//
//  Created by macjm on 2020/9/28.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NotificationService.h"
#import "XSAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceMerge.h"
#import "Soud.h"
#import "XDAudioManager.h"
#define kFileManager [NSFileManager defaultManager]

typedef void(^PlayVoiceBlock)(void);

@interface NotificationService ()<AVAudioPlayerDelegate,AVSpeechSynthesizerDelegate>
{
    AVSpeechSynthesizer *synthesizer;
}
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
// AVSpeechSynthesisVoice 播放完毕之后的回调block
@property (nonatomic, copy)PlayVoiceBlock finshBlock;


//声音文件的播放器
@property (nonatomic, strong)AVAudioPlayer *myPlayer;
//声音文件的路径
@property (nonatomic, strong) NSString *filePath;

@end

@implementation NotificationService
- (instancetype)init{
    if(self = [super init]){
        NSLog(@"homeDir: %@",NSHomeDirectory());
    }
    return  self;
}
/*
 *后台推送的json案例
 {"aps":{"alert":"钱到啦收款10000元","badge":1,"mutable-content":1,"amount":10000, "sound":"default"}}
 */

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    

    //step1: 推送json解析,获取推送金额
    NSMutableDictionary *dict = [self.bestAttemptContent.userInfo mutableCopy] ;
    
    NSLog(@"进入 service notification %@",dict);
    NSDictionary *extras =  [dict objectForKey:@"aps"] ;
   
    BOOL playaudio = YES;// [[extras objectForKey:@"amount"] boolValue] ;
    if(playaudio) {
        
        //step2:先处理金额，得到语音文件的数组,并播放语音(本地推送 -音频)
//        NSString *amount =  [dict objectForKey:@"amount"] ;//10000
//        NSArray *musicArr = [[XSAudioManager sharedInstance] getMusicArrayWithNum:amount];
//        __weak __typeof(self)weakSelf = self;
//        [[XSAudioManager sharedInstance] pushLocalNotificationToApp:0 withArray:musicArr completed:^{
//            // 播放完成后，通知系统
//            weakSelf.contentHandler(weakSelf.bestAttemptContent);
//        }];
        
        NSArray * instArr = [XDAudioManager.sharedInstance getMusicFileArrayWithNum:dict[@"amount"]];
        NSLog(@"数量 %@",instArr);
        [XDAudioManager.sharedInstance  mergeAVAssetWithSourceURLs:instArr completed:^(NSString * _Nonnull soundName, NSURL * _Nonnull soundsFileURL) {
            if(soundName.length == 0){
                self.contentHandler(self.bestAttemptContent);
                return;
            }
            self.bestAttemptContent.sound = [UNNotificationSound soundNamed:soundName];
            if (@available(iOS 15.0, *)) {
                self.bestAttemptContent.interruptionLevel = UNNotificationInterruptionLevelTimeSensitive;
                NSLog(@"11111111111111111111");
            } else {
                NSLog(@"222222222222222222222");
            }
            self.contentHandler(self.bestAttemptContent);
        }];
        
//        [self readNote];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.bestAttemptContent.sound = [UNNotificationSound soundNamed:@"tmp.mp3"];
//            self.contentHandler(self.bestAttemptContent);
//        });
       
    } else {
        //系统通知
        self.contentHandler(self.bestAttemptContent);
    }
}

// 30s的处理时间即将结束时，该方法会被调用，最后一次提醒用户去做处理
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}
- (void)readNote{
    [VoiceMerge startMergeWithArr2:@[@"8",@"syb_shoukuan_succ",@"百",@"元"] ];//@[@"user_payment",@"8",@"百",@"元"]  @[@"6",@"百",@"元"]
    
}

@end
