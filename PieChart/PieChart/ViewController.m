//
//  ViewController.m
//  PieChart
//
//  Created by luo luo on 21/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "PieChartView.h"
@interface ViewController ()

@end

@implementation ViewController{
    PieChartView *_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray <CurveModel *>*array = [NSMutableArray array];
    
    for (int i=0; i<10; i++) {
        CurveModel *cuveModel = [[CurveModel alloc]init];
        cuveModel.startAngel = i*360/10;
        cuveModel.endAngel = i*360/10+ 360/10.0;
        int red = arc4random()%255;
        int green = arc4random()%255;
        int blue = arc4random()%255;
        cuveModel.color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
        [array addObject:cuveModel];
    }
    
    PieChartView *view = [[PieChartView alloc]initWithFrame:CGRectMake(100, 100, 250, 250) models:array];
    //    view.backgroundColor = [UIColor redColor];
    _view = view;
    [self.view addSubview:view];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self startAction:nil];
}
- (IBAction)startAction:(UIButton *)sender {
    
    [_view startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
