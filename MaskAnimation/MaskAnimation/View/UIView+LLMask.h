//
//  UIView+LLMask.h
//  MaskAnimation
//
//  Created by luo luo on 10/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LLMask)
//路径选择
-(UIBezierPath *)getBottomTrangelPath;

//开始遮罩
-(void)addMaskPath:(UIBezierPath *)path isReverse:(BOOL)isReverse;

@end
