//
//  BarrageLine.h
//  BigBig
//
//  Created by gleeeli on 2018/5/6.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum :NSInteger{
    BarrageLineStatusIdle,//空闲的
    BarrageLineStatusBusy,//忙碌的
}BarrageLineStatusType;
@interface BarrageLine : NSObject
//当前的行
@property(nonatomic, assign) NSUInteger currentLine;
//目前状态
@property(nonatomic, assign) BarrageLineStatusType currentStatus;
@end
