//
//  BarModel.h
//  BarGraph
//
//  Created by luo luo on 17/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarModel : NSObject
@property(nonatomic, assign) int number;
@property(nonatomic, assign) float percent;
@property(nonatomic, strong) UIColor *barColor;
@property(nonatomic, strong) UIColor *topLineColor;
//无需填写的属性
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, assign) CGPoint topLineStartPoint;//顶部黄色线位置
@property(nonatomic, assign) CGPoint topLineEndPoint;


@end
