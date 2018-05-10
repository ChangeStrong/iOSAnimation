//
//  UIView+Helper.m
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

-(void)addcornerRadius:(CGFloat )radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
