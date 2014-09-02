//
//  JZShareLabel.h
//  Tear
//
//  Created by 崔峥 on 14-9-2.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JZShareLabel : SKLabelNode

+ (JZShareLabel *)labelNodeWithFontNamed:(NSString *)fontName;
- (void)handleTapGestureToShare:(UITapGestureRecognizer *)recognizer;

@end
