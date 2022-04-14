//
//  VoiceManager.h
//  VoiceDemo
//
//  Created by Allen on 2022/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceManager : NSObject
+(VoiceManager *)shareInstance;
-(void)startWithText:(NSString *)language;
@end

NS_ASSUME_NONNULL_END
