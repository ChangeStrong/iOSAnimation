//
//  BarGraphView.h
//  BarGraph
//
//  Created by luo luo on 17/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarModel.h"
@interface BarGraphView : UIView
-(instancetype)initWithFrame:(CGRect)frame models:(NSMutableArray <BarModel *>*)models;


@end
