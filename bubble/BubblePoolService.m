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

+ (BubblePoolService *)sharedSingleton
{
    static BubblePoolService *sharedSingleton;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        if (!sharedSingleton) {
            sharedSingleton = [[BubblePoolService alloc] init];
        }
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubblePool = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NormalBubbleNode *)normalBubble
{
    return (NormalBubbleNode *)[self bubbleWithType:BUBBLE_TYPE_NORMAL];
}

- (BombBubbleNode *)bombBubble
{
    return (BombBubbleNode *)[self bubbleWithType:BUBBLE_TYPE_BOMB];
}

- (BubbleNode *)bubbleWithType:(BUBBLE_TYPE)type
{
    __block BubbleNode *bubbleNode = nil;
    [self.bubblePool enumerateObjectsUsingBlock:^(BubbleNode *bubbleItem, NSUInteger idx, BOOL *stop) {
        if (bubbleItem.type == type && bubbleItem.poolStatus == BUBBLE_POOL_STATUS_AVAILABLE) {
            bubbleNode = bubbleItem;
            *stop = YES;
        }
    }];
    if (bubbleNode) {
        bubbleNode.poolStatus = BUBBLE_POOL_STATUS_UNAVAILABLE;
        bubbleNode.status = BUBBLE_STATUS_NORMAL;
        return bubbleNode;
    }
    if (type == BUBBLE_TYPE_BOMB) {
        BombBubbleNode *bombBubbleNode = [[BombBubbleNode alloc] init];
        bombBubbleNode.poolStatus = BUBBLE_POOL_STATUS_UNAVAILABLE;
        bombBubbleNode.poolIndex = self.bubblePool.count;
        [self.bubblePool addObject:bombBubbleNode];
        return bombBubbleNode;
    }
    NormalBubbleNode *normalBubbleNode = [[NormalBubbleNode alloc] init];
    normalBubbleNode.poolStatus = BUBBLE_POOL_STATUS_UNAVAILABLE;
    normalBubbleNode.poolIndex = self.bubblePool.count;
    [self.bubblePool addObject:normalBubbleNode];
    return normalBubbleNode;
}

- (void)releaseBubbleWithIndex:(NSInteger)index
{
    [self.bubblePool enumerateObjectsUsingBlock:^(BubbleNode *bubbleItem, NSUInteger idx, BOOL *stop) {
        if (bubbleItem.poolIndex == index) {
            bubbleItem.poolStatus = BUBBLE_POOL_STATUS_AVAILABLE;
            *stop = YES;
        }
    }];
}

- (void)resetPool
{
    [self.bubblePool enumerateObjectsUsingBlock:^(BubbleNode *bubbleItem, NSUInteger idx, BOOL *stop) {
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [bubbleItem removeFromParent];
            });
        } else {
            [bubbleItem removeFromParent];
        }
    }];
    [self.bubblePool removeAllObjects];
}

@end
