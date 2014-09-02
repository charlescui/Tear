//
//  JZScoreLabel.m
//  Tear
//
//  Created by 崔峥 on 14-9-2.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZScoreLabel.h"
#import "JZAppDelegate.h"

@implementation JZScoreLabel

+ (JZScoreLabel *)spriteNodeWithColor:(SKColor *)color size:(CGSize)size
{
    JZScoreLabel *label = [self sharedInstance];
    label = [label initWithColor:color size:size];
    
    if (label) {
        label.score = 0;
        label.oneValue = 0;
        label.twoValue = 0;
        label.threeValue = 0;
        label.name = @"ScoreBoard";
        
        [label initLabelAt:1 with:0];
        [label initLabelAt:2 with:0];
        [label initLabelAt:3 with:0];
        
        NSString *notify = ((JZAppDelegate *)[UIApplication sharedApplication].delegate).scoreNotify;
        [[NSNotificationCenter defaultCenter] addObserver:label selector:@selector(handleNotify:) name:notify object:0];
    }
    
    return label;
}

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static JZScoreLabel *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[JZScoreLabel alloc] init];
    });
    return instance;
}

- (void)increase:(u_int32_t)i
{
    self.score += i;
    if (i > 999) {
        //爆表！
    }else{
        int oneCarry = self.score/100%10;
        int twoCarry = self.score/10%10;
        int threeCarry = self.score/1%10;
        
        if (self.oneValue != oneCarry) {
            self.oneValue = oneCarry;
            [self animateCarryAt:1 to:oneCarry];
        }
        if (self.twoValue != twoCarry) {
            self.twoValue = twoCarry;
            [self animateCarryAt:2 to:twoCarry];
        }
        if (self.threeValue != threeCarry) {
            self.threeValue = threeCarry;
            [self animateCarryAt:3 to:threeCarry];
        }
    }
}

- (void)initLabelAt:(NSInteger)idx with:(int)value
{
    SKLabelNode *label;
    
    label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = [NSString stringWithFormat:@"%d", value];
    label.fontSize = 25;
    label.position = CGPointMake(30*(idx - 1) - 10, -10);
    label.alpha = 0;
    
    switch (idx) {
        case 1:
            if (self.onePositionLabel) {
                [self.onePositionLabel removeFromParent];
            }
            label.name = @"OneScoreBoardLabel";
            self.onePositionLabel = label;
            break;
        case 2:
            if (self.twoPositionLabel) {
                [self.twoPositionLabel removeFromParent];
            }
            label.name = @"TwoScoreBoardLabel";
            self.twoPositionLabel = label;
            break;
        case 3:
            if (self.threePositionLabel) {
                [self.threePositionLabel removeFromParent];
            }
            label.name = @"ThreePositionLabel";
            self.threePositionLabel = label;
            break;
        default:
            break;
    }
    
    [self addChild:label];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];
    SKAction *sequence = [SKAction sequence:@[fadeIn]];
    [label runAction:sequence completion:^(){
        [self enumerateChildNodesWithName:label.name usingBlock:^(SKNode *node, BOOL *stop){
            if (node != label) {
                [node removeFromParent];
            }
        }];
    }];
}

- (void)animateCarryAt:(NSInteger)idx to:(int)value
{
    SKLabelNode *label;
    switch (idx) {
        case 1:
            label = self.onePositionLabel;
            break;
        case 2:
            label = self.twoPositionLabel;
            break;
        case 3:
            label = self.threePositionLabel;
            break;
        default:
            break;
    }
    if (label) {
        SKAction *move = [SKAction moveToY:50 duration:0.25];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.2];
        SKAction *group = [SKAction group:@[move, fadeAway]];
        [label runAction:group completion:^(){
            [label removeFromParent];
            [self initLabelAt:idx with:value];
        }];
    }else{
        [self initLabelAt:idx with:value];
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

- (void)handleNotify:(NSNotification *)notification
{
    int value = 0;
    [((NSValue *)notification.object) getValue:&value];
    [self increase:value];
}

@end
