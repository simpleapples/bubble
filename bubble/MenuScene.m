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
#import "WXApi.h"

@interface MenuScene ()

@property (strong, nonatomic) SKSpriteNode *menuBackground;
@property (strong, nonatomic) SKSpriteNode *startButton;
@property (strong, nonatomic) SKSpriteNode *starButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *shareButton;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKAction *playPopSoundAction;

@end

@implementation MenuScene

- (void)didMoveToView:(SKView *)view
{
    self.playPopSoundAction = [SKAction playSoundFileNamed:@"PopSound.mp3" waitForCompletion:YES];
    [self addChildren];
}

- (void)addChildren
{
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    
    SKSpriteNode *titleLogo = [SKSpriteNode spriteNodeWithImageNamed:@"TitleLogo"];
    titleLogo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 160);
    titleLogo.zPosition = 15;
    titleLogo.size = CGSizeMake(237, 84);
    
    self.menuBackground = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBackground"];
    self.menuBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    self.menuBackground.zPosition = 20;
    self.menuBackground.size = CGSizeMake(254, 298);
    
    SKLabelNode *boardTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"STHeitiTC-Light"];
    boardTitleLabel.text = @"最高分";
    boardTitleLabel.fontColor = [SKColor colorWithRed:85 / 255.0f green:85 / 255.0f blue:85 / 255.0f alpha:1];
    boardTitleLabel.fontSize = 26;
    boardTitleLabel.position = CGPointMake(0, 80);
    boardTitleLabel.zPosition = 21;
    
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
    
    self.startButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonStart"];
    self.startButton.position = CGPointMake(0, -10);
    self.startButton.zPosition = 23;
    self.startButton.size = CGSizeMake(160, 50);
    
    self.starButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonStar"];
    self.starButton.position = CGPointMake(-60, -90);
    self.starButton.zPosition = 24;
    self.starButton.size = CGSizeMake(30, 30);
    
    self.leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonLeaderboard"];
    self.leaderboardButton.position = CGPointMake(0, -95);
    self.leaderboardButton.zPosition = 25;
    self.leaderboardButton.size = CGSizeMake(30, 30);
    
    self.shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonShare"];
    self.shareButton.position = CGPointMake(60, -90);
    self.shareButton.zPosition = 26;
    self.shareButton.size = CGSizeMake(20, 30);
    
    [self addChild:backgroundNode];
    [self addChild:titleLogo];
    [self addChild:self.menuBackground];
    [self.menuBackground addChild:boardTitleLabel];
    [self.menuBackground addChild:self.scoreLabel];
    [self.menuBackground addChild:self.startButton];
    [self.menuBackground addChild:self.starButton];
    [self.menuBackground addChild:self.leaderboardButton];
    [self.menuBackground addChild:self.shareButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.menuBackground];
        SKNode *node = [self.menuBackground nodeAtPoint:touchLocation];
        if (node == self.startButton) {
            [self playPopSoundWithBlock:^{
                CGSize size = [UIScreen mainScreen].bounds.size;
                GameScene *gameScene = [[GameScene alloc] initWithSize:size];
                gameScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.scene.view presentScene:gameScene];
            }];
        } else if (node == self.starButton) {
            [self playPopSoundWithBlock:^{
                NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=946285061";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
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

- (void)playPopSoundWithBlock:(void (^)())block
{
    [self runAction:self.playPopSoundAction completion:^{
        if (block) {
            block();
        }
    }];
}

#pragma mark ShareWeChat

- (void)shareAskWithWeChat:(int)scene
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://mp.weixin.qq.com/mp/redirect?url=https://itunes.apple.com/cn/app/id946285061?src=weixinshare";
        
        NSInteger bestScore = [GlobalHolder sharedSingleton].bestScore;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = ext;
        if (bestScore > 100) {
            message.title = [NSString stringWithFormat:@"一口气捏了%ld个泡泡，我就是任性", (long)bestScore];
        } else {
            message.title = @"我爱捏泡泡，我就是任性";
        }
        [message setThumbImage:[UIImage imageNamed:@"ShareIcon"]];
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法分享" message:@"没有安装微信，无法使用微信分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
