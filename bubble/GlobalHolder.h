//
//  GlobalHolder.h
//  bubble
//
//  Created by Zzy on 12/3/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHolder : NSObject

@property (nonatomic) NSInteger bestScore;

+ (GlobalHolder *)sharedSingleton;

- (void)recoverFromLocal;
- (void)backupToLocal;

@end
