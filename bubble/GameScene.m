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
#import "GameCenterService.h"
#import "BubblePoolService.h"
#import "GlobalHolder.h"
#import "ResultScene.h"

typedef NS_OPTIONS(NSInteger, NODE_CATEGORY) {
    NODE_CATEGORY_BUBBLE = 0,
    NODE_CATEGORY_BORDER,
};

@interface GameScene () <SKPhysicsContactDelegate, BombBubbleNodeDelegate, NormalBubbleNodeDelegate>

@property (nonatomic) CGFloat roadWidth;
@property (nonatomic) CGFloat nodeSpeed;
@property (nonatomic) NSInteger bubbleCount;
@property (nonatomic, getter = isResultNodeDisplayed) BOOL resultNodeDisplayed;
@property (nonatomic, getter = isStopped) BOOL stopped;
@property (nonatomic, getter = isGamePaused) BOOL gamePaused;

@property (strong, nonatomic) SKNode *ballBackgroundNode;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKSpriteNode *coverNode;
@property (strong, nonatomic) SKAction *playBombSoundAction;

@end

@implementation GameScene

static const NSInteger ROAD_NUM = 4;
static const NSInteger BUBBLE_SIZE = 70;
static const NSInteger ORIGIN_TIME = 6;
static const NSInteger MAX_SPEED = 3;

- (void)didMoveToView:(SKView *)view
{
    __weak __typeof(self) wself = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = wself;
    self.nodeSpeed = 1;
    self.roadWidth = self.scene.frame.size.width / ROAD_NUM;
    self.playBombSoundAction = [SKAction playSoundFileNamed:@"BombSound.mp3" waitForCompletion:YES];

    [self createAction];
    
    [self addChildren];
}

- (void)addChildren
{
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    
    self.ballBackgroundNode = [SKNode node];
    self.ballBackgroundNode.zPosition = 20;
    
    SKSpriteNode *borderNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.scene.size.width, 1)];
    borderNode.name = @"Border";
    borderNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), 0);
    borderNode.zPosition = 30;
    borderNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:borderNode.size];
    borderNode.physicsBody.categoryBitMask = NODE_CATEGORY_BORDER;
    borderNode.physicsBody.contactTestBitMask = NODE_CATEGORY_BORDER | NODE_CATEGORY_BUBBLE;
    borderNode.physicsBody.collisionBitMask = NODE_CATEGORY_BORDER;
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    self.scoreLabel.text = @"0";
    self.scoreLabel.fontColor = [SKColor whiteColor];
    self.scoreLabel.fontSize = 32;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.scene.frame.size.height - self.scoreLabel.frame.size.height - 50);
    self.scoreLabel.zPosition = 100;
    
    [self addChild:backgroundNode];
    [self addChild:self.ballBackgroundNode];
    [self addChild:borderNode];
    [self addChild:self.scoreLabel];
}

- (void)createBubbleNode
{
    for (NSInteger i = 0; i < ROAD_NUM; i++) {
        CGSize bubbleSize = CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE);
        CGFloat offsetX = i * self.roadWidth + self.roadWidth / 2;
        BubbleNode *bubbleNode = nil;
        if (arc4random() % 10 == 0) {
            BombBubbleNode *bombBubbleNode = [[BubblePoolService sharedSingleton] bombBubble];
            bombBubbleNode.delegate = self;
            bubbleNode = (BubbleNode *)bombBubbleNode;
        } else {
            NormalBubbleNode *normalBubbleNode = [[BubblePoolService sharedSingleton] normalBubble];
            normalBubbleNode.delegate = self;
            bubbleNode = (BubbleNode *)normalBubbleNode;
        }
        bubbleNode.name = @"Bubble";
        bubbleNode.size = bubbleSize;
        bubbleNode.speed = self.nodeSpeed;
        bubbleNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bubbleNode.size];
        bubbleNode.physicsBody.categoryBitMask = NODE_CATEGORY_BUBBLE;
        bubbleNode.physicsBody.contactTestBitMask = NODE_CATEGORY_BORDER | NODE_CATEGORY_BUBBLE;
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

