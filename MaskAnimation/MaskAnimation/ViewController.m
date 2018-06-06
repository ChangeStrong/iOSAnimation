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
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
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
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(100,100, 200, 300)];
    view.image = [UIImage imageNamed:@"timg.jpeg"];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view addMaskPath:[view getBottomTrangelPathDegree:15] isReverse:NO];
    
}
- (IBAction)startAnimationAction:(UIButton *)sender {
    [self startAnimation];
}

-(void)startAnimation
{
    //颜色渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bgImageView.bounds;
    gradientLayer.startPoint = CGPointMake(0.5, 1);
    gradientLayer.endPoint = CGPointMake(0.5, 0);
    gradientLayer.colors = @[(__bridge id)[[UIColor orangeColor]colorWithAlphaComponent:0.2].CGColor,(__bridge id)[[UIColor orangeColor]colorWithAlphaComponent:1.0].CGColor];
    [self.bgImageView.layer addSublayer:gradientLayer];
    
    //路径 作为遮罩
    CAShapeLayer *shapelayer = [CAShapeLayer  layer];
    shapelayer.position = CGPointMake(0, 0);
    shapelayer.lineWidth = 120;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, 0, self.bgImageView.frame.size.width/2.0, self.bgImageView.frame.size.height);
    CGPathAddLineToPoint(path, 0, self.bgImageView.frame.size.width/2.0, 0);
    shapelayer.path = path;
    shapelayer.strokeColor = [UIColor greenColor].CGColor;//划线的颜色
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    self.bgImageView.layer.mask = shapelayer;
    
    //对路径层添加动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    //    animation.path = path;
    animation.duration = 5.0;
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    [shapelayer addAnimation:animation forKey:@"strokeEnd"];//对划线属性进行动画
}
- (IBAction)changeAnimationAction:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
