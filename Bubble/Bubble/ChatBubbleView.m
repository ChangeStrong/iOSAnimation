//
//  ChatBubbleView.m
//  Bubble
//
//  Created by luo luo on 2019/12/14.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import "ChatBubbleView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)



@interface ChatBubbleView()
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic, weak) CAShapeLayer *currentLayer;



@end

@implementation ChatBubbleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    UIBezierPath *path = self.rowDirection==ChatBubbleViewRowDirectionLeft? [self bezierPathRowLeft]:[self bezierPathRowRight];
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    
    [path stroke];
    [path fill];
}


-(instancetype)initWithFrame:(CGRect)frame rowDirection:(ChatBubbleViewRowDirection)direction
{
    if (self = [super initWithFrame:frame]) {
        _radius = 20;
        _rowHeight = 20;
        _rowDirection = direction;
        _strokeColor = [UIColor redColor];
        _fillColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
//        [self drawShape];
    }
    return self;
}

-(void)setRowDirection:(CGFloat)rowDirection
{
    _rowDirection = rowDirection;
    [self updateView];
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self updateView];
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self updateView];
}

-(void)updateView
{
    [self setNeedsDisplay];
    //    [self drawShape];
}



-(UIBezierPath *)bezierPathRowLeft
{
    UIBezierPath *path = [UIBezierPath new];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //右上圆角
    CGPoint rightTopCenter = CGPointMake(self.width-self.radius, self.radius);
    [path addArcWithCenter:rightTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    //右边线
    [path addLineToPoint:CGPointMake(self.width, self.height-self.radius)];
    //右下圆角
    CGPoint rightDownCenter = CGPointMake(self.width-self.radius,self.height - self.radius);
    [path addArcWithCenter:rightDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
    //底部线
    [path addLineToPoint:CGPointMake(self.rowHeight+self.radius, self.height)];
    //左下圆角
    CGPoint leftDownCenter = CGPointMake(self.rowHeight+self.radius,self.height - self.radius);
    [path addArcWithCenter:leftDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
    //左边直线
    [path addLineToPoint:CGPointMake(self.rowHeight, self.radius)];
    
    //三角形位置 顺时针第一个位置为A
    CGFloat diagonalLength = self.radius/cos(DEGREES_TO_RADIANS(45));
    CGPoint rowA = CGPointMake(self.rowHeight+(diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)), (diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)));
    CGPoint rowB = CGPointMake(self.rowHeight, self.radius);
    CGPoint rowC = CGPointMake(0, self.radius*1/8.0);//挨着左边边界线的点
   
    //CB间直线的长度
    CGFloat cbLenght = sqrt(pow(rowB.x-rowC.x, 2)+pow(rowB.y-rowC.y, 2));
    //CB的控制点----暂时放中间
    CGFloat cbSlopeAngle = fabs([self angleBetweenPoints:rowC point2:rowB]);//直线斜率角度
    cbSlopeAngle = DEGREES_TO_RADIANS(cbSlopeAngle);
    CGPoint cbControl = CGPointMake(rowC.x + cbLenght/2.0*cos(cbSlopeAngle),rowC.y+cbLenght/2.0*sin(cbSlopeAngle));
    //用二阶贝塞尔曲线画BC线
    [path addQuadCurveToPoint:rowC controlPoint:cbControl];
//    [path addLineToPoint:rowC];
    //画CA线
    CGFloat caLenght = sqrt(pow(rowA.x-rowC.x, 2)+pow(rowA.y-rowC.y, 2));
    CGFloat caSlopeAngle = fabs([self angleBetweenPoints:rowC point2:rowA]);//直线斜率角度
    caSlopeAngle = DEGREES_TO_RADIANS(caSlopeAngle);
    CGPoint caControl = CGPointMake(rowC.x+caLenght/2.0*cos(caSlopeAngle), rowC.y+caLenght/2.0*sin(caSlopeAngle));//
    //用二阶贝塞尔曲线画BA线
    [path addQuadCurveToPoint:rowA controlPoint:caControl];

    //画1/4圆
    CGPoint leftTopCenter = CGPointMake(self.rowHeight+self.radius,self.radius);
    [path addArcWithCenter:leftTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(225) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    
    //间隙和条的宽度一样大小
    //    path.lineWidth = _BarWidth;
        [path closePath];
    return path;
}

-(UIBezierPath *)bezierPathRowRight
{
    UIBezierPath *path = [UIBezierPath new];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //左上圆角
    CGPoint rightTopCenter = CGPointMake(self.radius, self.radius);
    [path addArcWithCenter:rightTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
    //左边线
    [path addLineToPoint:CGPointMake(0, self.height-self.radius)];
    //左下圆角
    CGPoint rightDownCenter = CGPointMake(self.radius,self.height - self.radius);
    [path addArcWithCenter:rightDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
    //底部线
    [path addLineToPoint:CGPointMake(self.radius, self.height)];
    //右下圆角
    CGPoint leftDownCenter = CGPointMake(self.width-self.rowHeight-self.radius,self.height - self.radius);
    [path addArcWithCenter:leftDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
    //右边直线
    [path addLineToPoint:CGPointMake(self.width-self.rowHeight, self.radius)];
    
    //三角形位置 逆时针第一个位置为A
    CGFloat diagonalLength = self.radius/cos(DEGREES_TO_RADIANS(45));//对角线长度
    CGPoint rowA = CGPointMake(self.width-self.rowHeight-((diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45))), (diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)));
    CGPoint rowB = CGPointMake(self.width-self.rowHeight, self.radius);
    CGPoint rowC = CGPointMake(self.width, self.radius*1/8.0);//挨着左边边界线的点

    //CB间直线的长度
    CGFloat cbLenght = fabs(sqrt(pow(rowB.x-rowC.x, 2)+pow(rowB.y-rowC.y, 2)));
    //CB的控制点----暂时放中间
    CGFloat cbSlopeAngle = fabs([self angleBetweenPoints:rowC point2:rowB]);//直线斜率角度
    cbSlopeAngle = DEGREES_TO_RADIANS(cbSlopeAngle);
    CGPoint cbControl = CGPointMake(rowC.x - cbLenght/2.0*cos(cbSlopeAngle),rowC.y+cbLenght/2.0*sin(cbSlopeAngle));
    //用二阶贝塞尔曲线画BC线
    [path addQuadCurveToPoint:rowC controlPoint:cbControl];
    //    [path addLineToPoint:rowC];
    //画CA线
    CGFloat caLenght = fabs(sqrt(pow(rowA.x-rowC.x, 2)+pow(rowA.y-rowC.y, 2)));
    CGFloat caSlopeAngle = fabs([self angleBetweenPoints:rowC point2:rowA]);//直线斜率角度
    caSlopeAngle = DEGREES_TO_RADIANS(caSlopeAngle);
    CGPoint caControl = CGPointMake(rowC.x-caLenght/2.0*cos(caSlopeAngle), rowC.y+caLenght/2.0*sin(caSlopeAngle));//
    //用二阶贝塞尔曲线画BA线
    [path addQuadCurveToPoint:rowA controlPoint:caControl];
    
//    //画1/4圆
    CGPoint leftTopCenter = CGPointMake(self.width-self.rowHeight-self.radius,self.radius);
    [path addArcWithCenter:leftTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(315) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
    
    //间隙和条的宽度一样大小
    //    path.lineWidth = _BarWidth;
    [path closePath];
    return path;
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

//弧度转角度
#define radiansToDegrees(x) (180.0*x/M_PI)
-(CGFloat)angleBetweenPoints:(CGPoint)point1 point2:(CGPoint)point2
{
    CGFloat height = point2.y - point1.y;
    CGFloat width  = point1.x - point2.x;
    
    CGFloat rads   = atan(height/width);
    
    return radiansToDegrees(rads);
    
}

/*
 -(void)drawShape
 {
 if (self.currentLayer) {
 [self.currentLayer removeFromSuperlayer];
 }
 UIBezierPath *path = self.rowDirection==ChatBubbleViewRowDirectionLeft? [self bezierPathRowLeft]:[self bezierPathRowRight];
 CAShapeLayer *trangleLayer = [CAShapeLayer layer];
 //        maskLayer.backgroundColor = [UIColor purpleColor].CGColor;
 trangleLayer.path = [path CGPath];
 trangleLayer.strokeColor = [UIColor redColor].CGColor;
 trangleLayer.fillColor = [UIColor clearColor].CGColor;
 trangleLayer.lineWidth = 1.0;
 trangleLayer.lineCap = kCALineCapRound;
 trangleLayer.lineJoin = kCALineJoinRound;
 //    trangleLayer.fillColor = obj.color.CGColor;
 //    trangleLayer.fillRule = kCAFillRuleNonZero;//kCAFillRuleEvenOdd画的区域 取反  解释为奇偶。
 [self.layer addSublayer:trangleLayer];
 self.currentLayer = trangleLayer;
 }*/

@end
