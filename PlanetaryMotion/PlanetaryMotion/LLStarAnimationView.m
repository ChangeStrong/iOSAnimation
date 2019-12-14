//
//  LLStarAnimationView.m
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import "LLStarAnimationView.h"
#import "LLAnimationItem.h"
#import "LLMyHeader.h"
#import "UIView+Helper.h"
#import "CommonUse.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kSelfWeak __weak typeof(self) weakSelf = self

@interface LLStarAnimationView()<CAAnimationDelegate>
@property(nonatomic, strong) NSMutableArray <NSValue *> *aLinepoints;
@property(nonatomic, strong) NSMutableArray <NSValue *> *bLinepoints;
@property(nonatomic, strong) NSMutableArray <NSValue *> *cLinepoints;
@property(nonatomic, strong) NSMutableArray <LLAnimationItem *> *items;
@property(nonatomic, strong) LLAnimationItem *centerItem;
@end

@implementation LLStarAnimationView{
    CGPoint _aPoint;
    CGPoint _bPoint;
    CGPoint _cPoint;
    CGPoint _centerPoint;
    //等边三角形的边宽
    CGFloat _triangleWidth;
    //每个星球默认的宽
    CGFloat _starWidth;
    CGFloat _startHeight;
    
    //
    CGFloat _radius;//三角形组成的圆半径
    
}


-(NSMutableArray <LLAnimationItem *> *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

-(NSMutableArray <NSValue *> *)aLinepoints
{
    if (!_aLinepoints) {
          //默认A、C、B顺序
        _aLinepoints = [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:_aPoint],[NSValue valueWithCGPoint:_cPoint],[NSValue valueWithCGPoint:_bPoint]]];
    }
    return _aLinepoints;
}

-(NSMutableArray <NSValue *> *)bLinepoints
{
    if (!_bLinepoints) {
         //默认C、B、A顺序
        _bLinepoints = [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:_cPoint],[NSValue valueWithCGPoint:_bPoint],[NSValue valueWithCGPoint:_aPoint]]];
    }
    return _bLinepoints;
}

-(NSMutableArray <NSValue *>*)cLinepoints
{
    if (!_cLinepoints) {
         //默认B、A、C顺序
        _cLinepoints = [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:_bPoint],[NSValue valueWithCGPoint:_aPoint],[NSValue valueWithCGPoint:_cPoint]]];
    }
    return _cLinepoints;
}

-(instancetype)initWithFrame:(CGRect)frame starWidth:(CGFloat)starWidth
{
    if (self = [super initWithFrame:frame]) {
    
        _starWidth = starWidth;
        _startHeight = starWidth+20;//20留给下面标题

         _radius = (LL_mmWidth(self)-starWidth-20)/2.0;//左右各留10空隙
        _triangleWidth = 2*_radius*cos(DEGREES_TO_RADIANS(30));
        //给左右两边各留20dp 并且item中心点两边各有一半不属于三角形
//        _triangleWidth = LL_mmWidth(self)-40-(_starWidth/2.0)*2;
        //三角形中心点和整个view中心点
        _centerPoint = CGPointMake(LL_mmWidth(self)/2.0, LL_mmHeight(self)/2.0);
       
        _aPoint = CGPointMake(_centerPoint.x, _centerPoint.y-(_triangleWidth/2.0)*cos(DEGREES_TO_RADIANS(30)));
        _bPoint = CGPointMake(_centerPoint.x-_triangleWidth/2.0, _centerPoint.y+_triangleWidth/2.0*cos(DEGREES_TO_RADIANS(30)));
        
        _cPoint = CGPointMake(_centerPoint.x+_triangleWidth/2.0, _centerPoint.y+_triangleWidth/2.0*cos(DEGREES_TO_RADIANS(30)));
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickGesture:)];
        [self addGestureRecognizer:tapGesture];
        
        [self createUI];
    }
    return self;
}

#pragma mark UI
-(void)createUI
{
    //中心按钮
    _centerItem =[[[NSBundle mainBundle] loadNibNamed:@"LLAnimationItem" owner:self options:nil] firstObject];
    _centerItem.itemType = TriangleTypeCenter;
    _centerItem.bounds= CGRectMake(0, 0, _starWidth, _starWidth+20);
    _centerItem.center = _centerPoint;
    [_centerItem.headerImageView addcornerRadius:_starWidth/2.0];
    _centerItem.headerImageView.image = [UIImage imageNamed:@"sun"];
    _centerItem.nameLabel.text = [LLAnimationItem itemNames][_centerItem.itemType];
    _centerItem.alpha = 0;
    [self addSubview:_centerItem];
    NSArray *images = @[@"star1",@"star2",@"star3"];
   //添加三角形三个顶点Item
    for (int i = 0; i<self.aLinepoints.count; i++) {
        LLAnimationItem *item =[[[NSBundle mainBundle] loadNibNamed:@"LLAnimationItem" owner:self options:nil] firstObject];
        item.itemType = (TriangleType)i;
        item.bounds= CGRectMake(0, 0, _starWidth, _starWidth+20);
        item.center = self.aLinepoints[i].CGPointValue;
        [item.headerImageView addcornerRadius:_starWidth/2.0];
        item.headerImageView.image = [UIImage imageNamed:images[i]];
        item.nameLabel.text = [LLAnimationItem itemNames][i];
        item.alpha = 0;
        [self addSubview:item];
        [self.items addObject:item];
        
    }
   
}

