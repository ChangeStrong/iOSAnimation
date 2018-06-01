//
//  CommonUse.h
//  PieChart
//
//  Created by luo luo on 01/06/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CommonUse : NSObject
//添加动画
+(void)addAnimationLayer:(CALayer *)layer type:(NSString *)type;
@end
