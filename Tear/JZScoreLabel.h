//
//  JZScoreLabel.h
//  Tear
//
//  Created by 崔峥 on 14-9-2.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JZScoreLabel : SKSpriteNode

@property (nonatomic) u_int32_t score;
@property (nonatomic) u_int32_t oneValue;
@property (nonatomic) u_int32_t twoValue;
@property (nonatomic) u_int32_t threeValue;
@property (nonatomic, strong) SKLabelNode *threePositionLabel;
@property (nonatomic, strong) SKLabelNode *twoPositionLabel;
@property (nonatomic, strong) SKLabelNode *onePositionLabel;

+ (JZScoreLabel *)spriteNodeWithColor:(SKColor *)color size:(CGSize)size;
- (void)increase:(u_int32_t)i;
+ (id)sharedInstance;

@end
