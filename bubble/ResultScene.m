//
//  ResultScene.m
//  bubble
//
//  Created by Zzy on 12/4/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "ResultScene.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "GameCenterService.h"
#import "GlobalHolder.h"
#import "WXApi/WXApi.h"

@interface ResultScene ()

@property (strong, nonatomic) SKSpriteNode *menuBackground;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *bestScoreLabel;
@property (strong, nonatomic) SKSpriteNode *restartButton;
@property (strong, nonatomic) SKSpriteNode *homeButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *shareButton;
@property (strong, nonatomic) SKAction *playPopSoundAction;

@end

@implementation ResultScene

- (void)didMoveToView:(SKView *)view {
    self.playPopSoundAction = [SKAction playSoundFileNamed:@"PopSound.mp3" waitForCompletion:YES];

    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    [self addChild:backgroundNode];
    
    SKSpriteNode *gameOverTitle = [SKSpriteNode spriteNodeWithImageNamed:@"TitleGameOver"];
    gameOverTitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 160);
    gameOverTitle.zPosition = 15;
    gameOverTitle.size = CGSizeMake(233, 65);
    [self addChild:gameOverTitle];
    
    self.menuBackground = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBackground"];
    self.menuBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    self.menuBackground.zPosition = 20;
    self.menuBackground.size = CGSizeMake(254, 298);
    [self addChild:self.menuBackground];
    
    SKLabelNode *scoreTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    scoreTitleLabel.text = @"得分";
    scoreTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    scoreTitleLabel.fontSize = 22;
    scoreTitleLabel.position = CGPointMake(-80, 80);
    scoreTitleLabel.zPosition = 21;
    [self.menuBackground addChild:scoreTitleLabel];
    
    SKLabelNode *boardTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    boardTitleLabel.text = @"最高分";
    boardTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    boardTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    boardTitleLabel.fontSize = 22;
    boardTitleLabel.position = CGPointMake(-80, 40);
    boardTitleLabel.zPosition = 21;
    [self.menuBackground addChild:boardTitleLabel];
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    self.scoreLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:163 / 255.0f blue:79 / 255.0f alpha:1];
    self.scoreLabel.fontSize = 28;
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.scoreLabel.position = CGPointMake(80, 80);
    self.scoreLabel.zPosition = 22;
    [self.menuBackground addChild:self.scoreLabel];
    
    self.bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    if ([GlobalHolder sharedSingleton].bestScore > 0) {
        self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)[GlobalHolder sharedSingleton].bestScore];
    } else {
        self.bestScoreLabel.text = @"----";
    }
    self.bestScoreLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:163 / 255.0f blue:79 / 255.0f alpha:1];
    self.bestScoreLabel.fontSize = 28;
    self.bestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.bestScoreLabel.position = CGPointMake(80, 40);
    self.bestScoreLabel.zPosition = 22;
    [self.menuBackground addChild:self.bestScoreLabel];
    
    self.restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonRestart"];
    self.restartButton.position = CGPointMake(0, -10);
    self.restartButton.zPosition = 23;
    self.restartButton.size = CGSizeMake(160, 50);
    [self.menuBackground addChild:self.restartButton];
    
    self.homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonHome"];
    self.homeButton.position = CGPointMake(-60, -90);
    self.homeButton.zPosition = 24;
    self.homeButton.size = CGSizeMake(27, 28);
    [self.menuBackground addChild:self.homeButton];
    
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
        if (node == self.restartButton) {
            [self playPopSoundWithBlock:^{
                GameScene *gameScene = [[GameScene alloc] initWithSize:self.view.bounds.size];
                gameScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.scene.view presentScene:gameScene];
            }];
        } else if (node == self.homeButton) {
            [self playPopSoundWithBlock:^{
                MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.view.bounds.size];
                menuScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.scene.view presentScene:menuScene];
            }];
        } else if (node == self.leaderboardButton) {
            [self playPopSoundWithBlock:^{
                [[GameCenterService sharedSingleton] showLeaderboardWithTarget:self.view.window.rootViewController];
            }];
        } else if (node == self.shareButton) {
            [self playPopSoundWithBlock:^{
                [self shareAskWithWeChat:WXSceneTimeline];
            }];
        }
    }
}

- (void)playPopSoundWithBlock:(void (^)())block {
    [self runAction:self.playPopSoundAction completion:^{
        if (block) {
            block();
        }
    }];
}

#pragma mark ShareWeChat

- (void)shareAskWithWeChat:(int)scene
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=946285061";
    
    NSInteger bestScore = [GlobalHolder sharedSingleton].bestScore;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    if (bestScore > 100) {
        message.title = [NSString stringWithFormat:@"一口气挤了%ld个泡泡，我就是任性", (long)bestScore];
    } else {
        message.title = @"我爱挤泡泡，我就是任性";
    }
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"BubbleNormal"]];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

@end
