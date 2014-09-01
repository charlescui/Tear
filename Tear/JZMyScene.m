//
//  JZMyScene.m
//  Tear
//
//  Created by 崔峥 on 14-8-31.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZMyScene.h"
#import "JZBalloonNode.h"

@implementation JZMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, ONGO Baby!";
        myLabel.fontSize = 25;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    }

    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [self registerGesture];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        JZBalloonNode *sprite = [JZBalloonNode spriteNodeWithRandomColor];
//        [sprite riseFrom:location];
//        [self addChild:sprite];
//    }
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark -
#pragma mark 注册手势

- (void)registerGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:tap];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    JZBalloonNode *sprite = [JZBalloonNode spriteNodeWithRandomColor];
    [self addChild:sprite];
    [sprite riseFrom:touchLocation];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        _selectedNode = (JZBalloonNode *)[self selectNodeForTouch:touchLocation];
        if (_selectedNode) {
            [_selectedNode removeAllActions];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([[_selectedNode name] isEqualToString:@"balloon"]) {
            float scrollDuration = 0.02;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = [_selectedNode position];
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            newPos = [self boundLayerPos:newPos];
            //拖拽移动
            [_selectedNode riseWithPanTo:newPos withDuration:scrollDuration];
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

- (SKSpriteNode *)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    JZBalloonNode *touchedNode = (JZBalloonNode *)[self nodeAtPoint:touchLocation];
    
    //2
    if(![_selectedNode isEqual:touchedNode]) {
        [_selectedNode removeAllActions];
        [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        
        _selectedNode = touchedNode;
        //3
        if([[touchedNode name] isEqualToString:@"balloon"]) {
            SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
                                                      [SKAction rotateByAngle:0.0 duration:0.1],
                                                      [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
            [_selectedNode runAction:[SKAction repeatActionForever:sequence]];
        }
    }
    return _selectedNode;
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
