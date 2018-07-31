//
//  ViewController.m
//  HandShank
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 youshixiu. All rights reserved.
//

#import "ViewController.h"
#import "HandShankView.h"
#import "LLMyHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.view.frame.size.width
    HandShankView *view = [[HandShankView alloc]initWithFrame:CGRectMake((LL_mmWidth(self.view)-200)/2.0, (LL_mmHeight(self.view)-200)/2.0, 200, 200)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
