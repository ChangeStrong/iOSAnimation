//
//  UIView+LLMask.m
//  MaskAnimation
//
//  Created by luo luo on 10/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "UIView+LLMask.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation UIView (LLMask)

-(UIBezierPath *)getBottomTrangelPathDegree:(CGFloat)degree
{
    CGPoint bPoint= CGPointMake(0, [self height]);
    CGPoint cPoint = CGPointMake([self width], [self height]);
    CGPoint ePoint = CGPointMake([self width], ([self height]-(tan(DEGREES_TO_RADIANS(degree))*[self width])));
     UIBezierPath *path0 = [UIBezierPath bezierPathWithRect:self.bounds];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:bPoint];
    [path addLineToPoint:cPoint];
    [path addLineToPoint:ePoint];
    [path addLineToPoint:bPoint];
    
    [path appendPath:path0];//两个路径将封闭一个区域出来  正方形内包裹一个三角形  画的为非三角形内的区域
    
//    [path closePath];
    
    return path;
}

-(void)addMaskPath:(UIBezierPath *)path  isReverse:(BOOL)isReverse
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor purpleColor].CGColor;
    maskLayer.path = [path CGPath];
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.fillRule = isReverse == YES?kCAFillRuleEvenOdd:kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
    self.layer.mask = maskLayer;
    
}

-(CGFloat)width
{
    return self.bounds.size.width;
}
-(CGFloat)height
{
    return self.bounds.size.height;
}

@end
