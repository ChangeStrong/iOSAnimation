//
//  ViewController.m
//  PlanetaryMotion
//
//  Created by luo luo on 10/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "LLStarAnimationView.h"
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height - 20.0)

@interface ViewController ()
@property(nonatomic, strong) LLStarAnimationView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createStarUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view sendSubviewToBack:self.animationView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.animationView startAnimation];
}

-(void)createStarUI
{
    _animationView = [[LLStarAnimationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) starWidth:50];
    [self.view addSubview:_animationView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
