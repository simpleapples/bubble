//
//  AppDelegate.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "AppDelegate.h"
#import "GameCenterService.h"
#import "GlobalHolder.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GlobalHolder sharedSingleton] recoverFromLocal];
    [[GameCenterService sharedSingleton] authUserWithBlock:^(BOOL success, UIViewController *authViewController) {
        if (!success) {
        } else if (authViewController) {
            [self.window.rootViewController presentViewController:authViewController animated:YES completion:nil];
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
