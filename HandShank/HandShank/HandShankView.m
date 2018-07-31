//
//  HandShankView.m
//  RongTianShi
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 youshixiu. All rights reserved.
//

#import "HandShankView.h"
#import "LLMyHeader.h"
#import "LoogPressButton.h"
#define PI 3.14159265358979323846
@interface HandShankView()
@property(nonatomic, strong) NSArray *handShankArrows;
@end

@implementation HandShankView
{
    UIView *_centerView;
    CGPoint _handShankOriginCenter;
    CGPoint _startPoint;
    CGPoint _lasrtPoint;
    int bigRadius;
    int smallRadius;
    HandShankDirection _currentDirection;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentDirection = HandShankDirectionUnknow;
        [self createCenterCircle:frame];
    }
    
    return self;
}

-(NSArray *)handShankArrows
{
    if (!_handShankArrows) {
        _handShankArrows = @[@"Arrow_up",@"Arrow_down",@"Arrow_left",@"Arrow_right"];
    }
    return _handShankArrows;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _centerView.frame = CGRectMake((CGRectGetWidth(frame)-CGRectGetWidth(frame)/3.0)/2.0, (CGRectGetHeight(frame)-CGRectGetHeight(frame)/3.0)/2.0, CGRectGetWidth(frame)/3.0, CGRectGetHeight(frame)/3.0);
    NSLog(@"%f %f",_centerView.frame.size.width,_centerView.frame.size.height);
    _handShankOriginCenter = _centerView.center;
    smallRadius = (CGRectGetWidth(frame)/3.0)/2.0;
    _centerView.layer.cornerRadius = smallRadius;
    [self setNeedsDisplay];
}

-(void)createCenterCircle:(CGRect)selfFrame
{
    //中间摇杆圆
    _centerView = [[UIView alloc]init];
    _centerView.frame = CGRectMake((CGRectGetWidth(selfFrame)-CGRectGetWidth(selfFrame)/3.0)/2.0, (CGRectGetHeight(selfFrame)-CGRectGetHeight(selfFrame)/3.0)/2.0, CGRectGetWidth(selfFrame)/3.0, CGRectGetHeight(selfFrame)/3.0);
    _handShankOriginCenter = _centerView.center;
    smallRadius = (CGRectGetWidth(selfFrame)/3.0)/2.0;
    _centerView.layer.cornerRadius = smallRadius;
    _centerView.layer.masksToBounds = YES;
    _centerView.alpha = 0.8;
    
    _centerView.backgroundColor = [UIColor colorWithRed:143/255.0 green:190/255.0 blue:81/255.0 alpha:1.0];
    [self addSubview:_centerView];
    //四个方向标志
    float interval = (CGRectGetHeight(selfFrame)-LL_mmHeight(_centerView))/4.0;
    for (int i = 0; i<4; i++) {
        UIImageView *arrow = [self InsertImageView:self cgrect:CGRectMake(0, 0, 20*FIT_WIDTH, 12*FIT_WIDTH) image:[UIImage imageNamed:self.handShankArrows[i]]];
//        InsertImageView(self, CGRectMake(0, 0, 20*FIT_WIDTH, 12*FIT_WIDTH), [UIImage imageNamed:self.handShankArrows[i]]);
//        arrow.hidden = YES;//注意隐藏箭头了
        switch (i) {
            case 0:
            {
                //上
                 arrow.center = CGPointMake(CGRectGetWidth(selfFrame)/2.0, interval);
                
            }
                break;
            case 1:
                //下
                arrow.center = CGPointMake(CGRectGetWidth(selfFrame)/2.0, CGRectGetHeight(selfFrame)-interval);
                break;
            case 2:
                //左
                arrow.frame = CGRectMake(0, 0, 12*FIT_WIDTH, 20*FIT_WIDTH);
                arrow.center = CGPointMake(interval, CGRectGetHeight(selfFrame)/2.0);
                break;
            case 3:
                //右
                arrow.frame = CGRectMake(0, 0, 12*FIT_WIDTH, 20*FIT_WIDTH);
                arrow.center = CGPointMake(CGRectGetWidth(selfFrame)-interval, CGRectGetHeight(selfFrame)/2.0);
                break;
                
            default:
                break;
        }
        
        
        
    }
   
    //摇杆添加移动手势
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pangestureAction:)];
    [_centerView addGestureRecognizer:pangesture];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//     CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,143/255.0,190/255.0,81/255.0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 2.0);//线的宽度
    bigRadius = LL_mmWidth(self)/2.0-4;
    CGContextAddArc(context, LL_mmWidth(self)/2.0, LL_mmHeight(self)/2.0, bigRadius, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}



