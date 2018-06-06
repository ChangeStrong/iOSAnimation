//
//  CommonUse.m
//  PlanetaryMotion
//
//  Created by luo luo on 06/06/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "CommonUse.h"

@implementation CommonUse
//暂停 layer 层的动画
+ (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
+ (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
@end
