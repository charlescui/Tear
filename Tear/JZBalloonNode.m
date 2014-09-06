//
//  JZBalloonNode.m
//  Tear
//
//  Created by 崔峥 on 14-9-1.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZBalloonNode.h"
#import "JZAppDelegate.h"

@implementation JZBalloonNode

+ (JZBalloonNode *)spriteNodeWithRandomColor
{
    JZAppDelegate *delegate = (JZAppDelegate *)[UIApplication sharedApplication].delegate;
    //随机取一个颜色的气球
    int value = (arc4random() % delegate.balloons.count);
    NSString *imgName = [delegate.balloons objectAtIndex:value];
    JZBalloonNode *sprite = [JZBalloonNode spriteNodeWithImageNamed:imgName];
    
    return sprite;
}

+ (JZBalloonNode *)spriteNodeWithImageNamed:(NSString *)name
{
    JZBalloonNode *sprite = [super spriteNodeWithImageNamed:name];
    if (sprite) {
        sprite.name = @"balloon";
        sprite.balloonColor = name;
        //随机设置气球的缩放尺寸
        float scale = ((arc4random() % 30) + 60)/100.0;
        sprite.size = CGSizeMake(70*scale, 75*scale);
        sprite.physicsBody.density = 0.2;
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.width/1.7];
        sprite.physicsBody.affectedByGravity = NO;
        //随机设置每个气球的速度
        sprite.speed = arc4random() % 5 + 10;
        //气球的弹性
        sprite.physicsBody.restitution = 1;
        sprite.physicsBody.categoryBitMask = ((JZAppDelegate *)[UIApplication sharedApplication].delegate).balloonCategory;
    }
    
    return sprite;
}

- (void)riseFrom:(CGPoint)location
{
    if (self.blowAudio) {
        [self.blowAudio stop];
    }
    [self removeAllActions];
    self.position = location;
    SKAction *moveAction = [SKAction moveByX:0 y:self.speed duration:1];
    SKAction *repeatingAction = [SKAction repeatActionForever:moveAction];
    [self runAction:repeatingAction];
}

- (void)riseFrom:(CGPoint)location byY:(CGFloat)to
{
    if (self.blowAudio) {
        [self.blowAudio stop];
    }
    self.position = location;
    CGFloat distance = to - location.y;
    NSTimeInterval duration = distance/self.speed;

    SKAction *moveAction = [SKAction moveToY:to duration:duration];
//    [SKAction moveByX:0 y:self.speed duration:1];
//    SKAction *repeatingAction = [SKAction repeatActionForever:moveAction];
    [self runAction:moveAction completion:^(){
        NSLog(@"MOVEMOVEMOVE %@", self);
    }];
}

/**
 *  拖拽
 *
 *  @param to       到某个位置
 *  @param duration 持续时间
 */
- (void)riseWithPanTo:(CGPoint)to withDuration:(float)duration
{
    if (self.blowAudio) {
        [self.blowAudio stop];
    }
    SKAction *moveTo = [SKAction moveTo:to duration:duration];
    [moveTo setTimingMode:SKActionTimingEaseOut];

    SKAction *moveAction = [SKAction moveByX:0 y:self.speed duration:1];
    SKAction *repeatingAction = [SKAction repeatActionForever:moveAction];
    
    SKAction *group = [SKAction group:@[moveTo, repeatingAction]];
    
    [self runAction:group];
}

/**
 *  气球爆炸
 */
- (void)blast
{
    if (self.blowAudio) {
        [self.blowAudio stop];
    }
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
//    SKAction *wait = [SKAction waitForDuration: 0.5];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[zoom, fadeAway]];
    [self runAction: group completion:^(){
        NSString *notify = ((JZAppDelegate *)[UIApplication sharedApplication].delegate).scoreNotify;
        [[NSNotificationCenter defaultCenter] postNotificationName:notify object:@(1)];
        [self runAction:removeNode completion:^(){
        }];
    }];
}

/**
 *  吹气球
 */
- (void)startBlow
{
    SKAction *zoom = [SKAction scaleBy:1.1 duration:1];
    //增加吹气球音效
    //当吹爆或者松手的时候
    //停止音效
    if (!self.blowAudio) {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/blow_leak.wav", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        self.blowAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.blowAudio.numberOfLoops = -1;
        self.blowAudio.volume = 1.0;
        if (self.blowAudio){
            [self.blowAudio play];
        }
    }

    [self runAction:zoom completion:^{
        if (self.size.width > 160) {
            [self blast];
        }else{
            [self startBlow];
        }
    }];
}

/**
 *  计算两点之间的距离
 *
 *  @param first  第一个点
 *  @param second 第二个点
 *
 *  @return 距离
 */
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

@end
