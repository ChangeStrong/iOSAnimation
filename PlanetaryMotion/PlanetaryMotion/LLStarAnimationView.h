//
//  LLStarAnimationView.h
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLStarAnimationView : UIView

-(instancetype)initWithFrame:(CGRect)frame starWidth:(CGFloat)width;

//开始动画
-(void)startAnimation;
//停止动画
-(void)stopAnimation;

//暂停 layer 层的动画
- (void)pauseAnimation;

//继续layer上面的动画
- (void)resumeAnimation;
@end
