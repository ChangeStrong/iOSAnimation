//
//  LLInputTextView.h
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LLFrame.h"
#import "LLTextField.h"
typedef void (^LLInputTextViewHeightDidChange)(CGFloat changeHeight);
NS_ASSUME_NONNULL_BEGIN

@interface LLInputTextView : UIView
@property(nonatomic, assign,readonly) UIEdgeInsets pading;
@property(nonatomic, copy) LLInputTextViewHeightDidChange heightChangeBlcok;

-(void)setPadingBottom:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
