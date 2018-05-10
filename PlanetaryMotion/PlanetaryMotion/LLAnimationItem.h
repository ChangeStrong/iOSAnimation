//
//  LLAnimationItem.h
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import <UIKit/UIKit.h>

/******三角形*******
    A
 B      C
 ************/
typedef enum :NSInteger{
    TriangleTypeA=0,
    TriangleTypeB,
    TriangleTypeC,
    TriangleTypeCenter,
}TriangleType;


@interface LLAnimationItem : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//位于星球图的那个位置三角形
@property(nonatomic, assign) TriangleType itemType;
+(NSArray *)itemNames;
@end
