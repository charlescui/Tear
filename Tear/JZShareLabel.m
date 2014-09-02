//
//  JZShareLabel.m
//  Tear
//
//  Created by 崔峥 on 14-9-2.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZShareLabel.h"
#import "ShareSDK/ShareSDK.h"
#import "JZScoreLabel.h"
#import "JZAppDelegate.h"

@implementation JZShareLabel

+ (JZShareLabel *)labelNodeWithFontNamed:(NSString *)fontName
{
    JZShareLabel *label = (JZShareLabel *)[super labelNodeWithFontNamed:fontName];
    
    if (label) {
        JZAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        label.name = delegate.shareLabelName;
        label.text = @"分享我的无聊";
        label.fontSize = 20;
        label.zPosition = 1.0;
    }
    
    return label;
}

- (void)handleTapGestureToShare:(UITapGestureRecognizer *)recognizer
{
    JZScoreLabel *scoreLabel = [JZScoreLabel sharedInstance];
    NSString *score = [NSString stringWithFormat:@"相当无聊的我，戳气球得到%d分 ^-^ 我跟宝宝一样无聊.", scoreLabel.score];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:score
                                       defaultContent:@"比比谁更无聊吧!"
                                                image:nil
                                                title:@"ShareSDK"
                                                  url:@""
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeApp];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
