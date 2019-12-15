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
@property(nonatomic, weak) CAShapeLayer *currentLayer;

-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)width;
-(CGFloat)height;
-(CGFloat)contentX;
-(CGFloat)contentY;
-(CGFloat)contentWidth;
-(CGFloat)contentHeight;
-(CGFloat)contentMaxX;
-(CGFloat)contentMaxY;

@end

@implementation ChatBubbleView
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
-(void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self updateView];
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self updateView];
}

-(void)updateView
{
    [self setNeedsDisplay];
    //    [self drawShape];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    UIBezierPath *path = self.rowDirection==ChatBubbleViewRowDirectionLeft? [self bezierPathRowLeft]:[self bezierPathRowRight];
    path.lineWidth = self.lineWidth;
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    
    [path stroke];
    [path fill];
}


-(instancetype)initWithFrame:(CGRect)frame rowDirection:(ChatBubbleViewRowDirection)direction rowHeight:(CGFloat)rowHeight roundRadius:(CGFloat)radius
{
    if (self = [super initWithFrame:frame]) {
        _radius = radius;
        _rowDirection = direction;
        _rowHeight = rowHeight;
        _lineWidth = 1;
        _strokeColor = [UIColor redColor];
        _fillColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
//        [self drawShape];
    }
    return self;
}

-(UIBezierPath *)bezierPathRowLeft
{
    UIBezierPath *path = [UIBezierPath new];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //右上圆角
    CGPoint rightTopCenter = CGPointMake(self.contentMaxX -self.radius, self.contentY + self.radius);
    [path addArcWithCenter:rightTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    //右边线
    [path addLineToPoint:CGPointMake(self.contentMaxX, self.contentMaxY-self.radius)];
    //右下圆角
    CGPoint rightDownCenter = CGPointMake(self.contentMaxX-self.radius,self.contentMaxY - self.radius);
    [path addArcWithCenter:rightDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
    //底部线
    [path addLineToPoint:CGPointMake(self.contentX + self.rowHeight+self.radius, self.contentMaxY)];
    //左下圆角
    CGPoint leftDownCenter = CGPointMake(self.contentX + self.rowHeight+self.radius,self.contentMaxY - self.radius);
    [path addArcWithCenter:leftDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
    //左边直线
    [path addLineToPoint:CGPointMake(self.contentX + self.rowHeight, self.contentY + self.radius)];
    
    //三角形位置 顺时针第一个位置为A
    CGFloat diagonalLength = self.radius/cos(DEGREES_TO_RADIANS(45));
    CGPoint rowA = CGPointMake(self.contentX + self.rowHeight+(diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)), self.contentY + (diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)));
    CGPoint rowB = CGPointMake(self.contentX + self.rowHeight, self.contentY + self.radius);
    CGPoint rowC = CGPointMake(self.contentX + 0, self.contentY + self.radius*1/8.0);//挨着左边边界线的点
   
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
    CGPoint leftTopCenter = CGPointMake(self.contentX + self.rowHeight+self.radius,self.contentY + self.radius);
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
    CGPoint rightTopCenter = CGPointMake(self.contentX + self.radius, self.contentY + self.radius);
    [path addArcWithCenter:rightTopCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
    //左边线
    [path addLineToPoint:CGPointMake(self.contentX, self.contentMaxY-self.radius)];
    //左下圆角
    CGPoint rightDownCenter = CGPointMake(self.contentX + self.radius,self.contentMaxY - self.radius);
    [path addArcWithCenter:rightDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
    //底部线
    [path addLineToPoint:CGPointMake(self.contentX + self.radius, self.contentMaxY)];
    //右下圆角
    CGPoint leftDownCenter = CGPointMake(self.contentMaxX-self.rowHeight-self.radius,self.contentMaxY - self.radius);
    [path addArcWithCenter:leftDownCenter radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
    //右边直线
    [path addLineToPoint:CGPointMake(self.contentMaxX-self.rowHeight, self.contentY + self.radius)];
    
    //三角形位置 逆时针第一个位置为A
    CGFloat diagonalLength = self.radius/cos(DEGREES_TO_RADIANS(45));//对角线长度
    CGPoint rowA = CGPointMake(self.contentMaxX-self.rowHeight-((diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45))), self.contentY+ (diagonalLength-self.radius)*cos(DEGREES_TO_RADIANS(45)));
    CGPoint rowB = CGPointMake(self.contentMaxX-self.rowHeight, self.contentY + self.radius);
    CGPoint rowC = CGPointMake(self.contentMaxX, self.contentY + self.radius*1/8.0);//挨着左边边界线的点

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
    CGPoint leftTopCenter = CGPointMake(self.contentMaxX-self.rowHeight-self.radius,self.contentY + self.radius);
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

-(CGFloat)contentX
{
   return  self.lineWidth;
}
-(CGFloat)contentY
{
    return self.lineWidth;
}

-(CGFloat)contentWidth
{
    return  self.width-2*self.lineWidth;
}
-(CGFloat)contentHeight
{
    return self.height-2*self.lineWidth;
}
-(CGFloat)contentMaxX
{
   return  self.width-self.lineWidth;
}
-(CGFloat)contentMaxY
{
    return self.height-self.lineWidth;
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
