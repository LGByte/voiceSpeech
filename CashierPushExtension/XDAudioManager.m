//
//  XDAudioManager.m
//  voiceDemo2
//
//  Created by kang1 on 2022/4/12.
//

#import "XDAudioManager.h"
#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>
@implementation XDAudioManager
+ (instancetype)sharedInstance{
    static XDAudioManager *_instance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[XDAudioManager alloc] init] ;
    }) ;
    return _instance ;
}
/// 获取的金额中每个音频文件的地址数组，numStr是实际的金额，比如15.4。
-(NSArray *)getMusicFileArrayWithNum:(NSString *)numStr
{
    NSString *finalStr = [self caculateNumber:numStr];
    //前部分字段例如:***到账  user_payment是项目自定义的音乐文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"syb_shoukuan" ofType:@"mp3"];
    NSMutableArray *finalArr = [[NSMutableArray alloc] initWithObjects:path, nil];
    for (int i=0; i<finalStr.length; i++) {
        NSString *str = [finalStr substringWithRange:NSMakeRange(i, 1)];
//        NSString *file = [NSString stringWithFormat:@"%@.m4a", str];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"mp3"];
        [finalArr addObject: path];
    }
    return finalArr;
}

-(NSString *)caculateNumber:(NSString *)numstr {
    NSArray *numberchar = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSArray *inunitchar = @[@"",@"十",@"百",@"千"];
    NSArray *unitname   = @[@"",@"万",@"亿"];
    
    NSString *valstr =[NSString stringWithFormat:@"%.2f",numstr.doubleValue] ;
        
    NSString *prefix = @"" ;
    
    // 将金额分为整数部分和小数部分
    NSString *head = [valstr substringToIndex:valstr.length - 2 - 1] ;
    NSString *foot = [valstr substringFromIndex:valstr.length - 2] ;
        
//    if (head.length>8) {
//        return nil ;//只支持到千万，抱歉哈
//    }
    
    // 处理整数部分
    if([head isEqualToString:@"0"]) {
        prefix = @"0" ;
    }
    else {
        NSMutableArray *ch = [[NSMutableArray alloc]init] ;
        for (int i = 0; i < head.length; i++) {
            NSString * str = [NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'] ;
            [ch addObject:str] ;
        }
        
        int zeronum = 0 ;
        for (int i = 0; i < ch.count; i++) {
            NSInteger index = (ch.count-1 - i)%4 ;       //取段内位置
            NSInteger indexloc = (ch.count-1 - i)/4 ;    //取段位置
            
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum ++ ;
            }
            else {
                if (zeronum != 0) {
                    if (index != 3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum = 0;
                }
                if (ch.count >i) {
                    NSInteger numIndex = [[ch objectAtIndex:i]intValue];
                    if (numberchar.count >numIndex) {
                        prefix = [prefix stringByAppendingString:[numberchar objectAtIndex:numIndex]] ;
                    }
                }
                
                if (inunitchar.count >index) {
                    prefix = [prefix stringByAppendingString:[inunitchar objectAtIndex:index]] ;
                }

            }
            if (index == 0 && zeronum < 4) {
                if (unitname.count >indexloc) {
                    prefix = [prefix stringByAppendingString:[unitname objectAtIndex:indexloc]] ;

                }
            }
        }
    }
    
    //1十开头的改为十
      if([prefix hasPrefix:@"1十"]) {
          prefix = [prefix stringByReplacingOccurrencesOfString:@"1十" withString:@"十"] ;
      }
    
    //处理小数部分
    if([foot isEqualToString:@"00"]) {
        prefix = [prefix stringByAppendingString:@"元"] ;
    }
    else {
        prefix = [prefix stringByAppendingString:[NSString stringWithFormat:@"点%@元", foot]] ;
    }
    return prefix ;
}

///在AppGroup中合并音频
- (void)mergeAVAssetWithSourceURLs:(NSArray *)sourceURLsArr completed:(void (^)(NSString * soundName,NSURL * soundsFileURL)) completed{
    //创建音频轨道,并获取多个音频素材的轨道
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音频插入的开始时间,用于记录每次添加音频文件的开始时间
    __block CMTime beginTime = kCMTimeZero;
    [sourceURLsArr enumerateObjectsUsingBlock:^(id  _Nonnull audioFileURL, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取音频素材
        AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioFileURL]];
        //音频轨道
        AVMutableCompositionTrack *audioTrack1 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
        //获取音频素材轨道
        AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
        //音频合并- 插入音轨文件
        [audioTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:beginTime error:nil];
        // 记录尾部时间
        beginTime = CMTimeAdd(beginTime, audioAsset1.duration);
    }];
    
    //用动态日期会占用空间
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
//    NSString * timeFromDateStr = [formater stringFromDate:[NSDate date]];
//    NSString *outPutFilePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/sound-%@.mp4", timeFromDateStr];
    
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: @"group.com.cashier.notification"];
//    NSURL * soundsURL = [groupURL URLByAppendingPathComponent:@"/Library/Sounds/" isDirectory:YES];
    //建立文件夹
    NSURL * soundsURL = [groupURL URLByAppendingPathComponent:@"Library/" isDirectory:YES];
    if (![[NSFileManager defaultManager] contentsOfDirectoryAtPath:soundsURL.path error:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundsURL.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //建立文件夹
    NSURL * soundsURL2 = [groupURL URLByAppendingPathComponent:@"Library/Sounds/" isDirectory:YES];
    if (![[NSFileManager defaultManager] contentsOfDirectoryAtPath:soundsURL2.path error:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundsURL2.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 新建文件名，如果存在就删除旧的
    NSString * soundName = [NSString stringWithFormat:@"sound.m4a"];
    NSString *outPutFilePath = [NSString stringWithFormat:@"Library/Sounds/%@", soundName];
    NSURL * soundsFileURL = [groupURL URLByAppendingPathComponent:outPutFilePath isDirectory:NO];
//    NSString * filePath = soundsURL.absoluteString;
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundsFileURL.path]) {
        [[NSFileManager defaultManager] removeItemAtPath:soundsFileURL.path error:nil];
    }
    //导出合并后的音频文件
    //音频文件目前只找到支持m4a 类型的
    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    // 音频文件输出
    session.outputURL = soundsFileURL;
    session.outputFileType = AVFileTypeAppleM4A; //与上述的`present`相对应
    session.shouldOptimizeForNetworkUse = YES;   //优化网络
    [session exportAsynchronouslyWithCompletionHandler:^{
        if (session.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"合并成功----%@", outPutFilePath);
            if (completed) {
                completed(soundName,soundsFileURL);
            }
        } else {
            // 其他情况, 具体请看这里`AVAssetExportSessionStatus`.
            NSLog(@"合并失败----%ld", (long)session.status);
            if (completed) {
                completed(@"", nil);
            }
        }
    }];
}
@end
