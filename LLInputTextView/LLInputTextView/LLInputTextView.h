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
typedef void (^LLKeyboadViewWillShow)(CGFloat upHeight);
typedef void (^LLKeybaodViewHide)(void);
NS_ASSUME_NONNULL_BEGIN

@interface LLInputTextView : UIView
@property(nonatomic, assign,readonly) UIEdgeInsets pading;
@property(nonatomic, copy) LLInputTextViewHeightDidChange heightChangeBlcok;
@property(nonatomic, copy) LLKeyboadViewWillShow keyboadWillShowBlock;
@property(nonatomic, copy) LLKeybaodViewHide keyboadWillHideBlock;

-(void)setAddHeight:(CGFloat)addHeight;

@end

NS_ASSUME_NONNULL_END
