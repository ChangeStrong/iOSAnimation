//
//  LLBarAudioView.h
//  BarGraph
//
//  Created by luo luo on 27/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface LLBarAudioView : UIView
@property(nonatomic, assign) NSUInteger barNumber;
-(instancetype)initWithFrame:(CGRect)frame barNumer:(NSUInteger)barNumber;
@end
