//
//  GQCrashHandler.h
//  GQ_****
//
//  Created by Madodg on 2017/12/20.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQCrashHandler : NSObject
//手动记录一个错误信息上报到crash日志服务器
+ (void)manualRecodeErrorWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;
+ (void)installExceptionHandler;
@end
