//
//  AppDelegate.m
//  GQ_****
//
//  Created by Madodg on 2017/11/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "AppDelegate.h"
#import "NewFeatureView.h"
#import "myRequest.h"
#import "GQFileManager.h"
#import "BaseHTTPRequest.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()<requestDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    //
    //    keyboardManager.enable = YES; // 控制整个功能是否启用
    //
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    
    [GQLogManager instance].immediately = YES;
    [GQLogManager instance].userID = @"888";
    [GQLogManager instance].userName = @"MDD";
    [GQLogManager instance].phoneNumber = @"13888888888";
    [GQLogManager instance].deviceType = @"iOS";
    [[GQLogManager instance] LogStartWithURL:@"http://000883.ichengyun.net/uploadDemo/uploadZip.php" FileType:@"multipart/form-data" keyInformation:nil];
//    崩溃测试
//    [[GQLogManager instance] BecomeActive];
//    NSArray* arr = @[@"123"];
//    NSLog(@"%@",arr[5]);
    
    [self setRootVC];
    NSDictionary* para = @{
                           @"mobile" : @"15901174558",
                           @"passwd" : @"ma111111",
                           @"userDeviceReqForm" :     @{
                                   @"deviceId" : @"ios_enterprise",
                                   @"manufacturer" : @"Apple",
                                   @"model" : @"x86_64",
                                   @"sysVno" : @"1.4.0"
                           },
                           @"ver" : @"1.4.0",
                           };
//    block回调
    [myRequest LoginRequest:@"https://tst-cashloan-fe.gqichina.net/user/login" parameters:para Succeed:^(id obj) {
        
    } failed:^(id obj) {
        
    }];
    
//    delegate回调
    myRequest* request = [[myRequest alloc]init];
    request.delegate = self;
    [request DelegateRequest:@"https://tst-cashloan-fe.gqichina.net/user/login" parameters:para RequestType:LoginURL];
    
    myRequest* request2 = [[myRequest alloc]init];
    request2.delegate = self;
    [request2 DelegateRequest2:@"https://tst-cashloan-fe.gqichina.net/user/login" parameters:para RequestType:@"secondRequest"];

    // Override point for customization after application launch.
    return YES;
}

-(void)onSuccessWithData:(id)data RequestType:(NSString *)type{
    if ([type isEqualToString:LoginURL]) {
        NSLog(@"第一个回调成功");
    }
    if ([type isEqualToString:@"secondRequest"]) {
        NSLog(@"第二个回调成功");
    }
}

-(void)onFailedWithData:(id)data RequestType:(NSString *)type{
    
}

-(void)onServiceFailedWithData:(id)data RequestType:(NSString *)type{
    
}

-(void)setRootVC{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController * tabbarController  = [storyboard instantiateViewControllerWithIdentifier:@"TABBARCONTRALL"];
    if (showNewFeature) {
        NewFeatureView * newFeature = [[NewFeatureView alloc]init];
        newFeature.myTabbarController = tabbarController;
        self.window.rootViewController = newFeature;
    }else{
        self.window.rootViewController = tabbarController;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    UITabBarController * tabVC  = (UITabBarController *)self.window.rootViewController;
    UINavigationController * baseNav = (UINavigationController *)tabVC.selectedViewController;
    [[baseNav.viewControllers[0] view] endEditing:YES];
    [[GQLogManager instance] EnterBackground];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[GQLogManager instance] BecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application; {
    
}     // try to clean up as much memory as possible. next step is to terminate app

- (void)applicationSignificantTimeChange:(UIApplication *)application;{
    
}

@end
