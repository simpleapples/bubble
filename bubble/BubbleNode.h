//
//  BubbleNode.h
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSInteger, BUBBLE_TYPE) {
    BUBBLE_TYPE_NORMAL = 0,
    BUBBLE_TYPE_BOMB,
};

typedef NS_OPTIONS(NSInteger, BUBBLE_STATUS) {
    BUBBLE_STATUS_NORMAL = 0,
    BUBBLE_STATUS_FlAT,
};

typedef NS_OPTIONS(NSInteger, BUBBLE_POOL_STATUS) {
    BUBBLE_POOL_STATUS_AVAILABLE = 0,
    BUBBLE_POOL_STATUS_UNAVAILABLE,
};

@interface BubbleNode : SKSpriteNode

@property (nonatomic) BUBBLE_TYPE type;
@property (nonatomic) BUBBLE_STATUS status;
@property (nonatomic) BUBBLE_POOL_STATUS poolStatus;
@property (nonatomic) NSInteger poolIndex;

- (instancetype)initWithNormalFile:(NSString *)normarlFile flatFile:(NSString *)flatFile;
- (instancetype)init;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)setSize:(CGSize)size;
- (void)setStatus:(BUBBLE_STATUS)status;

@end