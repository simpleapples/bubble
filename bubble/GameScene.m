//
//  GameScene.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameScene.h"
#import "NormalBubbleNode.h"
#import "BombBubbleNode.h"
#import "ResultNode.h"
#import "GameCenterService.h"
#import "BubblePoolService.h"
#import "GlobalHolder.h"

typedef NS_OPTIONS(NSInteger, NODE_CATEGORY) {
    NODE_CATEGORY_BUBBLE = 0,
    NODE_CATEGORY_NEEDLE,
};

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic) CGFloat roadWidth;
@property (nonatomic) CGFloat speed;
@property (nonatomic) NSInteger bubbleCount;
@property (nonatomic, getter = isResultNodeDisplayed) BOOL resultNodeDisplayed;

@property (strong, nonatomic) SKNode *ballBackgroundNode;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@end

@implementation GameScene

static const NSInteger ROAD_NUM = 4;
static const NSInteger BUBBLE_SIZE = 70;
static const NSInteger ORIGIN_TIME = 8;
static const NSInteger MAX_SPEED = 3;

-(void)didMoveToView:(SKView *)view {
    __weak id target = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = target;
    self.speed = 1;
    self.roadWidth = self.scene.frame.size.width / ROAD_NUM;
    
    [self createAction];
    
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
        needleNode.physicsBody.categoryBitMask = NODE_CATEGORY_NEEDLE;
        needleNode.physicsBody.contactTestBitMask = NODE_CATEGORY_NEEDLE | NODE_CATEGORY_BUBBLE;
        needleNode.physicsBody.collisionBitMask = NODE_CATEGORY_NEEDLE;
        [self addChild:needleNode];
    }
    
    self.scoreLabel = [SKLabelNode labelNodeWithText:@"0"];
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.scene.frame.size.height - self.scoreLabel.frame.size.height - 50);
    self.scoreLabel.color = [SKColor whiteColor];
    self.scoreLabel.zPosition = 100;
    [self addChild:self.scoreLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBubbleScore:) name:@"BubbleScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBubbleBomb:) name:@"BubbleBomb" object:nil];
}

- (void)createBubbleNode {
    for (NSInteger i = 0; i < ROAD_NUM; i++) {
        CGSize bubbleSize = CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE);
        CGFloat offsetX = i * self.roadWidth + self.roadWidth / 2;
        BubbleNode *bubbleNode = nil;
        if (arc4random() % 20 == 0) {
            bubbleNode = [[BubblePoolService sharedSingleton] bombBubble];
        } else {
            bubbleNode = [[BubblePoolService sharedSingleton] normalBubble];
        }
        bubbleNode.name = @"Bubble";
        bubbleNode.size = bubbleSize;
        bubbleNode.speed = self.speed;
        bubbleNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bubbleNode.size];
        bubbleNode.physicsBody.categoryBitMask = NODE_CATEGORY_BUBBLE;
        bubbleNode.physicsBody.contactTestBitMask = NODE_CATEGORY_NEEDLE | NODE_CATEGORY_BUBBLE;
        bubbleNode.physicsBody.collisionBitMask = NODE_CATEGORY_BUBBLE;
        bubbleNode.position = CGPointMake(offsetX, self.scene.frame.size.height + bubbleSize.height / 2);
        SKAction *bubbleMoveAction = [SKAction moveToY:-bubbleSize.height / 2 duration:ORIGIN_TIME];
        SKAction *bubbleRemoveAction = [SKAction runBlock:^{
            self.bubbleCount++;
            [self updateLevel];
            [bubbleNode removeFromParent];
            [[BubblePoolService sharedSingleton] releaseBubbleWithIndex:bubbleNode.poolIndex];
        }];
        [bubbleNode runAction:[SKAction sequence:@[bubbleMoveAction, bubbleRemoveAction]]];
        [self.ballBackgroundNode addChild:bubbleNode];
    }
}

- (void)showResultWithType:(RESULT_TYPE)type {
    self.scene.paused = YES;
    if (!self.isResultNodeDisplayed) {
        self.resultNodeDisplayed = YES;
        self.scoreLabel.hidden = YES;
        ResultNode *resultNode = [[ResultNode alloc] initWithType:type score:self.scoreLabel.text.integerValue size:self.scene.size];
        resultNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
        resultNode.zPosition = 500;
        [self addChild:resultNode];
        if (self.scoreLabel.text.integerValue > [GlobalHolder sharedSingleton].bestScore) {
            [GlobalHolder sharedSingleton].bestScore = self.scoreLabel.text.integerValue;
            [[GlobalHolder sharedSingleton] backupToLocal];
        }
        [[GameCenterService sharedSingleton] authUserWithBlock:^(BOOL success, UIViewController *authViewController) {
            if (success) {
                [[GameCenterService sharedSingleton] reportBestScore:self.scoreLabel.text.integerValue block:nil];
            }
        }];
    }
}

- (void)createAction {
    CGFloat gap = self.scene.frame.size.width / ROAD_NUM;
    NSTimeInterval duration = gap / ((self.scene.frame.size.height + gap) / (ORIGIN_TIME / self.speed));
    SKAction *createBubbleAction = [SKAction runBlock:^{
        [self createBubbleNode];
    }];
    SKAction *waitAction = [SKAction waitForDuration:duration];
    SKAction *repeatAction = [SKAction runBlock:^{
        [self createAction];
    }];
    SKAction *sequence = [SKAction sequence:@[createBubbleAction, waitAction, repeatAction]];
    [self runAction:sequence];
}

- (void)updateLevel {
    CGFloat speed = 0.1 * self.bubbleCount / (ROAD_NUM * 20) + 1;
    if (speed < MAX_SPEED && speed - self.speed >= 0.1) {
        self.speed = speed;
        [self.ballBackgroundNode enumerateChildNodesWithName:@"Bubble" usingBlock:^(SKNode *node, BOOL *stop) {
            node.speed = self.speed;
        }];
    }
}

#pragma mark - Handler

- (void)onBubbleScore:(NSNotification *)notif {
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.scoreLabel.text.integerValue + self.speed * 10)];
}

- (void)onBubbleBomb:(NSNotification *)notif {
    [self showResultWithType:RESULT_TYPE_BOMB];
}

#pragma mark - ContractTest

- (void)didBeginContact:(SKPhysicsContact *)contact {
    BubbleNode *bubbleNode = nil;
    if ([contact.bodyA.node.name isEqualToString:@"Bubble"] && [contact.bodyB.node.name isEqualToString:@"Needle"]) {
        bubbleNode = (BubbleNode *)contact.bodyA.node;
    } else if ([contact.bodyA.node.name isEqualToString:@"Needle"] && [contact.bodyB.node.name isEqualToString:@"Bubble"]) {
        bubbleNode = (BubbleNode *)contact.bodyB.node;
    }
    if (bubbleNode && bubbleNode.status == BUBBLE_STATUS_NORMAL && [bubbleNode isMemberOfClass:[NormalBubbleNode class]]) {
//        bubbleNode.status = BUBBLE_STATUS_FlAT;
        [self showResultWithType:RESULT_TYPE_NORMAL];
    }
}

@end
