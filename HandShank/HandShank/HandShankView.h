//
//  HandShankView.h
//  RongTianShi
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 youshixiu. All rights reserved.
//
///淡绿色背景

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HandShankDirection) {
    HandShankDirectionStartTop=0,
    HandShankDirectionTop,
    HandShankDirectionStartDown,
    HandShankDirectionDown,
    HandShankDirectionStartLeft,
    HandShankDirectionLeft,
    HandShankDirectionStartRight,
    HandShankDirectionRight,
    HandShankDirectionUnknow
};

@protocol HandShankDelegete  <NSObject>
@optional
-(void)handShankDirectionDidChange:(HandShankDirection)direction;
-(void)handShankDirectionDidEnd;
@end

@interface HandShankView : UIView

@property(nonatomic, weak) id<HandShankDelegete> delegete;

@end
