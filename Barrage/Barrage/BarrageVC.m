//
//  BarrageVC.m
//  BigBig
//
//  Created by gleeeli on 2018/5/5.
//  Copyright © 2018年 WaYou. All rights reserved.
//

#import "BarrageVC.h"
#import "BarrageLabel.h"
#import "BarrageLine.h"
#define BBDefaultHeder @"icon_default_heade"

@interface BarrageVC ()<BarrageLabelProtocol>
@property(nonatomic, strong) NSMutableArray <BarrageLabel *>* totalLabels;
@property(nonatomic, strong) NSMutableArray<BarrageLabel *>* currentUsingLabels;
@property(nonatomic, strong) NSMutableArray<BarrageLabel *>* currentIdleLabels;
@property(nonatomic, strong) NSMutableArray <NSMutableAttributedString *>* textQueue;

@property(nonatomic, strong) NSMutableDictionary <NSNumber *, BarrageLine*>*barrageLineDic;

@property(nonatomic, strong) NSTimer *barrageTimer;

@end

@implementation BarrageVC

-(NSMutableArray <BarrageLabel *>*)totalLabels
{
    if (!_totalLabels) {
        _totalLabels = [[NSMutableArray alloc]init];
    }
   return  _totalLabels;
}

-(NSMutableArray <BarrageLabel *>*)currentUsingLabels
{
    if (!_currentUsingLabels) {
        _currentUsingLabels = [[NSMutableArray alloc]init];
        [self.totalLabels enumerateObjectsUsingBlock:^(BarrageLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.currentStatus == BarrageLabelStatusUsing) {
                [_currentUsingLabels addObject:obj];
            }
        }];
       
    }
    
    return  _currentUsingLabels;
}

-(NSMutableArray <BarrageLabel *>*)currentIdleLabels
{
    if (!_currentIdleLabels) {
        _currentIdleLabels = [NSMutableArray new];
    }
    NSMutableSet <BarrageLabel *>*totalSet = [NSMutableSet setWithArray:self.totalLabels];
    NSMutableSet <BarrageLabel *>*usingSet = [NSMutableSet setWithArray:self.currentUsingLabels];
    //取差积
    [totalSet minusSet:usingSet];
    [_currentIdleLabels setArray:totalSet.allObjects];
    
    return _currentIdleLabels;
}

-(NSMutableArray <NSMutableAttributedString *>*)textQueue
{
    if (!_textQueue) {
        _textQueue = [[NSMutableArray alloc]init];
    }
    return  _textQueue;
}

-(NSMutableDictionary <NSNumber *, BarrageLine*>*)barrageLineDic
{
    if (!_barrageLineDic) {
        _barrageLineDic = [NSMutableDictionary dictionary];
    }
    return _barrageLineDic;
}


//获取空闲中的行 没有返回-1
-(int)getIdelLine
{
    __block int idleLine = -1;
    [self.barrageLineDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, BarrageLine * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.currentStatus == BarrageLineStatusIdle) {
            idleLine = (int)obj.currentLine;
            *stop = YES;
        }
    }];
    return idleLine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barrageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showBarrageTimerClick) userInfo:nil repeats:YES];
    [self.barrageTimer setFireDate:[NSDate distantFuture]];
    //添加点击每个弹幕的手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    [self initAll];
//    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isRuning) {
        [self startBarrage];
    }
}

-(void)initAll
{
    _isRuning = YES;//默认弹幕是开启的
    //默认使用三行弹幕
    for (int i=0; i < 3; i++) {
        BarrageLine *line = [[BarrageLine alloc]init];
        line.currentLine = i;
        line.currentStatus = BarrageLineStatusIdle;//默认空闲
        [self.barrageLineDic setObject:line forKey:@(i)];
    }
    
}

#pragma mark UI
//添加一条弹幕
-(void)addABarrageUI
{
    if (self.textQueue.count == 0) {
        //没有足够的文字了--不需要显示
        NSLog(@"Barrage- not enough text.!");
        //停掉定时器
        [self.barrageTimer setFireDate:[NSDate distantPast]];
        return;
    }
    int idleLine = [self getIdelLine];
    if (idleLine == -1) {
        //没有空闲的行 ----进行等待
        NSLog(@"Barrage- no enough idle line.!");
        return;
    }
    NSLog(@"Barrage- will add a barrage.");
     NSAttributedString *text = [self.textQueue firstObject];
    BarrageLabel *label;
    //计算文字的宽
    CGSize size0 = [self calculationTextSize:text.string cgSize:CGSizeMake(CGFLOAT_MAX, 30) font:16.0];//206.28
    CGFloat width =size0.width+20*2;//20是图片的宽
        if (self.currentIdleLabels.count >0) {
            //有空闲缓存的label直接拿来使用
            label = [self.currentIdleLabels firstObject];
            NSLog(@"Barrage- get a cache idle label. count=%lu",self.currentIdleLabels.count);
        }else{
            //没有空闲缓存的label-重新创建
                label = [[BarrageLabel alloc]initWithFrame:CGRectMake(-width, 0, width, 30)];
                [self.view addSubview:label];
                [self.totalLabels addObject:label];
        }
    label.frame = CGRectMake(-width, 0, width, 30);//更新尺寸宽
    label.attributedText = text;
//    label.backgroundColor = [UIColor greenColor];
    label.delegete = self;
    [self.textQueue removeObjectAtIndex:0];
    //开始动画
    [label startAnimationAtLine:idleLine];
}

