//
//  ViewController.m
//  BarGraph
//
//  Created by luo luo on 17/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "BarGraphView.h"
#import "BarModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self creatBarGraphUI];
}

-(void)creatBarGraphUI
{
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        BarModel *model = [BarModel new];
        model.number = i;
        model.percent = (arc4random()%100)/100.0;
        model.barColor = [UIColor blueColor];
        model.topLineColor = [UIColor yellowColor];
        [array addObject:model];
    }
    
    BarGraphView *barGraphView = [[BarGraphView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 250) models:array];
//    barGraphView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:barGraphView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
