//
//  BaseTabBarController.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setTintColor:[UIColor orangeColor]];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self buildTabBarItem];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController * nav = (UINavigationController *)viewController;
    return YES;
}

- (void)buildTabBarItem
{
    NSArray * imageArray = @[@"VC1",@"VC2",@"VC3",@"VC4"];
    NSArray * titleArray = @[@"VC1",@"VC2",@"VC3",@"VC4"];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * imageName = imageArray[idx];
        
        UIImage * homenormalImage = [[UIImage imageNamed:imageName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * homeselectImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@SEL",imageName]]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.tabBarItem=[[UITabBarItem alloc]initWithTitle:titleArray[idx] image:homenormalImage selectedImage:homeselectImage];
    }];
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