#pragma mark 接口
//开始动画
-(void)startAnimation
{
   
   
    kSelfWeak;
//   __block NSArray *array = @[self.aLinepoints,self.bLinepoints,self.cLinepoints];
    __block NSArray *startAngles = @[@(180+90),@(90+60),@(30)];
    [self.items enumerateObjectsUsingBlock:^(LLAnimationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        UIBezierPath *path = [weakSelf creatPathPoints:array[idx]];//三角形路线
        NSNumber *pointNumber = startAngles[idx];
        UIBezierPath *ciclePath = [weakSelf drawCiclreStartAngle:DEGREES_TO_RADIANS([pointNumber floatValue])];
        CAAnimation *animation = [weakSelf creatAnimationPath:ciclePath];
//        obj.layer.backgroundColor = UIColorRGB(20, 240, 223).CGColor;
        //开始动画
        [obj.layer addAnimation:animation forKey:@"LLAnimationPosition"];
    }];
    
    [self startItemAlphaAnimation:[self.items firstObject]];
    
}

//开启透明度动画
-(void)startItemAlphaAnimation:(LLAnimationItem *)item
{
    item.alpha = 0;
    kSelfWeak;
    [UIView animateWithDuration:3.0 animations:^{
        item.alpha = 1;
    } completion:^(BOOL finished) {
        NSUInteger indx = [weakSelf.items indexOfObject:item];
        indx++;
        if (indx < weakSelf.items.count) {
            [weakSelf startItemAlphaAnimation:weakSelf.items[indx]];
        }else{
            //显示中间星球入场动画
            NSArray *points = @[[NSValue valueWithCGPoint:CGPointMake(LL_mmWidth(self)/2.0,LL_mmHeight(self))],[NSValue valueWithCGPoint:_centerItem.center]];
            UIBezierPath *ciclePath = [self creatPathPoints:points];
            CAAnimation *animation = [weakSelf cgreateGroupAnimation:ciclePath];
            [_centerItem.layer addAnimation:animation forKey:@"LLAnimationGroup"];
            _centerItem.alpha = 1.0;
        }
    }];
}

//停止动画
-(void)stopAnimation
{
    [_centerItem.layer removeAllAnimations];
    [self.items enumerateObjectsUsingBlock:^(LLAnimationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.layer removeAllAnimations];
    }];
}

//暂停 layer 层的动画
- (void)pauseAnimation
{
    [self.items enumerateObjectsUsingBlock:^(LLAnimationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [CommonUse pauseLayer:obj.layer];
    }];
//    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    layer.speed = 0.0;
//    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeAnimation
{
    [self.items enumerateObjectsUsingBlock:^(LLAnimationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [CommonUse resumeLayer:obj.layer];
    }];
//    CFTimeInterval pausedTime = [layer timeOffset];
//    layer.speed = 1.0;
//    layer.timeOffset = 0.0;
//    layer.beginTime = 0.0;
//    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    layer.beginTime = timeSincePause;
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

#pragma mark GestureRecognizer
-(void)tapClickGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint locationInView = [tapGesture locationInView:self];
    
    [self.items enumerateObjectsUsingBlock:^(LLAnimationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         CALayer *layer1=[[obj.layer presentationLayer] hitTest:locationInView];
        if (layer1) {
            NSLog(@"cliek item is %@",[LLAnimationItem itemNames][obj.itemType]);
        }
    }];
   
    
    
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

//环形环绕路径
-(UIBezierPath *)drawCiclreStartAngle:(CGFloat)startAngel
{
    UIBezierPath *ciclrePath = [UIBezierPath bezierPath];
    [ciclrePath addArcWithCenter:_centerPoint radius:_radius startAngle:startAngel endAngle:startAngel+360*5 clockwise:YES];
    return ciclrePath;
}

-(CAKeyframeAnimation *)creatAnimationPath:(UIBezierPath *)path
{
    //添加动画
    CAKeyframeAnimation * animation;
    animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = 8000.0;
    animation.repeatCount=1;
    // 结束保持最后状态
    //    animation.fillMode = kCAFillModeForwards;
    //线性
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    //动画执行完不移除和fillmode都要设置
    //    [animation setRemovedOnCompletion:NO];
    return animation;
}

-(CAAnimationGroup *)cgreateGroupAnimation:(UIBezierPath *)path
{
     CAAnimationGroup *group = [CAAnimationGroup animation];
    
    //基础动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
//    animation.fromValue = @(0.2);
//    animation.toValue = @(1.0);
    animation.values = @[@(0.2),@(3.0),@(1.0)];
    animation.duration = 2.0;
    animation.repeatCount = 0;
    
    CABasicAnimation *basicAni = [CABasicAnimation animation];
    basicAni.keyPath = @"transform.rotation.z";
    basicAni.fromValue = @(0);
    basicAni.toValue = @(M_PI*2);
    basicAni.duration = 2.0;
    basicAni.repeatCount = 0;
    
    //添加动画
    CAKeyframeAnimation * move;
    move=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.path = path.CGPath;
    move.duration = 2.0;
    move.repeatCount=0;
    
    [group setAnimations:@[animation,basicAni,move]];
    group.repeatCount = 0;
    group.duration = 2.0;//子动画内的时间必须保存一致否则动画效果不流畅
    group.fillMode = kCAFillModeForwards;//动画加入layer就开始动画状态
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.removedOnCompletion = NO;
    
    return group;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
