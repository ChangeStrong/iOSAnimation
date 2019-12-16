//
//  UIView+LLFrame.m
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import "UIView+LLFrame.h"

@implementation UIView (LLFrame)
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)width
{
    return self.bounds.size.width;
}
-(CGFloat)height
{
    return self.bounds.size.height;
}
-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

-(void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

-(void)setWidth:(CGFloat)width
{
    self.frame =CGRectMake(self.x, self.y, width, self.height);
}
-(void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

@end
