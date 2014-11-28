//
//  GameCenterService.h
//  bubble
//
//  Created by Zzy on 11/28/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AuthUserBlock)(BOOL success, UIViewController *authViewController);
typedef void (^ReportScoreBlock)(BOOL success);

@interface GameCenterService : NSObject

+ (GameCenterService *)sharedSingleton;

- (void)authUserWithBlock:(AuthUserBlock)block;
- (void)reportBestScore:(NSInteger)score block:(ReportScoreBlock)block;
- (void)showLeaderboardWithTarget:(UIViewController *)target;

@end
