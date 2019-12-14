//
//  UIView+LLFrame.m
//  Bubble
//
//  Created by luo luo on 2019/12/14.
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
    return self.frame.size.width;
}
-(CGFloat)height
{
    return self.frame.size.height;
}
-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

@end
