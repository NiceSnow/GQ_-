//
//  UIView+extension.h
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)
- (UIViewController *)ViewController;
//添加阴影
- (void) makeInsetShadow;
- (void) makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha;
- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;
@end
