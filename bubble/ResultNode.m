//
//  ResultNode.m
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "ResultNode.h"
#import "MenuScene.h"
#import "GameScene.h"

@interface ResultNode ()

@property (strong, nonatomic) SKSpriteNode *backgroundNode;
@property (strong, nonatomic) SKSpriteNode *backButtonNode;
@property (strong, nonatomic) SKSpriteNode *refreshButtonNode;

@end

@implementation ResultNode

- (instancetype)initWithType:(RESULT_TYPE)type score:(NSInteger)score size:(CGSize)size {
    self = [super initWithColor:[SKColor clearColor] size:size];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"ResultBackground"];
        self.backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.backgroundNode.zPosition = 10;
        [self addChild:self.backgroundNode];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", score]];
        scoreLabel.fontColor = [SKColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        scoreLabel.fontSize = 52;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.backgroundNode.frame), CGRectGetMidX(self.backgroundNode.frame) - 60);
        scoreLabel.zPosition = 20;
        [self.backgroundNode addChild:scoreLabel];
        
        NSString *typeStr = nil;
        NSString *imageName = nil;
        if (type == RESULT_TYPE_NORMAL) {
            typeStr = @"对气泡们不要手下留情";
            imageName = @"BubbleNormal";
        } else if (type == RESULT_TYPE_BOMB) {
            typeStr = @"小心炸弹！";
            imageName = @"BubbleBombNormal";
        }
        
        SKLabelNode *typeLabel = [SKLabelNode labelNodeWithText:typeStr];
        typeLabel.fontColor = [SKColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        typeLabel.fontSize = 16;
        typeLabel.position = CGPointMake(CGRectGetMidX(self.backgroundNode.frame), CGRectGetMidX(self.backgroundNode.frame) + 10);
        typeLabel.zPosition = 30;
        [self.backgroundNode addChild:typeLabel];
        
        SKSpriteNode *iconNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        iconNode.position = CGPointMake(CGRectGetMidX(self.backgroundNode.frame), CGRectGetMidX(self.backgroundNode.frame) + 80);
        iconNode.zPosition = 40;
        [self.backgroundNode addChild:iconNode];
        
        self.backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"IconBack"];
        self.backButtonNode.position = CGPointMake(CGRectGetMidX(self.backgroundNode.frame) - 40, CGRectGetMidX(self.backgroundNode.frame) - 120);
        self.backButtonNode.zPosition = 50;
        [self.backgroundNode addChild:self.backButtonNode];
        
        self.refreshButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"IconRefresh"];
        self.refreshButtonNode.position = CGPointMake(CGRectGetMidX(self.backgroundNode.frame) + 40, CGRectGetMidX(self.backgroundNode.frame) - 120);
        self.refreshButtonNode.zPosition = 50;
        [self.backgroundNode addChild:self.refreshButtonNode];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithType:score:size: instead." userInfo:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.backgroundNode];
        SKNode *node = [self.backgroundNode nodeAtPoint:touchLocation];
        if (node == self.refreshButtonNode) {
            GameScene *gameScene = [[GameScene alloc] initWithSize:self.scene.view.bounds.size];
            gameScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.scene.view presentScene:gameScene];
        } else if (node == self.backButtonNode) {
            MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.scene.view.bounds.size];
            menuScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.scene.view presentScene:menuScene];
        }
    }

}

@end
