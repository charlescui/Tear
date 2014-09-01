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
        float scale = ((arc4random() % 60) + 40)/100.0;
        sprite.size = CGSizeMake(70*scale, 75*scale);
        sprite.physicsBody.density = 0.2;
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.width/2];
        sprite.physicsBody.affectedByGravity = NO;
        //随机设置每个气球的速度
        sprite.speed = ((arc4random() % 20) + 20);
        //气球的弹性
        sprite.physicsBody.restitution = 1;
    }
    
    return sprite;
}

- (void)riseFrom:(CGPoint)location
{
    self.position = location;
    SKAction *moveAction = [SKAction moveByX:0 y:self.speed duration:1];
    SKAction *repeatingAction = [SKAction repeatActionForever:moveAction];
    [self runAction:repeatingAction];
}

- (void)riseWithPanTo:(CGPoint)to withDuration:(float)duration
{
    SKAction *moveTo = [SKAction moveTo:to duration:duration];
    [moveTo setTimingMode:SKActionTimingEaseOut];

    SKAction *moveAction = [SKAction moveByX:0 y:self.speed duration:1];
    SKAction *repeatingAction = [SKAction repeatActionForever:moveAction];
    
    SKAction *group = [SKAction group:@[moveTo, repeatingAction]];
    
    [self runAction:group];
}

@end