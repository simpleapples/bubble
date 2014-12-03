//
//  GlobalHolder.m
//  bubble
//
//  Created by Zzy on 12/3/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GlobalHolder.h"

@implementation GlobalHolder

+ (GlobalHolder *)sharedSingleton {
    static GlobalHolder *sharedSingleton;
    @synchronized(self) {
        if (!sharedSingleton) {
            sharedSingleton = [[GlobalHolder alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)recoverFromLocal {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.bestScore = [userDefaults integerForKey:@"BestScore"];
}

- (void)backupToLocal {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.bestScore forKey:@"BestScore"];
    [userDefaults synchronize];
}

@end