- (void)createAction
{
    CGFloat gap = self.scene.frame.size.width / ROAD_NUM;
    NSTimeInterval duration = gap / ((self.scene.frame.size.height + gap) / (ORIGIN_TIME / self.nodeSpeed));
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

- (void)updateLevel
{
    CGFloat speed = 0.1 * self.bubbleCount / (ROAD_NUM * 20) + 1;
    if (speed < MAX_SPEED && speed - self.nodeSpeed >= 0.1) {
        self.nodeSpeed = speed;
        [self.ballBackgroundNode enumerateChildNodesWithName:@"Bubble" usingBlock:^(SKNode *node, BOOL *stop) {
            node.speed = self.nodeSpeed;
        }];
    }
}

- (void)gameOver
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger score = self.scoreLabel.text.integerValue;
        if (score > [GlobalHolder sharedSingleton].bestScore) {
            [GlobalHolder sharedSingleton].bestScore = score;
            [[GlobalHolder sharedSingleton] backupToLocal];
        }
        [[GameCenterService sharedSingleton] reportBestScore:score block:nil];
        [[BubblePoolService sharedSingleton] resetPool];
        [self resetScene];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        ResultScene *resultScene = [[ResultScene alloc] initWithSize:size];
        resultScene.score = score;
        resultScene.scaleMode = SKSceneScaleModeAspectFill;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scene.view presentScene:resultScene];
        });
    });
}

- (void)stopGame
{
    if (!self.coverNode) {
        self.coverNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:self.scene.size];
        self.coverNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.coverNode.zPosition = 200;
        [self addChild:self.coverNode];
    }
    if (!self.isStopped) {
        self.stopped = YES;
        [self removeAllActions];
        [self.ballBackgroundNode.children enumerateObjectsUsingBlock:^(SKNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeAllActions];
        }];
    }
}

- (void)bubbleWink:(BubbleNode *)bubbleNode completion:(void (^)())block
{
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.2];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.2];
    SKAction *waitAction = [SKAction waitForDuration:0.2];
    SKAction *sequenceAction = [SKAction sequence:@[fadeOutAction, waitAction, fadeInAction, waitAction]];
    SKAction *repeatAction = [SKAction sequence:@[sequenceAction, sequenceAction, sequenceAction]];
    [bubbleNode runAction:repeatAction completion:^{
        if (block) {
            block();
        }
    }];
}

- (void)resetScene
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - BombBubbleNodeDelegate

- (void)bombBubbleNodeClick:(BombBubbleNode *)bombBubbleNode
{
    [self stopGame];
    [self runAction:self.playBombSoundAction];
    [self bubbleWink:bombBubbleNode completion:^{
        [self gameOver];
    }];
}

#pragma mark - NormalBubbleNodeDelegate

- (void)normalBubbleNodeClick:(NormalBubbleNode *)normalBubbleNode
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.scoreLabel.text.integerValue + self.speed * 10)];
}

#pragma mark - ContractTest

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    BubbleNode *bubbleNode = nil;
    if ([contact.bodyA.node.name isEqualToString:@"Bubble"] && [contact.bodyB.node.name isEqualToString:@"Border"]) {
        bubbleNode = (BubbleNode *)contact.bodyA.node;
    } else if ([contact.bodyA.node.name isEqualToString:@"Border"] && [contact.bodyB.node.name isEqualToString:@"Bubble"]) {
        bubbleNode = (BubbleNode *)contact.bodyB.node;
    }
    if (bubbleNode && bubbleNode.status == BUBBLE_STATUS_NORMAL && [bubbleNode isMemberOfClass:[NormalBubbleNode class]]) {
        [self stopGame];
        [self bubbleWink:bubbleNode completion:^{
            [self gameOver];
        }];
    }
}

@end
