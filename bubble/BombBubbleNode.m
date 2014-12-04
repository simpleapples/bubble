//
//  BombBubbleNode.m
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BombBubbleNode.h"

@interface BombBubbleNode ()

@property (strong, nonatomic) SKAction *sequenceAction;

@end

@implementation BombBubbleNode

- (instancetype)init {
    self = [super initWithNormalFile:@"BubbleBombNormal" flatFile:@"BubbleBombFlat"];
    if (self) {
        self.type = BUBBLE_TYPE_BOMB;
    }
    return self;
}

- (void)onBubbleClick {
    __weak id node = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleBomb" object:node];
}

@end
