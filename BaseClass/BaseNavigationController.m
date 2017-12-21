//
//  BaseNavigationController.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    //去掉UINavigationBar的阴影
    
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    navBar.tintColor = [UIColor greenColor];
    [navBar setBarTintColor:[UIColor redColor]];
    
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor greenColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:18]
                                     }];
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:15]
                                      } forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
//    
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [super popViewControllerAnimated:animated];
    return nil;
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
