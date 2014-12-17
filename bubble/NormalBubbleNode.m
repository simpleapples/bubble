//
//  NormalBubbleNode.m
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "NormalBubbleNode.h"

@interface NormalBubbleNode ()

@property (strong, nonatomic) SKAction *playSoundAction;

@end

@implementation NormalBubbleNode

- (instancetype)init
{
    self = [super initWithNormalFile:@"BubbleNormal" flatFile:@"BubbleFlat"];
    if (self) {
        self.type = BUBBLE_TYPE_NORMAL;
        self.playSoundAction = [SKAction playSoundFileNamed:@"BubbleSound.mp3" waitForCompletion:NO];
    }
    return self;
}

- (void)onBubbleClick
{
    [self runAction:self.playSoundAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleScore" object:nil];
}

@end
