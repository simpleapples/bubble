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
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"Bubble Wrap"];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:titleLabel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *gameScene = [[GameScene alloc] initWithSize:self.view.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.scene.view presentScene:gameScene];
}

@end
