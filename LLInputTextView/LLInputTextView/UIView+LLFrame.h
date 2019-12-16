//
//  UIView+LLFrame.h
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define X(x) ((SCREENWIDTH / 375.0 * x))
@interface UIView (LLFrame)
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
//-(CGFloat)x;
//-(CGFloat)y;
//-(CGFloat)width;
//-(CGFloat)height;
-(CGFloat)maxX;
-(CGFloat)maxY;
@end

NS_ASSUME_NONNULL_END
