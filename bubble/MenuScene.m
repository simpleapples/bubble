//
//  MenuScene.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@implementation MenuScene

- (void)didMoveToView:(SKView *)view {
    SKNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    backgroundNode.zPosition = 10;
    [self addChild:backgroundNode];
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"Bubble Wrap"];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleLabel.zPosition = 20;
    [self addChild:titleLabel];
    
    SKLabelNode *tapLabel = [SKLabelNode labelNodeWithText:@"Tap to start"];
    tapLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 40);
    tapLabel.fontSize = 18;
    tapLabel.zPosition = 21;
    [self addChild:tapLabel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *gameScene = [[GameScene alloc] initWithSize:self.view.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.scene.view presentScene:gameScene];
}

@end
