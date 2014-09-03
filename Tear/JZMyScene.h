//
//  JZMyScene.h
//  Tear
//

//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class JZBalloonNode, JZScoreLabel, JZShareLabel, SKEmitterNode;

@interface JZMyScene : SKScene<UIGestureRecognizerDelegate>{
    BOOL swipeBlasting;
}

@property (nonatomic, strong) JZBalloonNode *selectedNode;
@property (nonatomic, strong) JZScoreLabel *scoreLabel;
@property (nonatomic, strong) JZShareLabel *shareLabel;
@property (nonatomic, strong) SKEmitterNode *fireNode;

@end
