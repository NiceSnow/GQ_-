//
//  ViewController1.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ViewController1.h"
#import "UrlWebViewController.h"

@interface ViewController1 ()
@property(nonatomic,strong) baseScrollView* HeaderScrollView;
@end

@implementation ViewController1
- (IBAction)buttonPress:(id)sender {
    UrlWebViewController* webVC = [[UrlWebViewController alloc]init];
    webVC.urlString = @"https://www.baidu.com";
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.5;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:webVC animated:NO];
}
- (IBAction)crash:(id)sender {
    NSArray* arr = @[@"123"];
    NSLog(@"%@",arr[5]);
}
- (IBAction)switchBtnChange:(id)sender {
    
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    NSLog(@"%f",sender.value);
}

-(baseScrollView *)HeaderScrollView{
    if (!_HeaderScrollView) {
        _HeaderScrollView = [[baseScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, NavgationHeight)];
        _HeaderScrollView.backgroundColor = [UIColor greenColor];
//        _HeaderScrollView.delegate = self;
        _HeaderScrollView.contentSize = CGSizeMake(screenWidth*2, 0);
    }
    return _HeaderScrollView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第一";
    [self setleftBarItem:@"back"];
    [self.view addSubview:self.HeaderScrollView];
    NSLog(@"%f\n%f\n%f",NavgationHeight,statusBarHeight,tabBarHeight);
    runOnMainThread(^{
        
    });
    // Do any additional setup after loading the view from its nib.
}

- (void)back{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
