//
//  UIControl+extension.h
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
//上传用户行为数据
@interface UIControl (extension)
@property (nonatomic, assign) NSTimeInterval hyd_acceptEventInterval;// 可以用这个给重复点击加间隔
@end
