//
//  VoiceMerge.h
//  voiceDemo2
//
//  Created by Allen on 2022/3/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface VoiceMerge : NSObject
@property(nonatomic,strong)AVAudioPlayer *  player;
+ (void)startMerge;
+ (void)startMergeWithArr:(NSArray *)arr;
+ (void)startMergeWithArr2:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
