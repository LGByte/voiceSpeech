//
//  Soud.h
//  voiceDemo2
//
//  Created by Allen on 2022/3/11.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer* staticAudioPlayer;

@interface Sound : NSObject
{
    AVAudioSession* _audioSession;
}

+(instancetype)sharedInstance;

-(void)play;

-(void)stop;

@end
