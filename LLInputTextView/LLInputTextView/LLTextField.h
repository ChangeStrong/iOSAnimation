//
//  LLTextField.h
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LLFrame.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLTextField : UITextField<UITextFieldDelegate>
-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder clear:(BOOL)clear leftView:(UIView *)view fontSize:(CGFloat)font;
@end

NS_ASSUME_NONNULL_END
