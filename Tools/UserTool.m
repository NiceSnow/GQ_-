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

static UserTool* _ToolInstance = nil;

+(instancetype) instance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _ToolInstance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _ToolInstance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [UserTool instance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [UserTool instance] ;
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
