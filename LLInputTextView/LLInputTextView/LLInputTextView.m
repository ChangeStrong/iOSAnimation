//
//  LLInputTextView.m
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import "LLInputTextView.h"

@interface LLInputTextView()
@property(nonatomic, weak) UITextField *inputTextFeild;
@property(nonatomic, weak) UIView *inputBgView;
@property(nonatomic, assign) UIEdgeInsets pading;
@property(nonatomic, assign) CGFloat addHeight;
@end

@implementation LLInputTextView{
//    CGFloat _oldY;
//    CGFloat _oldRadius;
//    CGFloat _oldPaddingBottom;
//    CGRect _lastRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.inputTextFeild removeObserver:self forKeyPath:@"frame"];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        _oldY = 0;
        _pading = UIEdgeInsetsMake(X(8), X(10), 0, X(10));
        _addHeight = 0;
        [self creatUI];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void)creatUI
{
    CGFloat inputHeight = self.height-self.pading.top-self.pading.bottom;
    CGFloat sendButtonHeight = inputHeight-5*2;//高度比输入框小5*2像素
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"Send"] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    sendButton.frame = CGRectMake(self.width-self.pading.right-X(32),self.pading.top + 5, sendButtonHeight, sendButtonHeight);
    //输入框和发送按钮的间隙为X(15)
    LLTextField *inputTF = [[LLTextField alloc]initWithFrame:CGRectMake(self.pading.left, self.pading.top, self.width-sendButton.width-X(15)-self.pading.left-self.pading.right, inputHeight) placeholder:@"" clear:NO leftView:nil fontSize:14];
//    inputTF.delegate = self;
//    inputTF.placeholder = @"请输入文字";
    inputTF.font =[UIFont systemFontOfSize:14.0];
    inputTF.textAlignment = NSTextAlignmentLeft;
    inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
    inputTF.borderStyle =  UITextBorderStyleNone;
    inputTF.backgroundColor = [UIColor whiteColor];
    //键盘工具条设为空
//    inputTF.inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [inputTF addTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:inputTF];
//    inputTF.frame = CGRectMake(self.pading.left, self.pading.top, self.width-sendButton.width-X(15)-self.pading.left-self.pading.right, inputHeight);
    self.inputTextFeild = inputTF;
//    _oldRadius = inputTF.height/2.0;
    inputTF.layer.cornerRadius = inputTF.height/2.0;
   
    
//    UIView *inputBgView = [UIView new];
//    [self addSubview:inputBgView];
//    inputBgView.backgroundColor = [UIColor whiteColor];
//    inputBgView.frame = inputTF.frame;
//    [self sendSubviewToBack:inputBgView];
//     self.inputBgView = inputBgView;
//    inputBgView.layer.cornerRadius = inputBgView.height/2.0;
//    inputBgView.layer.masksToBounds = YES;
    
     self.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:252/255.0 alpha:1.0];
    //监控输入框的fame发生变化
//    _lastRect = inputTF.frame;
    [inputTF addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)sendAction:(UIButton *)btn
{
    
}

-(void)editingChanged
{
    
}

//当key路径对应的属性值发生改变时，监听器就会回调自身的监听方法，如下
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)contex{
    
    if ([keyPath isEqualToString:@"frame"] && object == self.inputTextFeild) {
        CGRect newRect = [[change valueForKey:@"new"] CGRectValue];
        CGRect oldRect = [[change valueForKey:@"old"]CGRectValue];
        if (!CGRectEqualToRect(oldRect, newRect)) {
//            _lastRect = newRect;
            //更新frame
            CGFloat addHeight = newRect.size.height-oldRect.size.height;
            self.height = self.height+addHeight; //输入宽增加的高度
            NSString *rect =  NSStringFromCGRect(newRect);
            if (self.heightChangeBlcok) {
                self.heightChangeBlcok(addHeight);
            }
        }
    }
}

-(void)setAddHeight:(CGFloat)addHeight
{
    _addHeight = addHeight;
//    self.pading = UIEdgeInsetsMake(self.pading.top, self.pading.left, value-self.pading.bottom, self.pading.right);
    self.height = self.height+addHeight;
    if (self.heightChangeBlcok) {
        self.heightChangeBlcok(addHeight);
    }
}
#pragma mark 键盘通知
//键盘监听
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
//    if (_oldY == 0) {
//        _oldY = self.y;
//        _oldPaddingBottom = self.pading.bottom;
//    }
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect beginFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = beginFrame.origin.y - endFrame.origin.y;
    
    
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
        NSLog(@"yoffset:%f ",yOffset);
    if (self.keyboadWillShowBlock) {
        self.keyboadWillShowBlock(yOffset);
    }
//    self.y = self.y - yOffset;
//    [self setPadingBottom:-_addHeight];//取负值
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.keyboadWillHideBlock) {
        self.keyboadWillHideBlock();
    }
//    self.y = _oldY;
//     [self setPadingBottom:_oldPaddingBottom];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.inputBgView.frame = self.inputTextFeild.frame;
//    self.inputBgView.layer.cornerRadius = (self.inputBgView.height/2.0);
//    self.inputBgView.layer.masksToBounds = YES;
//    self.inputTextFeild.layer.cornerRadius = self.inputTextFeild.height/2.0;
}

//#pragma mark UITextFieldDelegate
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return  YES;
//}


@end
