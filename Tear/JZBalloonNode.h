//
//  JZBalloonNode.h
//  Tear
//
//  Created by 崔峥 on 14-9-1.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JZBalloonNode : SKSpriteNode{

}

@property (nonatomic, strong) NSString *balloonColor;
@property (nonatomic) float speed;

+ (JZBalloonNode *)spriteNodeWithRandomColor;
- (void)riseFrom:(CGPoint)location;
- (void)riseWithPanTo:(CGPoint)to withDuration:(float)duration;
- (void)blast;
- (void)startBlow;

@end
