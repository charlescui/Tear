//
//  JZBalloonNode.h
//  Tear
//
//  Created by 崔峥 on 14-9-1.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JZBalloonNode : SKSpriteNode{

}

@property (nonatomic, strong) AVAudioPlayer *blowAudio;
@property (nonatomic, strong) NSString *balloonColor;
@property (nonatomic) CGFloat speed;

+ (JZBalloonNode *)spriteNodeWithRandomColor;
- (void)riseFrom:(CGPoint)location;
- (void)riseFrom:(CGPoint)location byY:(CGFloat)to;
- (void)riseWithPanTo:(CGPoint)to withDuration:(float)duration;
- (void)blast;
- (void)startBlow;

@end
