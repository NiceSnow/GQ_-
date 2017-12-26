//
//  GQCrashHandler.m
//  GQ_****
//
//  Created by Madodg on 2017/12/20.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "GQCrashHandler.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "GQLogManager.h"

NSString *const kHydCrashModelKey = @"Hyd-crash";

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation GQCrashHandler

//手动记录一个错误信息上报到crash日志服务器
+ (void)manualRecodeErrorWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo
{
    NSException *exception = [NSException exceptionWithName:name reason:reason userInfo:userInfo];
    [[GQCrashHandler defaultManager] recodeHYDCrashErrorWith:exception];
}

void getAnCrashErrorHandler(NSException *exception)
{
    [[GQCrashHandler defaultManager] performSelectorOnMainThread:@selector(recodeHYDCrashErrorWith:) withObject:exception waitUntilDone:YES];
}

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self defaultManager] uploadLastCrashInfo];
    });
}

+ (instancetype)defaultManager {
    static GQCrashHandler *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}

+ (void)installExceptionHandler;{
    NSSetUncaughtExceptionHandler(&getAnCrashErrorHandler);
    signal(SIGABRT, hydSignalHandler);
    signal(SIGILL, hydSignalHandler);
    signal(SIGSEGV, hydSignalHandler);
    signal(SIGFPE, hydSignalHandler);
    signal(SIGBUS, hydSignalHandler);
    signal(SIGPIPE, hydSignalHandler);
    signal(SIGTRAP, hydSignalHandler);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSSetUncaughtExceptionHandler(&getAnCrashErrorHandler);
        signal(SIGABRT, hydSignalHandler);
        signal(SIGILL, hydSignalHandler);
        signal(SIGSEGV, hydSignalHandler);
        signal(SIGFPE, hydSignalHandler);
        signal(SIGBUS, hydSignalHandler);
        signal(SIGPIPE, hydSignalHandler);
        signal(SIGTRAP, hydSignalHandler);
        
    }
    return self;
}

+ (void)fuckingKillApp
{
    NSSetUncaughtExceptionHandler(nil);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    kill(getpid(), SIGKILL);
}


- (void)uploadLastCrashInfo
{
    NSString *crash = [[NSUserDefaults standardUserDefaults] objectForKey:kHydCrashModelKey];
    //    if (StringIsNullOrEmpty(crash)) {
    //        return;
    //    }
    
    NSString *crashLog = [NSString stringWithFormat:@"[%@]", crash];
    //    ApiHttpRequestUtil *requestUtil = [[ApiHttpRequestUtil alloc] init];
    //    NSString *method = NET_TYPE == 2 ? @"/crashLog/sendCrashLog":@"/appcrash/crashLog/sendCrashLog";
    //    [requestUtil callPOSTWithParams:@{@"crashlogs":crashLog} methodName:method serviceType:ServiceTypeCrash success:^(id response, NSURLRequest *request) {
    //        APIURLResponse *urlResonse = (APIURLResponse *)response;
    //        NSDictionary *subDict = urlResonse.content;
    //        if ([subDict intValueForKey:@"rspCode" default:0] == 200) {
    //            WZLogDebug(@"upload crash log success and crashInfo is:%@",crashLog);
    //            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kHydCrashModelKey];
    //        }
    //    } fail:^(id response, NSURLRequest *request) {
    //        WZLogError(@"upload crash log failed and crashInfo is:%@ and response is %@",crashLog, response);
    //    }];
}

- (void)recodeHYDCrashErrorWith:(NSException*)exception
{
    NSString *name = [exception name];
    //统计崩溃时间。
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    //统计设备信息和系统信息
    UIDevice *device = [UIDevice currentDevice];
    NSString *iphone = [[UIDevice currentDevice] machineModelName];
    NSArray *stackSymbol = [exception callStackSymbols];
    
    NSString *stack = @"";
    for (NSString *stackSr in stackSymbol) {
        stack =  [stack stringByAppendingFormat:@"%@\\n",stackSr];
    }
    
    NSString *applicationBundle =   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *applicationVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSMutableArray *mutArray = [NSMutableArray array];
    
    [mutArray addObject:[NSString stringWithFormat:@"\"appBundle\":\"%@\"",applicationBundle]];
    [mutArray addObject:[NSString stringWithFormat:@"\"appVersion\":\"%@\"",applicationVersion]];
    [mutArray addObject:[NSString stringWithFormat:@"\"timeStr\":\"%@\"",time]];
    [mutArray addObject:[NSString stringWithFormat:@"\"deviceModel\":\"%@\"",iphone]];
    [mutArray addObject:[NSString stringWithFormat:@"\"osVersion\":\"%@\"",device.systemVersion]];
    [mutArray addObject:[NSString stringWithFormat:@"\"detail\":\"%@,%@\"",exception.reason,stack]];
    [mutArray addObject:[NSString stringWithFormat:@"\"message\":\"%@\"",exception.reason]];
    [mutArray addObject:[NSString stringWithFormat:@"\"userinfo\":\"%@\"",exception.userInfo?:@""]];
    [mutArray addObject:[NSString stringWithFormat:@"\"crashType\":\"%@\"",name]];
    [mutArray addObject:@"\"appType\":\"hyd\""];
    [mutArray addObject:@"\"osType\":\"ios\""];
    [[GQLogManager instance] SaveCrash:mutArray];
    [GQCrashHandler fuckingKillApp];
}

void hydSignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [GQCrashHandler backtrace];
    [userInfo setObject:callStack?:@[] forKey:UncaughtExceptionHandlerAddressesKey];
    [[[GQCrashHandler alloc] init] performSelectorOnMainThread:@selector(recodeHYDCrashErrorWith:)
                                                     withObject: [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                                                         reason: [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n"@"%@%@",nil),signal, getAppInfo(),callStack]
                                                                  
                                                                                       userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                                                                            forKey:UncaughtExceptionHandlerSignalKey]]waitUntilDone:YES];
}

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App :%@ %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID :\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         @"123"];
    //                         [UIDevice keyChainUUID]];
    return appInfo;
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

@end
