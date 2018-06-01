//
//  PieChartView.m
//  PieChart
//
//  Created by luo luo on 21/05/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "PieChartView.h"
#import "CurveModel.h"
#import "CommonUse.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@interface PieChartView()<CAAnimationDelegate>

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
-(NSMutableArray <CurveModel *>*)models
{
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

-(instancetype)initWithFrame:(CGRect)frame models:(NSMutableArray <CurveModel *>*)models
{
    if (self = [super initWithFrame:frame]) {
         _radius = [self height]/2.0-(30*cos(DEGREES_TO_RADIANS(45))*2.0);//减去外部内部需要的尺寸
         _centerPoint = CGPointMake([self width]/2.0, [self height]/2.0);
//        self.bounds = CGRectMake(_centerPoint.x, _centerPoint.y, frame.size.width, frame.size.height);
        [self.models setArray:models];
        self.clipsToBounds = YES;
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
    [self.models enumerateObjectsUsingBlock:^(CurveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [self bezierPathStartAngle:obj.startAngel endAngle:obj.endAngel];
        CAShapeLayer *trangleLayer = [CAShapeLayer layer];
        //        maskLayer.backgroundColor = [UIColor purpleColor].CGColor;
        trangleLayer.path = [path CGPath];
        trangleLayer.fillColor = obj.color.CGColor;
        trangleLayer.fillRule = kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
        [self.layer addSublayer:trangleLayer];
        obj.trangleLayer = trangleLayer;
        
         CGFloat angle = obj.endAngel-(obj.endAngel-obj.startAngel)/2.0;//扇形边缘中心位置的角度
        //扇形边缘的中心点
//        CGPoint aPoint = CGPointMake(_centerPoint.x+ _radius*cos(DEGREES_TO_RADIANS(angle)),_centerPoint.y+ _radius*sin(DEGREES_TO_RADIANS(angle)));
        //外面边缘的半径
        CGFloat outRadius = [self height]/2.0+100;//100是随意
        CGPoint outCenterPoint = CGPointMake(_centerPoint.x+ outRadius*cos(DEGREES_TO_RADIANS(angle)), _centerPoint.y+outRadius*sin(DEGREES_TO_RADIANS(angle)));
        obj.outCenterPoint = outCenterPoint;
        
        int width = 30;
        //内部边缘文字
        UILabel *label0 = [[UILabel alloc]init];
        label0.adjustsFontSizeToFitWidth = YES;
        label0.bounds = CGRectMake(0, 0, width, width);
        CGFloat newRadius0 = (_radius-((width/2.0)/cos(DEGREES_TO_RADIANS(45))));//扇形的半径+label的对角线长度
        //新半径扇形的边缘中心点
        CGPoint bPoint0 = CGPointMake(_centerPoint.x+ newRadius0*cos(DEGREES_TO_RADIANS(angle)), _centerPoint.y+newRadius0*sin(DEGREES_TO_RADIANS(angle)));
        obj.innerLabelCenterPoint = bPoint0;
        obj.innerLabe = label0;
        label0.center = outCenterPoint;
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
        obj.outLabelCenterPoint = bPoint;
        obj.outLabel=label;
        label.center = outCenterPoint; //CGPointMake( aPoint.x+width/2.0, aPoint.y+((width/2.0)*tan(DEGREES_TO_RADIANS(angle))));
        [self addSubview:label];
        
    }];
    
}

-(void)startAnimation
{
    //翻转 oglFlip
   [CommonUse addAnimationLayer:self.layer type:@"oglFlip"];
    
    [self.models enumerateObjectsUsingBlock:^(CurveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self startLabelAnimation:obj];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimation];
    });
}

-(void)stopAnimation
{
    [self.layer removeAllAnimations];
}

-(void)startLabelAnimation:(CurveModel *)model
{
    model.innerLabe.center = model.outCenterPoint;
    model.outLabel.center = model.outCenterPoint;
    [UIView animateWithDuration:2.0 animations:^{
        model.innerLabe.center = model.innerLabelCenterPoint;
        model.outLabel.center = model.outLabelCenterPoint;
    }];
    
}



#pragma mark CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart");
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
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
