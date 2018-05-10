//
//  BarrageLabel.h
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarrageLabel;
@protocol BarrageLabelProtocol<NSObject>
//目前状态发生改变
-(void)stauesDidChange:(BarrageLabel *)label;
//可见性发生改变
-(void)visibleDidChange:(BarrageLabel *)label;

-(void)startAnimation:(BarrageLabel *)label;

@end

typedef enum :NSInteger{
    BarrageLabelStatusUnknow,
    BarrageLabelStatusUsing,//正在运行中
    BarrageLabelStatusIdle,//空闲
    
}BarrageLabelStatus;

typedef enum : NSInteger{
    BarrageLabelVisibleTypeOutRightOfScreen,//屏幕右边以外
    BarrageLabelVisibleTypeStartInScreen,//开始进入屏幕了
    BarrageLabelVisibleTypeTailInScreen,//尾部进入屏幕
    BarrageLabelVisibleTypeTailLeaveScreen,//尾部离开屏幕
    
}BarrageLabelVisibleType;

@interface BarrageLabel : UILabel

@property(nonatomic, weak) id<BarrageLabelProtocol> delegete;

@property(nonatomic, assign) BarrageLabelStatus currentStatus;
//可见性
@property(nonatomic, assign) BarrageLabelVisibleType currentVisibleType;
//目前运行在第几行
@property(nonatomic, assign) int currentLine;
//layer的起始点
@property(nonatomic, assign) CGPoint layerOrigin;

//开始动画
-(void)startAnimationAtLine:(int)line;
@end
