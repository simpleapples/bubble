//
//  MenuScene.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "GameCenterService.h"
#import "GlobalHolder.h"

@interface MenuScene ()

@property (strong, nonatomic) SKSpriteNode *menuBackground;
@property (strong, nonatomic) SKSpriteNode *startButton;
@property (strong, nonatomic) SKSpriteNode *starButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *shareButton;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@end

@implementation MenuScene

- (void)didMoveToView:(SKView *)view {
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    [self addChild:backgroundNode];
    
    SKSpriteNode *titleLogo = [SKSpriteNode spriteNodeWithImageNamed:@"TitleLogo"];
    titleLogo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 160);
    titleLogo.zPosition = 15;
    titleLogo.size = CGSizeMake(237, 84);
    [self addChild:titleLogo];
    
    self.menuBackground = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBackground"];
    self.menuBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    self.menuBackground.zPosition = 20;
    self.menuBackground.size = CGSizeMake(254, 298);
    [self addChild:self.menuBackground];
    
    SKLabelNode *boardTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    boardTitleLabel.text = @"最高分";
    boardTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    boardTitleLabel.fontSize = 26;
    boardTitleLabel.position = CGPointMake(0, 80);
    boardTitleLabel.zPosition = 21;
    [self.menuBackground addChild:boardTitleLabel];
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    if ([GlobalHolder sharedSingleton].bestScore > 0) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)[GlobalHolder sharedSingleton].bestScore];
    } else {
        self.scoreLabel.text = @"----";
    }
    self.scoreLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:163 / 255.0f blue:79 / 255.0f alpha:1];
    self.scoreLabel.fontSize = 32;
    self.scoreLabel.position = CGPointMake(0, 45);
    self.scoreLabel.zPosition = 22;
    [self.menuBackground addChild:self.scoreLabel];
    
    self.startButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonStart"];
    self.startButton.position = CGPointMake(0, -10);
    self.startButton.zPosition = 23;
    self.startButton.size = CGSizeMake(160, 50);
    [self.menuBackground addChild:self.startButton];
    
    self.starButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonStar"];
    self.starButton.position = CGPointMake(-60, -90);
    self.starButton.zPosition = 24;
    self.starButton.size = CGSizeMake(30, 30);
    [self.menuBackground addChild:self.starButton];
    
    self.leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonLeaderboard"];
    self.leaderboardButton.position = CGPointMake(0, -95);
    self.leaderboardButton.zPosition = 25;
    self.leaderboardButton.size = CGSizeMake(30, 30);
    [self.menuBackground addChild:self.leaderboardButton];
    
    self.shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonShare"];
    self.shareButton.position = CGPointMake(60, -90);
    self.shareButton.zPosition = 26;
    self.shareButton.size = CGSizeMake(20, 30);
    [self.menuBackground addChild:self.shareButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.menuBackground];
        SKNode *node = [self.menuBackground nodeAtPoint:touchLocation];
        if (node == self.startButton) {
            GameScene *gameScene = [[GameScene alloc] initWithSize:self.view.bounds.size];
            gameScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.scene.view presentScene:gameScene];
        } else if (node == self.starButton) {
            
        } else if (node == self.leaderboardButton) {
            [[GameCenterService sharedSingleton] showLeaderboardWithTarget:self.view.window.rootViewController];
        } else if (node == self.shareButton) {
            
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
