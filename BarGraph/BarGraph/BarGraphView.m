//
//  BarGraphView.m
//  BarGraph
//
//  Created by luo luo on 17/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "BarGraphView.h"
@interface BarGraphView()
@property(nonatomic, strong)  NSMutableArray <BarModel *>*models;
//边界insets
@property(nonatomic, assign) UIEdgeInsets contentInsets;
@end
@implementation BarGraphView{
    CGFloat _BarWidth;
//    CGFloat _intervalWidth;//间隙宽
}

-(NSMutableArray <BarModel *>*)models
{
    if (!_models) {
        _models = [[NSMutableArray alloc]init];
    }
    return _models;
}

-(instancetype)initWithFrame:(CGRect)frame models:(NSMutableArray <BarModel *>*)models
{
    if (self = [super initWithFrame:frame]) {
        _contentInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        [self.models setArray:models];
          _BarWidth = self.models.count>0?self.frame.size.width/(self.models.count*2 +1):20;
        //初始化赋值
        typeof(self) __weak weakSelf = self;
       //对初始化位置赋值
        [self.models enumerateObjectsUsingBlock:^(BarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = (_BarWidth+_BarWidth)*(idx+1)-_BarWidth/2.0;
            obj.startPoint = CGPointMake(x, weakSelf.frame.size.height-weakSelf.contentInsets.bottom);
            CGFloat y =weakSelf.contentInsets.top + (weakSelf.frame.size.height-(weakSelf.contentInsets.bottom+weakSelf.contentInsets.top))*obj.percent;
            obj.endPoint = CGPointMake(x, y);
            obj.topLineStartPoint = CGPointMake(x-_BarWidth/2.0, y);
            obj.topLineEndPoint = CGPointMake(x+_BarWidth/2.0, y);
        }];
        
        [self createUI];
    }
    return self;
}

-(UIBezierPath *)bezierPathStartAngle:(CGPoint)startPoint endAngle:(CGPoint)endPoint
{
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    //间隙和条的宽度一样大小
//    path.lineWidth = _BarWidth;
//    [path closePath];
    return path;
}

-(void)createUI{
    [self.models enumerateObjectsUsingBlock:^(BarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //画条
        UIBezierPath *path = [self bezierPathStartAngle:obj.startPoint endAngle:obj.endPoint];
        CAShapeLayer *trangleLayer = [CAShapeLayer layer];
        trangleLayer.lineWidth = _BarWidth;
        trangleLayer.path = [path CGPath];
        trangleLayer.strokeColor = obj.barColor.CGColor;
        trangleLayer.fillRule = kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
        [self.layer addSublayer:trangleLayer];
        
        //画顶部线
        UIBezierPath *topPath = [self bezierPathStartAngle:obj.topLineStartPoint endAngle:obj.topLineEndPoint];
        CAShapeLayer *topLayer = [CAShapeLayer layer];
        topLayer.lineWidth = 2;
        topLayer.path = [topPath CGPath];
        topLayer.strokeColor = obj.topLineColor.CGColor;
        topLayer.fillRule = kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
        [self.layer addSublayer:topLayer];
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
