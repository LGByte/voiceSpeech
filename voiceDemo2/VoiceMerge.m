//
//  VoiceMerge.m
//  voiceDemo2
//
//  Created by Allen on 2022/3/11.
//

#import "VoiceMerge.h"

@interface VoiceMerge()

@end
@implementation VoiceMerge

+ (void)startMergeWithArr:(NSArray *)arr{
   
    
    //合并音频
    NSMutableData *sounds = [NSMutableData alloc];
    for (NSString * path in arr) {
        NSString *mp3Path1 = [[NSBundle mainBundle] pathForResource:path ofType:@"mp3"];
        NSData *sound1Data = [[NSData alloc] initWithContentsOfFile: mp3Path1];
        [sounds appendData:sound1Data];
    }
    //保存音频
     NSLog(@"data length:%lu", (unsigned long)[sounds length]);
    
    [sounds writeToFile:[self filePathWithName:@"tmp.mp3"] atomically:YES];
    
 
}
+ (void)startMergeWithArr2:(NSArray *)arr{
   
    
    //合并音频
    NSMutableData *sounds = [NSMutableData alloc];
    for (NSString * path in arr) {
        NSString *mp3Path1 = [[NSBundle mainBundle] pathForResource:path ofType:@"mp3"];
        NSData *sound1Data = [[NSData alloc] initWithContentsOfFile: mp3Path1];
        [sounds appendData:sound1Data];
    }
    //保存音频
     NSLog(@"data length:%lu", (unsigned long)[sounds length]);
    
//    [sounds writeToFile:[self filePathWithName:@"tmp.mp3"] atomically:YES];
    BOOL isWriteSus = [sounds writeToFile:[self filePathWithName2:@"tmp.mp3"] atomically:YES];
    
    NSLog(@"%@",(isWriteSus ? @"Mp3写入成功": @"Mp3写入失败"));
 
}
+ (void)startMerge
{
   
   
   //音频文件路径
   NSString *mp3Path1 = [[NSBundle mainBundle] pathForResource:@"pay_failure" ofType:@"mp3"];
   NSString *mp3Path2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp3"];
   NSString *mp3Path3 = [[NSBundle mainBundle] pathForResource:@"hlm_shoukuan_succ" ofType:@"mp3"];
   //音频数据
   NSData *sound1Data = [[NSData alloc] initWithContentsOfFile: mp3Path1];
   NSData *sound2Data = [[NSData alloc] initWithContentsOfFile: mp3Path2];
   NSData *sound3Data = [[NSData alloc] initWithContentsOfFile: mp3Path3];
   
   //合并音频
   NSMutableData *sounds = [NSMutableData alloc];
   [sounds appendData:sound1Data];
   [sounds appendData:sound2Data];
   [sounds appendData:sound3Data];
   //保存音频
   
    NSLog(@"data length:%lu", (unsigned long)[sounds length]);
   
   [sounds writeToFile:[self filePathWithName:@"tmp.mp3"] atomically:YES];
}

+ (NSString *)filePathWithName:(NSString *)filename
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[documentsDirectory stringByAppendingPathComponent:filename];
    NSLog(@"path: %@",path);
    return path;
}
+ (NSString *)filePathWithName2:(NSString *)filename
{
    
    
//    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString * appDir = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cashier.notification"].path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * disPath = [NSString stringWithFormat:@"%@/Library/Sounds",appDir];
    
    BOOL isCreate = [fileManager createDirectoryAtPath:disPath withIntermediateDirectories:true attributes:nil error:nil];
    NSLog(@"create Success %ld",isCreate);
    
    NSString * path =[disPath stringByAppendingPathComponent:filename];
    NSLog(@"path: %@",path);
    return path;
}
@end
