//
//  BombBubbleNode.h
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BubbleNode.h"

@class BombBubbleNode;

@protocol BombBubbleNodeDelegate <NSObject>

- (void)bombBubbleNodeClick:(BombBubbleNode *)bombBubbleNode;

@end

@interface BombBubbleNode : BubbleNode

@property (nonatomic, assign) id<BombBubbleNodeDelegate> delegate;

@end
