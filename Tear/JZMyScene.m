//
//  JZMyScene.m
//  Tear
//
//  Created by 崔峥 on 14-8-31.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZMyScene.h"
#import "JZBalloonNode.h"
#import "JZScoreLabel.h"
#import "JZShareLabel.h"
#import "JZAppDelegate.h"

@implementation JZMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, ONGO!";
        myLabel.fontSize = 25;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.name = @"JZMyScene";
        
        //透明的label底色
        self.scoreLabel = [JZScoreLabel spriteNodeWithColor:[UIColor colorWithRed:0.078 green:0.493 blue:0.877 alpha:0.000] size:CGSizeMake(90, 30)];
        self.scoreLabel.position = CGPointMake(30, 20);
        [self addChild:self.scoreLabel];
        
        self.shareLabel = [JZShareLabel labelNodeWithFontNamed:@"Chalkduster"];
        self.shareLabel.position = CGPointMake(230, 20);
        [self addChild:self.shareLabel];
        
        //设置火球
        self.fireNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"JZFireParticle" ofType:@"sks"]];
        self.fireNode.alpha = 0;
        [self addChild:self.fireNode];
    }

    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [self registerGesture];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
//    NSLog(@"%@", NSStringFromCGRect(self.shareLabel.frame));
}

#pragma mark -
#pragma mark 注册手势

- (void)registerGesture
{
    //拖拽气球
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:pan];
    
    //单击生成气球
    //多指，最多四个一起触摸
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [[self view] addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 2;
    [[self view] addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 3;
    [[self view] addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 4;
    [[self view] addGestureRecognizer:tap];
    
    //双击爆炸
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapToDismiss:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [[self view] addGestureRecognizer:doubleTap];
    
    //长按吹气球
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressToBlow:)];
    [[self view] addGestureRecognizer:longPress];
    
    //滑动击爆气球
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipToBlast:)];
    [[self view] addGestureRecognizer:swip];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    NSUInteger count = recognizer.numberOfTouches;
    
    if (count == 1) {
        //先判断是否是点击到了分享按钮
        CGPoint touchLocation = [recognizer locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        if (CGRectContainsPoint(self.shareLabel.frame, touchLocation)) {
            [self.shareLabel handleTapGestureToShare:nil];
        }else{
            goto GenerateBalloon;
        }
    }else{
        GenerateBalloon:
        for (int i=0; i < count; i++) {
            //判断每个手指触点的位置
            CGPoint touchLocation = [recognizer locationOfTouch:i inView:self.view];
            touchLocation = [self convertPointFromView:touchLocation];
            JZBalloonNode *sprite = [JZBalloonNode spriteNodeWithRandomColor];
            [self addChild:sprite];
            [sprite riseFrom:touchLocation];
//            [sprite riseFrom:touchLocation byY:(self.frame.size.height - touchLocation.y)];
        }
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        
//        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
//        touchLocation = [self convertPointFromView:touchLocation];
//        _selectedNode = (JZBalloonNode *)[self selectNodeForTouch:touchLocation];
//        if (_selectedNode) {
//            [_selectedNode removeAllActions];
//        }
//        
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        
//        CGPoint translation = [recognizer translationInView:recognizer.view];
//        translation = CGPointMake(translation.x, -translation.y);
//        [self panForTranslation:translation];
//        [recognizer setTranslation:CGPointZero inView:recognizer.view];
//        
//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//        if ([[_selectedNode name] isEqualToString:@"balloon"]) {
//            float scrollDuration = 0.02;
//            CGPoint velocity = [recognizer velocityInView:recognizer.view];
//            CGPoint pos = [_selectedNode position];
//            CGPoint p = mult(velocity, scrollDuration);
//            
//            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
//            newPos = [self boundLayerPos:newPos];
//            //拖拽移动
//            [_selectedNode riseWithPanTo:newPos withDuration:scrollDuration];
//        }
//        
//    }
    //拖拽和滑动手势很难区分
    //当拖拽手势存在的时候，滑动的回掉无法响应
    //需要在拖拽响应的时候，主动调用滑动
    [self handleSwipToBlast:(UISwipeGestureRecognizer *)recognizer];
}

- (void)handleDoubleTapToDismiss:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    _selectedNode = (JZBalloonNode *)[self selectNodeForTouch:touchLocation];
    if (_selectedNode.class == [JZBalloonNode class]) {
        //有可能选择的Node不是气球，比如self也是一个Node
        [_selectedNode removeAllActions];
        [_selectedNode blast];
    }
}

