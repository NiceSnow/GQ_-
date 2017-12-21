//
//  UIViewController+extension.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UIViewController+extension.h"

@implementation UIViewController (extension)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(viewDidLoad), @selector(aop_viewDidLoad));
        swizzleMethod([self class], @selector(viewWillAppear:),@selector(aop_viewWillAppear:));
        swizzleMethod([self class], @selector(viewWillDisappear:),@selector(aop_viewWillDisAppear:));
        swizzleMethod([self class], @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
    });
}

- (void)aop_viewWillAppear:(BOOL)animation
{
    [self aop_viewWillAppear:animation];
}
- (void)aop_viewWillDisAppear:(BOOL)animation
{
    [self aop_viewWillDisAppear:animation];
}
- (void)aop_viewDidAppear:(BOOL)animation
{
    [self aop_viewDidAppear:animation];
    
}

/**
 设置返回按钮
 */

- (void)aop_viewDidLoad
{
    [self aop_viewDidLoad];
    if (VersionNumber >= 11.0) {
        // 针对 11.0 以上的iOS系统进行处理
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        UIImage* image = [UIImage imageNamed:@"back"];
        [backItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        backItem.tintColor = [UIColor clearColor];
        self.navigationItem.backBarButtonItem = backItem;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
        UIImage* image = [UIImage imageNamed:@"back1"];
        backItem.title = @"";
        [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width*1.5, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = backItem;
    }
    
}
@end