#pragma mark 数据
-(void)loadData
{
    for (int i =0 ; i< 10; i++) {
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        
        //添加图片
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        UIImage *image = [UIImage imageNamed:BBDefaultHeder];
        attchment.image = image;
        // 设置图片大小
        attchment.bounds = CGRectMake(0, 0, 20, 20);
        NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchment];
        [text appendAttributedString:stringImage];
//        [text insertAttributedString:attachment atIndex:2];
        
        NSString *contentString = @"hello i come frome china.";
      NSMutableAttributedString  *stingAttri = [[NSMutableAttributedString alloc]initWithString:contentString];
        //设置这一行向上移动5
        [stingAttri addAttribute:NSBaselineOffsetAttributeName value:@(5) range:NSMakeRange(0, contentString.length)];
     
        [text appendAttributedString:stingAttri];
        
        //再添加一个图片
        [text appendAttributedString:stringImage];
        
       //加入队列
        [self.textQueue addObject:text];
    }
    //开启弹幕添加定时器
    [self.barrageTimer setFireDate:[NSDate distantPast]];
    
}

#pragma mark 接口
-(void)stopBarrage
{
    _isRuning = NO;
    [self.barrageTimer setFireDate:[NSDate distantFuture]];
}

-(void)startBarrage
{
     _isRuning = YES;
    [self loadData];
}

#pragma mark 事件/定时器


-(void)showBarrageTimerClick
{
    //添加一条弹幕
    [self addABarrageUI];
}

#pragma mark BarrageLabelProtocol
-(void)startAnimation:(BarrageLabel *)label
{
    //开始动画了
    if (label) {
        BarrageLine *line = [self.barrageLineDic objectForKey:@(label.currentLine)];
        //改变状态
        line.currentStatus = BarrageLineStatusBusy;
    }
}
//目前状态发生改变
-(void)stauesDidChange:(BarrageLabel *)label
{
//    NSLog(@"stauesDidChange");
    if (label.currentStatus != BarrageLabelStatusUsing) {
        //此label处于空闲状态
        if ([self.currentUsingLabels containsObject:label]) {
            [self.currentUsingLabels removeObject:label];
        }
        if (self.currentIdleLabels.count > 20) {
            //开始清除多余的缓存label
        }
    }else{
        //此label正在被使用
        if (![self.currentUsingLabels containsObject:label]) {
            [self.currentUsingLabels addObject:label];
            NSLog(@"Barrage- current using label count is =%lu",self.currentUsingLabels.count);
            
        }
    }
   
}
//可见性发生改变
-(void)visibleDidChange:(BarrageLabel *)label
{
//    NSLog(@"visibleDidChange");
    if (label.currentVisibleType == BarrageLabelVisibleTypeTailInScreen) {
        //可以添加标记多了一个空闲位置
        BarrageLine *line = [self.barrageLineDic objectForKey:@(label.currentLine)];
        line.currentStatus = BarrageLineStatusIdle;
        if (self.isRuning) {
            //添加一个新的弹幕进来了
            [self addABarrageUI];
        }
        
    }
}

#pragma mark GestureRecognizer
-(void)tapClickGesture:(UITapGestureRecognizer *)tapGesture
{
  __block  CGPoint locationInViewPoint = [tapGesture locationInView:self.view];
 __block   BOOL isClickBarrageLabel = NO;
    [self.totalLabels enumerateObjectsUsingBlock:^(BarrageLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CALayer *layer1=[[obj.layer presentationLayer] hitTest:locationInViewPoint];
        if (layer1) {
            isClickBarrageLabel = YES;
            NSLog(@"click label.=%@ position=%@", NSStringFromCGRect(layer1.bounds),NSStringFromCGPoint(layer1.position));
            CGSize layerSize = layer1.bounds.size;
            CGPoint origin = CGPointMake(layer1.position.x-layerSize.width/2.0, layer1.position.y-layerSize.height/2.0);
            CGRect layerFrame;
            //如果此label长度大于40 则点击左边40的区域算点击了头像
            layerFrame.size = CGSizeMake(layerSize.width<40?layerSize.width:40, layerSize.height);
            layerFrame.origin=origin;
            if (CGRectContainsPoint(layerFrame, locationInViewPoint)) {
                NSLog(@"点击的是头像");
            }else{
                NSLog(@"点击的是头像右边");
            }
            *stop = YES;
        }
    }];
    //
    if (isClickBarrageLabel == NO) {
        //弹出弹幕
        NSLog(@" click keyboad.");
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//计算文本的宽高
-(CGSize)calculationTextSize:(NSString *)textString cgSize:(CGSize)size font:(CGFloat)font
{
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    contentParagraphStyle.lineSpacing = 10.f;
    //计算内容size
    NSDictionary *contentAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                                       NSParagraphStyleAttributeName:contentParagraphStyle,
                                       NSKernAttributeName:@(1)};
    
    
    CGSize contentSize = [textString boundingRectWithSize:size
                                                  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:contentAttribute
                                                  context:nil].size;
    
    return contentSize;
    
    
    
}

//添加段落格式
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        paragraphStyle.maximumLineHeight = 30;
//        [stingAttri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 4)];
//设置文字颜色
//        [stingAttri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
//        [stingAttri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 4)];

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
