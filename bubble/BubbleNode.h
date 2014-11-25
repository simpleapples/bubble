//
//  BubbleNode.h
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSInteger, BUBBLE_STATUS) {
    BUBBLE_STATUS_NORMAL = 0,
    BUBBLE_STATUS_FlAT,
};

typedef NS_OPTIONS(NSInteger, BUBBLE_TYPE) {
    BUBBLE_TYPE_NORMAL = 0,
    BUBBLE_TYPE_BOMB,
};

@interface BubbleNode : SKSpriteNode

@property (nonatomic, readonly) BUBBLE_STATUS status;
@property (nonatomic, readonly) BUBBLE_TYPE type;

- (instancetype)initWithType:(BUBBLE_TYPE)type;

@end
