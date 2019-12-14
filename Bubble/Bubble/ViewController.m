//
//  ViewController.m
//  Bubble
//
//  Created by luo luo on 2019/12/14.
//  Copyright © 2019 ChangeStrong. All rights reserved.
//

#import "ViewController.h"
#import "ChatBubbleView.h"

@interface ViewController ()
@property(nonatomic, weak) ChatBubbleView *bubbleView;
@end

@implementation ViewController
- (IBAction)testAction:(UIButton *)sender {
    NSLog(@"testAction");
    self.bubbleView.rowDirection = self.bubbleView.rowDirection==ChatBubbleViewRowDirectionLeft?ChatBubbleViewRowDirectionright:ChatBubbleViewRowDirectionLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ChatBubbleView *bubble = [[ChatBubbleView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:bubble];
    self.bubbleView = bubble;
}


@end
