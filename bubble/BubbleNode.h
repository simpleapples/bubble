//
//  BubbleNode.h
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSInteger, BUBBLE_STATUS) {
    BUBBLE_STATUS_NORMAL = 0,
    BUBBLE_STATUS_FlAT,
};

@interface BubbleNode : SKSpriteNode

@property (nonatomic) BUBBLE_STATUS status;

- (instancetype)initWithNormalFile:(NSString *)normarlFile flatFile:(NSString *)flatFile;
- (instancetype)init;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)onBubbleClick;
- (void)setSize:(CGSize)size;
- (void)setStatus:(BUBBLE_STATUS)status;

@end
