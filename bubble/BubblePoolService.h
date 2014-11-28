//
//  BubblePoolService.h
//  bubble
//
//  Created by Zzy on 11/28/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NormalBubbleNode;
@class BombBubbleNode;

@interface BubblePoolService : NSObject

+ (BubblePoolService *)sharedSingleton;
- (NormalBubbleNode *)normalBubble;
- (BombBubbleNode *)bombBubble;
- (void)releaseBubbleWithIndex:(NSInteger)index;

@end
