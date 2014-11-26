//
//  BubbleNode.m
//  bubble
//
//  Created by Zzy on 11/25/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "BubbleNode.h"

@interface BubbleNode ()

@property (strong, nonatomic) SKSpriteNode *bubbleNormalNode;
@property (strong, nonatomic) SKSpriteNode *bubbleFlatNode;
@property (nonatomic) BUBBLE_TYPE type;

@end

@implementation BubbleNode

- (instancetype)initWithType:(BUBBLE_TYPE)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.userInteractionEnabled = YES;
        self.status = BUBBLE_STATUS_NORMAL;
        NSString *bubbleType;
        switch (self.type) {
            case BUBBLE_TYPE_BOMB:
                bubbleType = @"BubbleBomb";
                break;
            case BUBBLE_TYPE_NORMAL:
                bubbleType = @"Bubble";
                break;
            default:
                
                break;
        }
        self.bubbleNormalNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Normal", bubbleType]];
        self.bubbleNormalNode.name = @"BubbleNormal";
        self.bubbleFlatNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Flat", bubbleType]];
        self.bubbleFlatNode.name = @"BubbleFlat";
        self.bubbleFlatNode.hidden = YES;
        [self addChild:self.bubbleFlatNode];
        [self addChild:self.bubbleNormalNode];
        self.size = self.bubbleNormalNode.size;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithType: instead." userInfo:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.status == BUBBLE_STATUS_FlAT) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        if (node == self.bubbleNormalNode) {
            self.status = BUBBLE_STATUS_FlAT;
        }
    }
}

- (void)setSize:(CGSize)size {
    self.bubbleNormalNode.size = size;
    self.bubbleFlatNode.size = size;
    super.size = size;
}

- (void)setStatus:(BUBBLE_STATUS)status {
    if (_status == status) {
        return;
    }
    _status = status;
    if (self.status == BUBBLE_STATUS_NORMAL) {
        self.bubbleNormalNode.hidden = NO;
        self.bubbleFlatNode.hidden = YES;
    } else if (self.status == BUBBLE_STATUS_FlAT) {
        self.bubbleNormalNode.hidden = YES;
        self.bubbleFlatNode.hidden = NO;
        [self runAction:[SKAction playSoundFileNamed:@"BubbleSound.mp3" waitForCompletion:NO]];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:self.speedTime], @"speedTime", [NSNumber numberWithInteger:self.type], @"type", [NSNumber numberWithInteger:self.status], @"status", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleClick" object:dict];
    }
}

@end
