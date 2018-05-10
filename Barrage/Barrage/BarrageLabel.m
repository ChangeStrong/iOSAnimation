//
//  BarrageLabel.m
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import "BarrageLabel.h"
#import "LLMyHeader.h"
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height - 20.0)

@interface BarrageLabel()<CAAnimationDelegate>
@property(nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation BarrageLabel{
    CGPoint _startPoint;
    CGPoint _endPoint;
}

-(void)setCurrentVisibleType:(BarrageLabelVisibleType)currentVisibleType
{
    if (_currentVisibleType != currentVisibleType) {
        //通知代理可见度发生改变
         _currentVisibleType = currentVisibleType;
        if (self.delegete && [self.delegete respondsToSelector:@selector(visibleDidChange:)]) {
//            NSLog(@"visible property did change .");
            [self.delegete visibleDidChange:self];
        }
    }
    
}

-(void)setCurrentStatus:(BarrageLabelStatus)currentStatus
{
    if (_currentStatus != currentStatus) {
        _currentStatus = currentStatus;
        //通知代理状态发生改变
        if (self.delegete && [self.delegete respondsToSelector:@selector(stauesDidChange:)]) {
//            NSLog(@"statuse property did change .");
            [self.delegete stauesDidChange:self];
        }
    }
}


#pragma mark 接口
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.layerOrigin = CGPointMake(frame.origin.x, frame.origin.y);
         self.currentVisibleType = BarrageLabelVisibleTypeOutRightOfScreen;
        self.numberOfLines = 1;
    }
    return self;
}

//开始动画 line 在第几行滚动
-(void)startAnimationAtLine:(int)line
{
    self.currentLine = line;
    self.currentStatus = BarrageLabelStatusUsing;
    
    //右边的点作为开始
    _startPoint = CGPointMake(kScreenWidth + LL_mmWidth(self)/2.0, (LL_mmHeight(self)*line)+(LL_mmHeight(self)/2.0));
    //左边作为结束
   _endPoint = CGPointMake(-LL_mmWidth(self)/2.0, (LL_mmHeight(self)*line)+(LL_mmHeight(self)/2.0));
//    NSLog(@"startPoint=%@,endPoint=%@",NSStringFromCGPoint(_startPoint),NSStringFromCGPoint(_endPoint));
    //回调更新line字典中的状态
    if (self.delegete && [self.delegete respondsToSelector:@selector(startAnimation:)]) {
        [self.delegete startAnimation:self];
    }
    NSArray <NSValue *>*array = @[[NSValue valueWithCGPoint:_startPoint],[NSValue valueWithCGPoint:_endPoint]];
    
    UIBezierPath *path = [self creatPathPoints:array];
    CAAnimation *animation = [self creatAnimationPath:path];
    //开始动画
    [self.layer addAnimation:animation forKey:@"LLAnimationPosition"];
   //利用系统时钟监听layer属性变化
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getLayerPropertySystemClock)];
     self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    
    
}

//停止动画
-(void)stopAnimation
{
   
    [self.layer removeAllAnimations];
    //停止系统定时器
    if (self.displayLink) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
     self.currentStatus = BarrageLabelStatusIdle;
}

#pragma mark 系统定时器
-(void)getLayerPropertySystemClock
{
    if (self.layer.presentationLayer) {
        
//        CGPoint centPoint = CGPointMake(kScreenWidth/2.0, LL_mmHeight(self)/2.0);
        
        //尾部点
        CGPoint tailPoint = CGPointMake(self.layer.presentationLayer.position.x+LL_mmWidth(self)/2.0, self.layer.presentationLayer.position.y);
        
        //算出起始点
        self.layerOrigin = CGPointMake(self.layer.presentationLayer.position.x-LL_mmWidth(self)/2.0, self.layer.presentationLayer.position.y-LL_mmHeight(self)/2.0);
//        NSLog(@"%@",NSStringFromCGPoint(self.layer.presentationLayer.position));
        if (self.layer.presentationLayer.position.x<_startPoint.x && tailPoint.x > kScreenWidth) {
            //开始进入屏幕了、未完全进入屏幕
            if (self.currentVisibleType != BarrageLabelVisibleTypeStartInScreen) {
                self.currentVisibleType = BarrageLabelVisibleTypeStartInScreen;
            }
//            NSLog(@"Barrage label- come in screen.");
        }else if (tailPoint.x <= kScreenWidth-20  && self.layer.presentationLayer.position.x > _endPoint.x) {
            //尾部进入屏幕了  20确保尾部进入屏幕且中间加点空隙给 后面的label进入
//            NSLog(@"Barrage label- tail in screen.");
            if (self.currentVisibleType != BarrageLabelVisibleTypeTailInScreen) {//加判断确保只执行一次
                 self.currentVisibleType = BarrageLabelVisibleTypeTailInScreen;
            }
           
        }else if (self.layer.presentationLayer.position.x <= _endPoint.x) {
            //尾部离开屏幕了->结束
//            NSLog(@"Barrage label- leave screen.");
            if (self.currentVisibleType != BarrageLabelVisibleTypeTailLeaveScreen) {
                self.currentVisibleType = BarrageLabelVisibleTypeTailLeaveScreen;
            }
            
        }
    }
}



#pragma mark CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animationDidStartLabel");
    self.displayLink.paused = NO;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    NSLog(@"animationDidStopLabel");
    [self stopAnimation];
    self.currentStatus = BarrageLabelStatusIdle;
}





#pragma mark 其它
-(UIBezierPath *)creatPathPoints:(NSArray <NSValue *>*)pointValues
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    for (int i = 0; i<pointValues.count; i++) {
        if (i==0) {
            //起点
            [path moveToPoint:pointValues[i].CGPointValue];
        }else{
            //连线
            [path addLineToPoint:pointValues[i].CGPointValue];
        }
    }
    
    
//    [path closePath];//闭合线
    //[path stroke];//Draws line 根据坐标点将线画出来
    //[path fill];//颜色填充
    return path;
}

-(CAKeyframeAnimation *)creatAnimationPath:(UIBezierPath *)path
{
    //添加动画
    CAKeyframeAnimation * animation;
    animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = 8.0;
    animation.repeatCount=0;
    // 结束保持最后状态
    //    animation.fillMode = kCAFillModeForwards;
    //线性
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    //动画执行完不移除和fillmode都要设置
    //    [animation setRemovedOnCompletion:NO];
    return animation;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
