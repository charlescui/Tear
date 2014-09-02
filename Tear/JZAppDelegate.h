//
//  JZAppDelegate.h
//  Tear
//
//  Created by 崔峥 on 14-8-31.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//业务参数
@property (strong, nonatomic) NSArray *balloons;
@property (nonatomic) u_int32_t knifeCategory;
@property (nonatomic) u_int32_t balloonCategory;
@property (nonatomic, strong) NSString *scoreNotify;
@property (nonatomic, strong) NSString *shareLabelName;

@end
