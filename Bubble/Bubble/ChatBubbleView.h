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
-(instancetype)initWithFrame:(CGRect)frame rowDirection:(ChatBubbleViewRowDirection)direction;
@end

NS_ASSUME_NONNULL_END
