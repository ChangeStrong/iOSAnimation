//
//  PieChartView.h
//  PieChart
//
//  Created by luo luo on 21/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveModel.h"

@interface PieChartView : UIView
@property(nonatomic, strong)  NSMutableArray <CurveModel *>*models;
-(instancetype)initWithFrame:(CGRect)frame models:(NSMutableArray <CurveModel *>*)models;
-(void)startAnimation;
@end
