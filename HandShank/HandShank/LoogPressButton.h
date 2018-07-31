//
//  LoogPressButton.h
//  RongTianShi
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 youshixiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoogPressButton : UIButton
@property(nonatomic,copy)void (^startClick)(UIButton *);
//此接口target也作为superview
+(LoogPressButton *)createLoogPressButtonFrame:(CGRect)rect color:(UIColor *)color target:(id)target selector:(SEL)selector startClickSelector:(void (^)(UIButton *button))startClick;

+(LoogPressButton *)createLoogPressButtonSuperView:(UIView *)supervew Frame:(CGRect)rect color:(UIColor *)color target:(id)target selector:(SEL)selector startClickSelector:(void (^)(UIButton *button))startClick;

@end
