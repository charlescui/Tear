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
    
    NSString *score;
    
    if (scoreLabel.score < 20) {
        score = [NSString stringWithFormat:@"得到%d分，那你还不算无聊么，快点该干啥干啥去。", scoreLabel.score];
    }else if (scoreLabel.score >= 20 && scoreLabel.score < 100){
        score = [NSString stringWithFormat:@"相当无聊的我，戳气球得到%d分 ^-^ 我跟宝宝一样无聊.", scoreLabel.score];
    }else if (scoreLabel.score >= 100 && scoreLabel.score < 500){
        score = [NSString stringWithFormat:@"我边戳边思考，怎么才能更无聊？于是乎，我戳了%d分.", scoreLabel.score];
    }else if (scoreLabel.score >= 500 && scoreLabel.score < 999){
        score = [NSString stringWithFormat:@"啥也不想了，我要奋力戳出人生的巅峰！我戳，%d分.", scoreLabel.score];
    }else if (scoreLabel.score >= 999){
        score = [NSString stringWithFormat:@"哎呀，%d分，戳爆表了，哎呀呀！", scoreLabel.score];
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon120x120"  ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:score
                                       defaultContent:@"比比谁更无聊吧!"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:score
                                                  url:@"http://www.pgyer.com/hHQs"
                                          description:score
                                            mediaType:SSPublishContentMediaTypeNews];
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
