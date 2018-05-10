//
//  ViewController.m
//  MaskAnimation
//
//  Created by luo luo on 10/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LLMask.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self createView];
}

-(void)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100,100, 200, 300)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view addMaskPath:[view getBottomTrangelPath] isReverse:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