//按着不动的状态
-(void)pangestureAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    [recognizer setTranslation:CGPointZero inView:self];
    CGPoint movingPosition = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    
    int rangeRadius = bigRadius - smallRadius;
    if ([self isInciclelPoint:movingPosition andR:rangeRadius centrePoing:_handShankOriginCenter]) {
        _lasrtPoint = movingPosition;
        _centerView.center = _lasrtPoint;
        
        if (_lasrtPoint.y < _startPoint.y && (fabsf((float)(_lasrtPoint.y - _startPoint.y)) > fabs(_lasrtPoint.x - _startPoint.x))) {
            //上
            if (_currentDirection == HandShankDirectionUnknow) {
                NSLog(@"开始上");
                _currentDirection = HandShankDirectionStartTop;
            }else{
                NSLog(@"上");
                _currentDirection = HandShankDirectionTop;
            }
           
        }else if (_lasrtPoint.y > _startPoint.y && (fabsf((float)(_lasrtPoint.y - _startPoint.y)) > fabs(_lasrtPoint.x - _startPoint.x)))
        {
            if (_currentDirection == HandShankDirectionUnknow) {
                NSLog(@"开始下");
                _currentDirection = HandShankDirectionStartDown;
            }else{
                NSLog(@"下");
                _currentDirection = HandShankDirectionDown;
            }
            
        }else if (_lasrtPoint.x >_startPoint.x && (fabsf((float)(_lasrtPoint.x -_startPoint.x)) > fabsf((float)(_lasrtPoint.y -_lasrtPoint.y))) )
        {
            if (_currentDirection == HandShankDirectionUnknow) {
                NSLog(@"开始右");
                 _currentDirection = HandShankDirectionStartRight;
            }else{
                NSLog(@"右");
                _currentDirection = HandShankDirectionRight;
            }
            
        }else if (_lasrtPoint.x <_startPoint.x && (fabsf((float)(_lasrtPoint.x -_startPoint.x)) > fabsf((float)(_lasrtPoint.y -_lasrtPoint.y))) )
        {
            if (_currentDirection == HandShankDirectionUnknow) {
                NSLog(@"开始左");
                _currentDirection = HandShankDirectionStartLeft;
            }else{
                NSLog(@"左");
                _currentDirection = HandShankDirectionLeft;
            }
            
        }
        
        if (self.delegete && [self.delegete respondsToSelector:@selector(handShankDirectionDidChange:)]) {
            [self.delegete handShankDirectionDidChange:_currentDirection];
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        NSLog(@"结束");
        _startPoint = _handShankOriginCenter;
        [UIView animateWithDuration:0.5 animations:^{
            _centerView.center = _handShankOriginCenter;
        }];
        _currentDirection = HandShankDirectionUnknow;
        
        
        if (self.delegete && [self.delegete respondsToSelector:@selector(handShankDirectionDidEnd)]) {
            [self.delegete handShankDirectionDidEnd];
        }
    }
   
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
    int rangeRadius = bigRadius - smallRadius;
    if ([self isInciclelPoint:point andR:rangeRadius centrePoing:_handShankOriginCenter]) {
        _startPoint = point;
        _centerView.center = point;
        _currentDirection = HandShankDirectionUnknow;
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint movingPosition = [touch locationInView:self];
//    NSLog(@"%f %f",movingPosition.x,movingPosition.y);
//    int rangeRadius = bigRadius - smallRadius;
//    if ([self isInciclelPoint:movingPosition andR:rangeRadius centrePoing:_handShankOriginCenter]) {
//        _lasrtPoint = movingPosition;
//        _centerView.center = _lasrtPoint;
//        
//        if (_lasrtPoint.y < _startPoint.y && (fabsf(_lasrtPoint.y - _startPoint.y) > fabs(_lasrtPoint.x - _startPoint.x))) {
//            //上
//            NSLog(@"上");
//        }else if (_lasrtPoint.y > _startPoint.y && (fabsf(_lasrtPoint.y - _startPoint.y) > fabs(_lasrtPoint.x - _startPoint.x)))
//        {
//            NSLog(@"下");
//        }else if (_lasrtPoint.x >_startPoint.x && (fabsf(_lasrtPoint.x -_startPoint.x) > fabsf(_lasrtPoint.y -_lasrtPoint.y)) )
//        {
//            NSLog(@"右");
//        }else if (_lasrtPoint.x <_startPoint.x && (fabsf(_lasrtPoint.x -_startPoint.x) > fabsf(_lasrtPoint.y -_lasrtPoint.y)) )
//        {
//            NSLog(@"左");
//        }
//    }
    
}

- (void)touchesCancelled:( NSSet<UITouch *> *)touches withEvent:( UIEvent *)event
{
    //回到原位
//    CGPoint centerPoint = CGPointMake(LL_mmWidth(self)/2.0, LL_mmHeight(self)/2.0);
//     _startPoint = _handShankOriginCenter;
//    [UIView animateWithDuration:1.0 animations:^{
        NSLog(@"取消");
//        _centerView.center = centerPoint;
//    }];
    
   
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
    [UIView animateWithDuration:1.0 animations:^{
        NSLog(@"停");
        _centerView.center = _handShankOriginCenter;
    }];
    _startPoint = _handShankOriginCenter;
}

-(BOOL)isInciclelPoint:(CGPoint)point andR:(CGFloat)R centrePoing:(CGPoint)heartPoint
{
    
    CGFloat X = point.x;
    CGFloat Y = point.y;
    CGFloat X2= (X -heartPoint.x)*(X - heartPoint.x);
    CGFloat Y2 = (Y - heartPoint.y)*(Y - heartPoint.y);
    CGFloat R2 = R * R;
    
    
    if ((X2 + Y2) < R2) {
        return YES;
    }else{
        
        return NO;
    }
    
}

#pragma mark 其它
-(UIImageView *)InsertImageView:(UIView *)view cgrect:(CGRect)rect image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    
    if (image)
    {
        [imageView setImage:image];
    }
    
    imageView.userInteractionEnabled = YES;
    
    if (view)
    {
        [view addSubview:imageView];
    }
    
    return imageView;
}


@end
