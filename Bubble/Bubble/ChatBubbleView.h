//
//  ChatBubbleView.h
//  Bubble
//
//  Created by luo luo on 2019/12/14.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
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
//三角箭头的高度
@property(nonatomic, assign) CGFloat rowHeight;
//线宽
@property(nonatomic, assign) CGFloat lineWidth;

-(instancetype)initWithFrame:(CGRect)frame rowDirection:(ChatBubbleViewRowDirection)direction rowHeight:(CGFloat)rowHeight roundRadius:(CGFloat)radius;
-(void)updateView;


@end

NS_ASSUME_NONNULL_END
