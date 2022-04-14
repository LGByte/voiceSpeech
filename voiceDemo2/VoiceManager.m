//
//  VoiceManager.m
//  VoiceDemo
//
//  Created by Allen on 2022/3/11.
//

#import "VoiceManager.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceManager ()<AVSpeechSynthesizerDelegate>

@property(nonatomic,strong)AVSpeechSynthesizer *speech;
@property(nonatomic,strong)AVSpeechUtterance *utterance;
@property(nonatomic,strong)AVSpeechSynthesisVoice *voice;
@property(nonatomic,copy)NSString *languageType; // 播报语音类型

@end

@implementation VoiceManager

+(VoiceManager *)shareInstance
{
    static VoiceManager *voiceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        voiceManager = [[super allocWithZone:NULL] init];
    });
    return voiceManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [VoiceManager shareInstance];
}

-(instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [VoiceManager shareInstance];
}

-(instancetype)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [VoiceManager shareInstance];
}

-(instancetype)init
{
    if ([super init]) {
        NSArray *languages = @[@"en-US",@"zh-CN",@"en-GB",@"zh-HK"];
        _languageType = languages[1];
        _speech = [[AVSpeechSynthesizer alloc] init];
        _speech.delegate = self;
        _utterance = [[AVSpeechUtterance alloc] init];
         _voice = [AVSpeechSynthesisVoice voiceWithLanguage:_languageType];
    }
    return self;
}

// 开始播放
-(void)startWithText:(NSString *)language
{
    
    if ([_speech isPaused]) {
        [_speech continueSpeaking];
    } else {
        if([_speech isSpeaking]){
            NSLog(@"正在读取");
            NSArray *languages = @[@"en-US",@"zh-CN",@"en-GB",@"zh-HK"];
            NSString * _languageType = languages[1];
            AVSpeechSynthesizer * _speech = [[AVSpeechSynthesizer alloc] init];
//            _speech.delegate = self;
            AVSpeechUtterance * _utterance = [[AVSpeechUtterance alloc] init];
            AVSpeechSynthesisVoice * _voice = [AVSpeechSynthesisVoice voiceWithLanguage:_languageType];
            _utterance = [_utterance initWithString:language];
            _utterance.rate = 0.5; // 设置语速 0最慢 1最快
            _utterance.voice = _voice;
            [_speech speakUtterance:_utterance];
            
        }else{
            _utterance = [_utterance initWithString:language];
            _utterance.rate = 0.5; // 设置语速 0最慢 1最快
            _utterance.voice = _voice;
//            _utterance.pitchMultiplier = 1.2;
            [_speech speakUtterance:_utterance];
        }
        
    }
}

#pragma mark - AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"---开始播放");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"--完成播放");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"--暂停播放");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"--恢复播放");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"取消播放");
}

@end
