//
//  CommonUse.h
//  PlanetaryMotion
//
//  Created by luo luo on 06/06/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonUse : NSObject
//暂停 layer 层的动画
+ (void)pauseLayer:(CALayer*)layer;
//继续layer上面的动画
+ (void)resumeLayer:(CALayer*)layer;
@end
