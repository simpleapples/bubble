//
//  GameViewController.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.view.bounds.size];
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:menuScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
