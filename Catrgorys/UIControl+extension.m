//
//  UIControl+extension.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UIControl+extension.h"
#import <objc/runtime.h>

@interface UIControl()
@property (nonatomic, assign) NSTimeInterval hyd_acceptEventTime;
@end

@implementation UIControl (extension)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";



@end
