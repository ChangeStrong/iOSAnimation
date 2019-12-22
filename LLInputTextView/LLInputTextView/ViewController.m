//
//  ViewController.m
//  LLInputTextView
//
//  Created by luo luo on 2019/12/15.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "LLInputTextView.h"

@interface ViewController ()
@property(nonatomic, weak) LLInputTextView *inputTextView;
@end

@implementation ViewController{
    CGFloat _oldY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    LLInputTextView *inputTextView = [[LLInputTextView alloc]initWithFrame:CGRectMake(0, self.view.height-X(41), self.view.width, X(41))];
    [self.view addSubview:inputTextView];
    inputTextView.backgroundColor =[UIColor redColor];
    self.inputTextView = inputTextView;
    typeof(self) __weak weakSelf = self;
    inputTextView.heightChangeBlcok = ^(CGFloat changeHeight) {
        NSLog(@"old:%f",weakSelf.inputTextView.y);
        weakSelf.inputTextView.y = weakSelf.inputTextView.y-changeHeight;
        NSLog(@"new:%f",weakSelf.inputTextView.y);
    };
    
    inputTextView.keyboadWillShowBlock = ^(CGFloat upHeight) {
        
        self->_oldY = weakSelf.inputTextView.y;
        weakSelf.inputTextView.y = weakSelf.inputTextView.y - upHeight;
        [weakSelf.inputTextView setAddHeight:-weakSelf.view.safeAreaInsets.bottom];
    };
    
    inputTextView.keyboadWillHideBlock = ^{
        [weakSelf.inputTextView setAddHeight:weakSelf.view.safeAreaInsets.bottom];
        weakSelf.inputTextView.y = self->_oldY;
        
    };
    
    
}
//安全区域改变
-(void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0,*)) {
        UIEdgeInsets insets =  self.view.safeAreaInsets;
        NSLog(@"top=%f bottom=%f",insets.top,insets.bottom);
        [self.inputTextView setAddHeight:insets.bottom];
    }
    
}

@end
