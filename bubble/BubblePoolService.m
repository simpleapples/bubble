//
//  BubblePoolService.m
//  bubble
//
//  Created by Zzy on 11/28/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BubblePoolService.h"
#import "NormalBubbleNode.h"
#import "BombBubbleNode.h"

@interface BubblePoolService ()

@property (strong, nonatomic) NSMutableArray *bubblePool;

@end

@implementation BubblePoolService

+ (BubblePoolService *)sharedSingleton {
    static BubblePoolService *sharedSingleton;
    @synchronized (self) {
        if (!sharedSingleton) {
            sharedSingleton = [[BubblePoolService alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (NormalBubbleNode *)normalBubble {
    return (NormalBubbleNode *)[self bubbleWithType:BUBBLE_TYPE_NORMAL];
}

- (BombBubbleNode *)bombBubble {
    return (BombBubbleNode *)[self bubbleWithType:BUBBLE_TYPE_BOMB];
}

- (BubbleNode *)bubbleWithType:(BUBBLE_TYPE)type {
    __block BubbleNode *bubbleNode = nil;
    [self.bubblePool enumerateObjectsUsingBlock:^(BubbleNode *bubbleItem, NSUInteger idx, BOOL *stop) {
        if (bubbleNode.type == type && bubbleNode.poolStatus == BUBBLE_POOL_STATUS_AVAILABLE) {
            bubbleNode = bubbleItem;
        }
    }];
    if (!bubbleNode) {
        if (type == BUBBLE_TYPE_BOMB) {
            BombBubbleNode *bombBubbleNode = [[BombBubbleNode alloc] initWithNormalFile:@"BubbleBombNormal" flatFile:@"BubbleBombFlat"];
            bombBubbleNode.poolStatus = BUBBLE_POOL_STATUS_UNAVAILABLE;
            bombBubbleNode.poolIndex = self.bubblePool.count;
            [self.bubblePool addObject:bombBubbleNode];
            return bombBubbleNode;
        } else {
            NormalBubbleNode *normalBubbleNode = [[NormalBubbleNode alloc] initWithNormalFile:@"BubbleNormal" flatFile:@"BubbleFlat"];
            normalBubbleNode.poolStatus = BUBBLE_POOL_STATUS_UNAVAILABLE;
            normalBubbleNode.poolIndex = self.bubblePool.count;
            [self.bubblePool addObject:normalBubbleNode];
            return normalBubbleNode;
        }
    } else {
        return bubbleNode;
    }
}

- (void)releaseBubbleWithIndex:(NSInteger)index {
    [self.bubblePool enumerateObjectsUsingBlock:^(BubbleNode *bubbleItem, NSUInteger idx, BOOL *stop) {
        if (bubbleItem.poolIndex == index) {
            bubbleItem.poolStatus = BUBBLE_POOL_STATUS_AVAILABLE;
        }
    }];
}

@end
