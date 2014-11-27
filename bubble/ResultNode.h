//
//  ResultNode.h
//  bubble
//
//  Created by Zzy on 11/27/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSInteger, RESULT_TYPE) {
    RESULT_TYPE_NORMAL = 0,
    RESULT_TYPE_BOMB,
};

@interface ResultNode : SKSpriteNode

- (instancetype)initWithType:(RESULT_TYPE)type score:(NSInteger)score size:(CGSize)size;

@end
