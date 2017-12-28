//
//  UserTool.m
//  GQ_****
//
//  Created by Madodg on 2017/12/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UserTool.h"

static UserTool *instance = nil;

@implementation UserTool
+ (UserTool*)instance;{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BOOL)isLogin:(UIViewController*)vc;{
    if (YES){
        return YES;
    }else{
//        vc为空的时候 返回NO 不进行操作
        NSLog(@"VC 加载登录界面");
        return NO;
    }
}


@end
