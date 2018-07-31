//
//  LLBarAudioView.m
//  BarGraph
//
//  Created by luo luo on 27/07/2018.
//  Copyright © 2018 ChangeStrong. All rights reserved.
//

#import "LLBarAudioView.h"
#import "LLMyHeader.h"

@implementation LLBarAudioView{
    NSUInteger _currentIndex;
    NSUInteger _barInterval;
    NSUInteger _barWidth;
    UIEdgeInsets _defaultEdgeInsets;
}

-(instancetype)initWithFrame:(CGRect)frame barNumer:(NSUInteger)barNumber
{
     if (self = [super initWithFrame:frame]) {
         self.barNumber = barNumber;
         _currentIndex = 0;
         _barInterval = 5.0;
         _barWidth = (LL_mmWidth(self)-(barNumber+1)*_barInterval)/barNumber;
         _defaultEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
     }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_currentIndex >= self.barNumber ) {
        _currentIndex = 0;
    }
   
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    //2.创建路径对象
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i=0; i<self.barNumber; i++) {
        CGFloat x = (_barInterval+_barWidth)*(i+1)-_barWidth/2.0;
//        CGFloat y;
        CGPoint startPoint;
        CGPoint endPoint ;
        if (i==_currentIndex) {
            //最高bar
            startPoint = CGPointMake(x, LL_mmHeight(self)-_defaultEdgeInsets.bottom);
            endPoint = CGPointMake(x, _defaultEdgeInsets.top);
            CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);//移动到指定位置（设置路径起点）
            CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);//绘制直线（从起始位置开始）
        }else{
            //短的bar
            NSUInteger randomHeight = LL_mmHeight(self)/3.0;
            NSUInteger barHeight =LL_mmHeight(self)/10.0+  arc4random()%randomHeight;
           
            startPoint = CGPointMake(x, (LL_mmHeight(self)-barHeight)/2.0+barHeight);
            endPoint = CGPointMake(x, (LL_mmHeight(self)-barHeight)/2.0);
            
            CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);//移动到指定位置（设置路径起点）
            CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);//绘制直线（从起始位置开始）
            
        }
    }
    
    //3.添加路径到图形上下文
    CGContextAddPath(context, path);
    //4.设置图形上下文状态属性
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);//设置笔触颜色
//    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1);//设置填充色
    CGContextSetLineWidth(context, _barWidth);//设置线条宽度
    CGContextSetLineCap(context, kCGLineCapRound);//设置顶点样式,（20,50）和（300,100）是顶点
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式，(20,100)是连接点
    
   
    CGContextDrawPath(context, kCGPathFillStroke);//最后一个参数是填充类型
    
    //6.释放对象
    CGPathRelease(path);
   
    
    _currentIndex++;
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

@end
