//
//  LLAnimationItem.m
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import "LLAnimationItem.h"



@implementation LLAnimationItem
static NSArray *ItemNames;
+(NSArray *)itemNames
{
    ItemNames = @[@"A Item",@"B item",@"C item",@"Center Item"];
    return ItemNames;
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
   
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
