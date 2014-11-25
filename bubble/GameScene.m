//
//  GameScene.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameScene.h"
#import "BubbleNode.h"

#define ROAD_NUM 4
#define GAP 88

@interface GameScene ()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat roadWidth;
@property (nonatomic) NSInteger speedTime;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.speedTime = 6;
    NSTimeInterval duration = GAP / ((self.scene.frame.size.height + GAP) / self.speedTime);
    self.timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(createBubbleNode) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.roadWidth = self.scene.frame.size.width / ROAD_NUM;
    
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    [self addChild:backgroundNode];
}

-(void)update:(CFTimeInterval)currentTime {
}

- (void)createBubbleNode {
    for (NSInteger i = 0; i < ROAD_NUM; i++) {
        BUBBLE_TYPE type = BUBBLE_TYPE_NORMAL;
        if (arc4random() % 20 == 0) {
            type = BUBBLE_TYPE_BOMB;
        }
        BubbleNode *bubbleNode = [[BubbleNode alloc] initWithType:type];
        bubbleNode.name = @"BubbleNormal";
        
        CGFloat offsetX = i * self.roadWidth + self.roadWidth / 2;
        bubbleNode.position = CGPointMake(offsetX, self.scene.frame.size.height + bubbleNode.size.height / 2);
        
        SKAction *bubbleMoveAction = [SKAction moveToY:-bubbleNode.size.height / 2                  duration:self.speedTime];
        SKAction *bubbleRemoveAction = [SKAction runBlock:^{
            [bubbleNode removeFromParent];
        }];
        [bubbleNode runAction:[SKAction sequence:@[bubbleMoveAction, bubbleRemoveAction]]];
        
        [self addChild:bubbleNode];
    }
}

@end
