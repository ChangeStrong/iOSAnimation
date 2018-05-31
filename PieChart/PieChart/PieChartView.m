//
//  PieChartView.m
//  PieChart
//
//  Created by luo luo on 21/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "PieChartView.h"
#import "CurveModel.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@interface PieChartView()

@end

@implementation PieChartView{
    CGFloat _radius;
    CGPoint _centerPoint;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
         _radius = [self height]/2.0;
         _centerPoint = CGPointMake([self width]/2.0, [self height]/2.0);
//        self.bounds = CGRectMake(_centerPoint.x, _centerPoint.y, frame.size.width, frame.size.height);
        [self createPieChartView];
    }
    return self;
}

-(UIBezierPath *)bezierPathStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:_centerPoint];
    [path addArcWithCenter:_centerPoint radius:_radius startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:YES];
    [path closePath];
    return path;
}

-(void)createPieChartView
{
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
    
    [array enumerateObjectsUsingBlock:^(CurveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [self bezierPathStartAngle:obj.startAngel endAngle:obj.endAngel];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        //        maskLayer.backgroundColor = [UIColor purpleColor].CGColor;
        maskLayer.path = [path CGPath];
        maskLayer.fillColor = obj.color.CGColor;
        maskLayer.fillRule = kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
        [self.layer addSublayer:maskLayer];
        
         CGFloat angle = obj.endAngel-(obj.endAngel-obj.startAngel)/2.0;//扇形边缘中心位置的角度
        //扇形边缘的中心点
//        CGPoint aPoint = CGPointMake(_centerPoint.x+ _radius*cos(DEGREES_TO_RADIANS(angle)),_centerPoint.y+ _radius*sin(DEGREES_TO_RADIANS(angle)));
        
        int width = 30;
        //内部边缘文字
        UILabel *label0 = [[UILabel alloc]init];
        label0.adjustsFontSizeToFitWidth = YES;
        label0.bounds = CGRectMake(0, 0, width, width);
        CGFloat newRadius0 = (_radius-((width/2.0)/cos(DEGREES_TO_RADIANS(45))));//扇形的半径+label的对角线长度
        //新半径扇形的边缘中心点
        CGPoint bPoint0 = CGPointMake(_centerPoint.x+ newRadius0*cos(DEGREES_TO_RADIANS(angle)), _centerPoint.y+newRadius0*sin(DEGREES_TO_RADIANS(angle)));
        label0.center = bPoint0;
        label0.text = @"6";
        label0.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label0];
        
        //外围边缘文字
        UILabel *label = [[UILabel alloc]init];
        label.text = @"%10";
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.bounds = CGRectMake(0, 0, width, width);
        CGFloat newRadius = (_radius+((width/2.0)/cos(DEGREES_TO_RADIANS(45))));//扇形的半径+label的对角线长度
        //新半径扇形的边缘中心点
        CGPoint bPoint = CGPointMake(_centerPoint.x+ newRadius*cos(DEGREES_TO_RADIANS(angle)), _centerPoint.y+newRadius*sin(DEGREES_TO_RADIANS(angle)));
        label.center = bPoint; //CGPointMake( aPoint.x+width/2.0, aPoint.y+((width/2.0)*tan(DEGREES_TO_RADIANS(angle))));
        [self addSubview:label];
    }];
    
}
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)width
{
    return self.bounds.size.width;
}
-(CGFloat)height
{
    return self.bounds.size.height;
}

@end
