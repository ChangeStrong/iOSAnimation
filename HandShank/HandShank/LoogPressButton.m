//
//  LoogPressButton.m
//  RongTianShi
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 youshixiu. All rights reserved.
//

#import "LoogPressButton.h"
@interface LoogPressButton()

@end

@implementation LoogPressButton{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(LoogPressButton *)createLoogPressButtonFrame:(CGRect)rect color:(UIColor *)color target:(id)target selector:(SEL)selector startClickSelector:(void (^)(UIButton *button))startClick
{
   return [self createLoogPressButtonSuperView:target Frame:rect color:color target:target selector:selector startClickSelector:startClick];
}

+(LoogPressButton *)createLoogPressButtonSuperView:(UIView *)supervew Frame:(CGRect)rect color:(UIColor *)color target:(id)target selector:(SEL)selector startClickSelector:(void (^)(UIButton *button))startClick
{
    LoogPressButton *btn = [LoogPressButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.backgroundColor = color;
    //绑定开始点击事件
    btn.startClick = startClick;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (supervew && [supervew isKindOfClass:[UIViewController class]]) {
        [((UIViewController *)supervew).view addSubview:btn];
    }else if( supervew && [supervew isKindOfClass:[UIView class]]) {
        [(UIView *)supervew addSubview:btn];
    }
    
    return btn;

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
     NSLog(@"开始触摸");
    if (self.startClick) {
        self.startClick(self);
    }
   
}


@end
