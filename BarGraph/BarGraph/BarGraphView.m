//
//  BarGraphView.m
//  BarGraph
//
//  Created by luo luo on 17/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "BarGraphView.h"
#import "LLMyHeader.h"
#import "ZXUIConstant.h"
@interface BarGraphView()
@property(nonatomic, strong)  NSMutableArray <BarModel *>*models;
//边界insets
@property(nonatomic, assign) UIEdgeInsets contentInsets;
@end
@implementation BarGraphView{
    CGFloat _BarWidth;
    CGFloat _intervalWidth;//间隙宽
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
        _intervalWidth = 14.0*FIT_WIDTH;
        _contentInsets = UIEdgeInsetsMake(10, 34*FIT_WIDTH, 22.0*FIT_HEIGHT, 35*FIT_WIDTH);
        [self.models setArray:models];
        if (self.models.count > 0) {
              CGFloat width = (LL_mmWidth(self)-(self.contentInsets.left+self.contentInsets.right)-_intervalWidth*(self.models.count-1))/self.models.count;
            _BarWidth = width;
        }else{
            _BarWidth = 20;
        }
      
        //初始化赋值
        typeof(self) __weak weakSelf = self;
       //对初始化位置赋值
        [self.models enumerateObjectsUsingBlock:^(BarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = weakSelf.contentInsets.left+(_BarWidth+_intervalWidth)*idx+_BarWidth/2.0;
            obj.startPoint = CGPointMake(x, weakSelf.frame.size.height-weakSelf.contentInsets.bottom);
            CGFloat y =weakSelf.contentInsets.top +(LL_mmHeight(weakSelf)-(weakSelf.contentInsets.bottom+weakSelf.contentInsets.top))*(1-obj.percent);//倒过来显示
            obj.endPoint = CGPointMake(x, y);
            obj.topLineStartPoint = CGPointMake(x-_BarWidth/2.0, y-2.5);
            obj.topLineEndPoint = CGPointMake(x+_BarWidth/2.0, y-2.5);
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
    
    //黄线
    UIView *yellowLine = [[UIView alloc]init];
    yellowLine.backgroundColor = UIColorHex(0xF8E71C);
    yellowLine.frame = CGRectMake(18*FIT_WIDTH, self.contentInsets.top-2.0*FIT_HEIGHT, LL_mmWidth(self)-(18+17)*FIT_WIDTH, 2.0*FIT_HEIGHT);
    [self addSubview:yellowLine];
    
    [self.models enumerateObjectsUsingBlock:^(BarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //显示详细百分比
        UILabel *label = [[UILabel alloc]init];
//        label.adjustsFontSizeToFitWidth = YES;
        label.font =  FitFontSize(8.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorHex(0xF8E71C);
        label.center = CGPointMake(obj.startPoint.x, (self.contentInsets.top-2.0*FIT_HEIGHT)/2.0);
        label.bounds = CGRectMake(0, 0, _BarWidth+_intervalWidth, self.contentInsets.top-2.0*FIT_HEIGHT);
        label.text = [NSString stringWithFormat:@"%d%%",(int)(obj.percent*100.0)];
        [self addSubview:label];
        
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
        topLayer.lineWidth = 5;
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
