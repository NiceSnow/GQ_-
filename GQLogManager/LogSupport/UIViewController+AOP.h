//
//  UIViewController+AOP.h
//  demo
//
//  Created by bob smith on 2017/12/25.
//  Copyright © 2017年 bob smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AOP)

@end

@interface UIScrollView (AOP)

@end

@interface UITableView (AOP)

@end

@interface UICollectionView (AOP)

@end

@interface UIControl (AOP)

@property (nonatomic, assign) NSTimeInterval aop_acceptEventInterval;// 可以用这个给重复点击加间隔

@end

@interface UIApplication (AOP)

@end

@interface UIView (viewPath)

- (NSString *)viewPath;

@end

@interface UIGestureRecognizer (sourceView)

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) float startPointX;
@property (nonatomic, assign) float startPointY;

@end
