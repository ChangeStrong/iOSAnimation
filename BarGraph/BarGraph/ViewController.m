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
#import "LLBarAudioView.h"

@interface ViewController ()

@end

@implementation ViewController{
    LLBarAudioView *_auidoBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self creatBarGraphUI];
}

-(void)updateUI{
    [_auidoBarView setNeedsDisplay];
}

-(void)creatBarGraphUI
{
    _auidoBarView = [[LLBarAudioView alloc]initWithFrame:CGRectMake(50, 50, 200, 200) barNumer:10];
    [self.view addSubview:_auidoBarView];
    
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        BarModel *model = [BarModel new];
        model.number = i;
        model.percent = (arc4random()%100)/100.0;
        model.barColor = [UIColor blueColor];
        model.topLineColor = [UIColor yellowColor];
        [array addObject:model];
    }

    BarGraphView *barGraphView = [[BarGraphView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 250) models:array];
    barGraphView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:barGraphView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
