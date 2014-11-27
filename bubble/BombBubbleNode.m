//
//  BombBubbleNode.m
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BombBubbleNode.h"

@implementation BombBubbleNode

- (instancetype)init {
    self = [super initWithNormalFile:@"BubbleBombNormal" flatFile:@"BubbleBombFlat"];
    return self;
}

- (void)onBubbleClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleBomb" object:nil];
}

@end
