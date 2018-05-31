//
//  CurveModel.h
//  PieChart
//
//  Created by luo luo on 21/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CurveModel : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) int startAngel;
@property(nonatomic,assign) int endAngel;
@property(nonatomic, strong) UIColor *color;
@property(nonatomic, weak) UILabel *innerLabe;
@property(nonatomic,weak) UILabel *outLabel;
@property(nonatomic, assign) CGPoint innerLabelCenterPoint;
@property(nonatomic, assign) CGPoint outLabelCenterPoint;

@end
