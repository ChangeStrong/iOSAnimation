//
//  ChatBubbleView.h
//  Bubble
//
//  Created by luo luo on 2019/12/14.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LLFrame.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum :NSInteger{
    ChatBubbleViewRowDirectionLeft,
    ChatBubbleViewRowDirectionright
}ChatBubbleViewRowDirection;

@interface ChatBubbleView : UIView
//箭头朝向 左-右
@property(nonatomic, assign) CGFloat rowDirection;
//线条颜色
@property(nonatomic, strong) UIColor *strokeColor;
//填充色
@property(nonatomic, strong) UIColor *fillColor;

-(instancetype)initWithFrame:(CGRect)frame rowDirection:(ChatBubbleViewRowDirection)direction;
-(void)updateView;
@end

NS_ASSUME_NONNULL_END
