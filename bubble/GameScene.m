//
//  GameScene.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameScene.h"
#import "BubbleNode.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat roadWidth;
@property (nonatomic) NSInteger speedTime;

@property (strong, nonatomic) SKNode *ballBackgroundNode;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@end

@implementation GameScene

static const uint32_t needleCategory = 0x1 << 0;
static const uint32_t bubbleCategory = 0x1 << 1;

static const NSInteger ROAD_NUM = 4;
static const NSInteger BUBBLE_SIZE = 70;

-(void)didMoveToView:(SKView *)view {
    __weak id target = self;
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = target;
    self.speedTime = 6;
    self.roadWidth = self.scene.frame.size.width / ROAD_NUM;
    
    CGFloat gap = self.scene.frame.size.width / ROAD_NUM;
    NSTimeInterval duration = gap / ((self.scene.frame.size.height + gap) / self.speedTime);
    SKAction *createAction = [SKAction runBlock:^{
        [self createBubbleNode];
    }];
    SKAction *waitAction = [SKAction waitForDuration:duration];
    SKAction *sequence = [SKAction sequence:@[createAction, waitAction]];
    [self runAction:[SKAction repeatActionForever:sequence]];
    
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    [self addChild:backgroundNode];
    
    self.ballBackgroundNode = [SKNode node];
    self.ballBackgroundNode.zPosition = 20;
    [self addChild:self.ballBackgroundNode];
    
    for (NSInteger i = 0; i < ROAD_NUM; i++) {
        CGFloat offsetX = i * self.roadWidth + self.roadWidth / 2;
        SKSpriteNode *needleNode = [SKSpriteNode spriteNodeWithImageNamed:@"Needle"];
        needleNode.name = @"Needle";
        needleNode.position = CGPointMake(offsetX, 0);
        needleNode.zPosition = 30;
        needleNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:needleNode.size];
        needleNode.physicsBody.categoryBitMask = needleCategory;
        needleNode.physicsBody.contactTestBitMask = needleCategory | bubbleCategory;
        needleNode.physicsBody.collisionBitMask = needleCategory;
        [self addChild:needleNode];
    }
    
    self.scoreLabel = [SKLabelNode labelNodeWithText:@"0"];
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.scene.frame.size.height - self.scoreLabel.frame.size.height - 50);
    self.scoreLabel.color = [SKColor whiteColor];
    self.scoreLabel.zPosition = 100;
    [self addChild:self.scoreLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBubbleClick:) name:@"BubbleClick" object:nil];
}

- (void)createBubbleNode {
    for (NSInteger i = 0; i < ROAD_NUM; i++) {
        BUBBLE_TYPE type = BUBBLE_TYPE_NORMAL;
        if (arc4random() % 20 == 0) {
            type = BUBBLE_TYPE_BOMB;
        }
        BubbleNode *bubbleNode = [[BubbleNode alloc] initWithType:type];
        bubbleNode.name = @"Bubble";
        bubbleNode.size = CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE);
        bubbleNode.speedTime = self.speedTime;
        bubbleNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bubbleNode.size];
        bubbleNode.physicsBody.categoryBitMask = bubbleCategory;
        bubbleNode.physicsBody.contactTestBitMask = needleCategory | bubbleCategory;
        bubbleNode.physicsBody.collisionBitMask = bubbleCategory;
        
        CGFloat offsetX = i * self.roadWidth + self.roadWidth / 2;
        bubbleNode.position = CGPointMake(offsetX, self.scene.frame.size.height + bubbleNode.size.height / 2);
        
        SKAction *bubbleMoveAction = [SKAction moveToY:-bubbleNode.size.height / 2                  duration:self.speedTime];
        SKAction *bubbleRemoveAction = [SKAction runBlock:^{
            if (bubbleNode.status == BUBBLE_STATUS_NORMAL && bubbleNode.type == BUBBLE_TYPE_NORMAL) {
                [self presentResultScene];
            }
            [bubbleNode removeFromParent];
        }];
        [bubbleNode runAction:[SKAction sequence:@[bubbleMoveAction, bubbleRemoveAction]]];
        
        [self.ballBackgroundNode addChild:bubbleNode];
    }
}

- (void)onBubbleClick:(NSNotification *)notif {
    NSDictionary *dict = notif.object;
    NSInteger speedTime = [[dict objectForKey:@"speedTime"] integerValue];
//    BUBBLE_STATUS status = [[dict objectForKey:@"status"] integerValue];
    BUBBLE_TYPE type = [[dict objectForKey:@"type"] integerValue];
    if (type == BUBBLE_TYPE_NORMAL) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.scoreLabel.text.integerValue + (8 - speedTime)];
    } else if (type == BUBBLE_TYPE_BOMB) {
        self.paused = YES;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    BubbleNode *bubbleNode = nil;
    if ([contact.bodyA.node.name isEqualToString:@"Bubble"] && [contact.bodyB.node.name isEqualToString:@"Needle"]) {
        bubbleNode = (BubbleNode *)contact.bodyA.node;
    } else if ([contact.bodyA.node.name isEqualToString:@"Needle"] && [contact.bodyB.node.name isEqualToString:@"Bubble"]) {
        bubbleNode = (BubbleNode *)contact.bodyB.node;
    }
    if (bubbleNode && bubbleNode.status == BUBBLE_STATUS_NORMAL && bubbleNode.type == BUBBLE_TYPE_NORMAL) {
        bubbleNode.status = BUBBLE_STATUS_FlAT;
        self.paused = YES;
    }
}

@end
