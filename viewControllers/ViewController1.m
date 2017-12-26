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
    [self.navigationController pushViewController:webVC animated:YES];
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
        _HeaderScrollView = [[baseScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
        _HeaderScrollView.backgroundColor = [UIColor greenColor];
//        _HeaderScrollView.delegate = self;
        _HeaderScrollView.contentSize = CGSizeMake(screenWidth*2, 0);
    }
    return _HeaderScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setleftBarItem:@"back"];
    [self.view addSubview:self.HeaderScrollView];
    NSLog(@"%f\n%f\n%f",NavgationHeight,statusBarHeight,tabBarHeight);
    
//    for (int i = 0; i<9999999; i++) {
//        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123"]];
//        imageView.frame = CGRectMake(0, 0, 100, 100);
//
//    }
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
