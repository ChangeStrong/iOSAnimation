//
//  CommonUse.m
//  PieChart
//
//  Created by luo luo on 01/06/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "CommonUse.h"

@implementation CommonUse
+(void)addGradientView:(UIView *)view
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor magentaColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =view.bounds;
    [view.layer addSublayer:gradientLayer];
    
}

//添加动画
+(void)addAnimationLayer:(CALayer *)layer type:(NSString *)type
{
    // 立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.type = type;
    transition.subtype = kCATransitionFromLeft;
    [layer addAnimation:transition forKey:@"animation"];
    
    //        transition.type = @"cube";//立方体
    //        transition.type = @"suckEffect";//没什么效果 吸收
    //        transition.type = @"oglFlip";//  翻转 不管subType is "fromLeft" or "fromRight",official只有一种效果
    
    //                          @"rippleEffect";// 波纹
    //        transition.type = @"pageCurl"; // 翻页
    //        transition.type = @"pageUnCurl"; // 反翻页
    //        transition.type = @"cameraIrisHollowOpen "; // 镜头开
    //        transition.type = @"cameraIrisHollowClose "; // 镜头关
    
    
    //    transition.type 的类型可以有
    //    淡化、推挤、揭开、覆盖
    //    NSString * const kCATransitionFade;
    //    NSString * const kCATransitionMoveIn;
    //    NSString * const kCATransitionPush;
    //    NSString * const kCATransitionReveal;
    //    这四种，
    //    transition.subtype
    //    也有四种
    //    NSString * const kCATransitionFromRight;
    //    NSString * const kCATransitionFromLeft;
    //    NSString * const kCATransitionFromTop;
    //    NSString * const kCATransitionFromBottom;
}
@end
