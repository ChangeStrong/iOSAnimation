//
//  UIView+LLMask.h
//  MaskAnimation
//
//  Created by luo luo on 10/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LLMask)
//路径选择 degree 三角形底部角度 30度
-(UIBezierPath *)getBottomTrangelPathDegree:(CGFloat)degree;

//开始遮罩
-(void)addMaskPath:(UIBezierPath *)path isReverse:(BOOL)isReverse;

@end