- (void)handleLongPressToBlow:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        SKSpriteNode *node = [self selectNodeForTouch:touchLocation];
        if ([node.name isEqualToString:@"JZMyScene"]) {
            //生成气球，并设置为当前选择对象
            CGPoint touchLocation = [recognizer locationInView:recognizer.view];
            touchLocation = [self convertPointFromView:touchLocation];
            JZBalloonNode *sprite = [JZBalloonNode spriteNodeWithRandomColor];
            sprite.position = touchLocation;
            [self addChild:sprite];
            _selectedNode = sprite;
            [_selectedNode startBlow];
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([_selectedNode.name isEqualToString:@"balloon"]) {
            [_selectedNode removeAllActions];
            [_selectedNode riseFrom:touchLocation];
        }
        _selectedNode = nil;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        //Nothing
    }
}

/**
 *  滑动击破气球
 *
 *  @param recognizer 手势
 */
- (void)handleSwipToBlast:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
//        if ([node.name isEqualToString:@"JZMyScene"]) {
            swipeBlasting = YES;
            //显示火球
            self.fireNode.alpha = 0;
            self.fireNode.particlePosition = touchLocation;
            SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];
            [self.fireNode runAction:fadeIn];
//        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        swipeBlasting = NO;
        //隐藏火球
        self.fireNode.alpha = 1;
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        [self.fireNode runAction:fadeAway];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        SKSpriteNode *node = [self selectNodeForTouch:touchLocation withName:@"balloon"];
        //火球要跟随手指运动
        self.fireNode.particlePosition = touchLocation;
        //手指经过的气球要爆炸
        if (node && swipeBlasting && [node.name isEqualToString:@"balloon"]) {
            [(JZBalloonNode *)node blast];
        }
    }
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, 0);
    retval.x = MIN(retval.x, winSize.width);
    retval.y = MAX(retval.y, 0);
    retval.y = MIN(retval.y, winSize.height);
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:@"balloon"]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    } else {
        CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
        [self setPosition:[self boundLayerPos:newPos]];
    }
}

- (SKSpriteNode *)selectNodeForTouch:(CGPoint)touchLocation withName:(NSString *)name
{
    NSArray *nodes = [self selectNodesForTouch:touchLocation];
    for (SKSpriteNode *node in nodes) {
        if ([node.name isEqualToString:name]) {
            return node;
        }
    }
    return nil;
}

- (NSArray *)selectNodesForTouch:(CGPoint)touchLocation
{
    return [self nodesAtPoint:touchLocation];
}

- (SKSpriteNode *)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    JZBalloonNode *touchedNode = (JZBalloonNode *)[self nodeAtPoint:touchLocation];
    
//    //2
//    if(![_selectedNode isEqual:touchedNode]) {
//        [_selectedNode removeAllActions];
//        [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
//        
//        _selectedNode = touchedNode;
//        //3
//        if([[touchedNode name] isEqualToString:@"balloon"]) {
//            SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
//                                                      [SKAction rotateByAngle:0.0 duration:0.1],
//                                                      [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
//            [_selectedNode runAction:[SKAction repeatActionForever:sequence]];
//        }
//    }
//    return _selectedNode;
    return touchedNode;
}

#pragma mark -
#pragma mark 辅助函数

float degToRad(float degree) {
    return degree / 180.0f * M_PI;
}

CGPoint mult(const CGPoint v, const CGFloat s) {
    return CGPointMake(v.x*s, v.y*s);
}

@end
