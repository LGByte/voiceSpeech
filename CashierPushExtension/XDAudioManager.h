//
//  XDAudioManager.h
//  voiceDemo2
//
//  Created by kang1 on 2022/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDAudioManager : NSObject
+ (instancetype)sharedInstance;
-(NSArray *)getMusicFileArrayWithNum:(NSString *)numStr;
- (void)mergeAVAssetWithSourceURLs:(NSArray *)sourceURLsArr completed:(void (^)(NSString * soundName,NSURL * soundsFileURL)) completed;
@end

NS_ASSUME_NONNULL_END
