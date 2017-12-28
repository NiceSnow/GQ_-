//
//  GQCrashHandler.h
//  GQ_****
//
//  Created by Madodg on 2017/12/20.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQCrashHandler : NSObject

/**
 注册崩溃
 */
+ (void)installExceptionHandler;
@end
