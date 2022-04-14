//
//  ViewController.m
//  voiceDemo2
//
//  Created by Allen on 2022/3/11.
//

#import "ViewController.h"
#import "VoiceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceMerge.h"
#import "Soud.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)action:(id)sender {

    
//    [VoiceMerge startMerge];
    [VoiceMerge startMergeWithArr:@[@"8",@"百",@"元"] ];//@[@"user_payment",@"8",@"百",@"元"]
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);

    dispatch_after(timer, dispatch_get_main_queue(), ^{

        [Sound.sharedInstance play];
    
    });
   
    
}
- (IBAction)systemAuto:(id)sender {
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);

    dispatch_after(timer, dispatch_get_main_queue(), ^{

        [[VoiceManager shareInstance] startWithText:@"支付宝到账100000000元"];
    
    });
//        [[VoiceManager shareInstance] startWithText:@"林敏你支付宝到账134567899.45元"];
}
- (IBAction)setGroup:(id)sender {
//    [self testAction];
    [self copyFileFromResourceTOSandbox];
    
    
}
- (IBAction)getGroup:(id)sender {
    [self getByAppGroup2];
}

-(void)testAction{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory: %@",documentsDirectory);
    [self setAppGroup2];
    
}
#pragma mark - NSUserDefaults
- (void)setAppGroup1
{
 NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cashier.notification"];//此处id要与开发者中心创建时一致
 [myDefaults setObject:@"value" forKey:@"key"];
 NSLog(@"%@", [myDefaults valueForKey:@"key"]);
}
#pragma mark - NSFileManager
- (void)setAppGroup2{
 //获取分组的共享目录
 NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cashier.notification"];//此处id要与开发者中心创建时一致
 NSURL *fileURL = [groupURL URLByAppendingPathComponent:@"demo.txt"];
 //写入文件
 [@"abc" writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
 //读取文件
 NSString *str = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
 NSLog(@"str = %@", str);
    
 NSString * path =   [[NSBundle mainBundle] pathForResource:@"user_payment" ofType:@"mp3"];
 NSURL * urlPath = [[NSBundle mainBundle] URLForResource:@"user_payment" withExtension:@"mp3"];
    
[[NSFileManager defaultManager] moveItemAtURL:urlPath toURL:[groupURL URLByAppendingPathComponent:@"/Library/Sounds"] error:nil];
    // 获取Library的目录路径
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    // 获取tmp目录路径
    NSString *tmpDir =  NSTemporaryDirectory();
    NSURL * libURL = [NSURL URLWithString:libDir];
    BOOL isSus3 = [[NSFileManager defaultManager] copyItemAtURL:urlPath toURL:libURL error:nil];
    BOOL isSus2 = [[NSFileManager defaultManager] moveItemAtURL:urlPath toURL:libURL error:nil];//[libURL URLByAppendingPathComponent:@"/Sounds"]
//    NSLog(@"isSus: %ld - %ld",isSus2 ,isSus3);
    
}
- (void)copyFileFromResourceTOSandbox
{
   
    //文件类型
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"user_payment" ofType:@"mp3"];
    // 沙盒Library目录
//    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    //组中
    NSString * appDir = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cashier.notification"].path;
    NSLog(@"appDir  : %@",appDir);
    //appLib  Library/Caches目录
    //NSString *appLib = [appDir stringByAppendingString:@"/Caches"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * disPath = [NSString stringWithFormat:@"%@/Library/Sounds",appDir];
    if(![fileManager contentsOfDirectoryAtPath:disPath error:nil]){
        BOOL isCreate = [fileManager createDirectoryAtPath:disPath withIntermediateDirectories:true attributes:nil error:nil];
        NSLog(@"create Success %ld : %@",isCreate,appDir);
    }
    
   
   
    NSLog(@"11111 111");
   
    NSString *filePath = [[NSString stringWithFormat:@"%@/Library/Sounds",appDir] stringByAppendingPathComponent:@"user_payment.mp3"];
    if([fileManager fileExistsAtPath:filePath]){ //存在 删除
       BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
        NSLog(@"删除成功%ld",isDelete);
    }
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        BOOL filesPresent = [self copyMissingFile:docPath toPath:[NSString stringWithFormat:@"%@/Library/Sounds",appDir]];
        if (filesPresent) {
            NSLog(@"Copy  Success");
        }
        else
        {
            NSLog(@"Copy Fail");
        }
    }
    else
    {
        NSLog(@"文件已存在");
    }
}

/**
 *    @brief    把Resource文件夹下的area.db拷贝到沙盒
 *
 *    @param     sourcePath     Resource文件路径
 *    @param     toPath     把文件拷贝到XXX文件夹
 *
 *    @return    BOOL
 */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}
- (IBAction)delete:(id)sender {
    NSString * appDir = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cashier.notification"].path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * disPath = [NSString stringWithFormat:@"%@/Sounds",appDir];
    
    BOOL isCreate = [fileManager createDirectoryAtPath:disPath withIntermediateDirectories:true attributes:nil error:nil];
    NSLog(@"create Success %ld",isCreate);
    NSString *filePath = [[NSString stringWithFormat:@"%@/Sounds",appDir] stringByAppendingPathComponent:@"user_payment.mp3"];
    if([fileManager fileExistsAtPath:filePath]){ //存在 删除
       BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
        NSLog(@"删除成功%ld",isDelete);
    }
}

#pragma mark - NSUserDefaults
- (void)getByAppGroup1
{
 NSUserDefaults *myDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.cashier.notification"];//此处id要与开发者中心创建时一致
 NSString *content = [myDefaults objectForKey:@"key"];
 NSLog(@"%@",content);
}
#pragma mark - NSFileManager
- (void)getByAppGroup2{
 //获取分组的共享目录
 NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.cashier.notification"];//此处id要与开发者中心创建时一致
 NSURL *fileURL = [groupURL URLByAppendingPathComponent:@"demo.txt"];
 //读取文件
 NSString *str = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
 NSLog(@"str = %@", str);

 NSURL * mp3Url = [groupURL URLByAppendingPathComponent:@"Library/Sounds/user_payment.mp3"];
 [[NSFileManager defaultManager]  enumeratorAtPath:[groupURL.path stringByAppendingString:@"/Library/Sounds"]];
 NSArray * arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[groupURL.path stringByAppendingString:@"/Library/Sounds"] error:nil];
                     
                     
                
  NSLog(@"arr : %@",arr);
}
@end
