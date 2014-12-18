//
//  NormalBubbleNode.h
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BubbleNode.h"

@class NormalBubbleNode;

@protocol NormalBubbleNodeDelegate <NSObject>

- (void)normalBubbleNodeClick:(NormalBubbleNode *)normalBubbleNode;

@end

@interface NormalBubbleNode : BubbleNode

@property (nonatomic, assign) id<NormalBubbleNodeDelegate> delegate;

@end
