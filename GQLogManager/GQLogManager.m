//
//  GQLogManager.m
//  GQ_****
//
//  Created by Madodg on 2017/12/13.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "GQLogManager.h"
#import "GQFileManager.h"
#import "GQCrashHandler.h"
#import "NSString+extension.h"
#import "LogRequest.h"
#import "NSString+extension.h"
#import "ZipArchive.h"

@interface GQLogManager ()
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
#endif
@end


@implementation GQLogManager

+ (GQLogManager*)instance
{
    static GQLogManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
//        注册崩溃
        [GQCrashHandler installExceptionHandler];
        _userAction = [NSMutableDictionary new];
        _timeline = [NSMutableArray new];
        [_userAction setObject:_timeline forKey:@"timeline"];
        
        _textFieldAction = [NSMutableDictionary new];
        _textFieldActionArray = [NSMutableArray new];
        
        _userID = @"99999999";
        _userName = @"tourists";
        _phoneNumber = @"";
        _deviceType = @"iOS";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}


-(void)cleanDisk{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"cleanDisk" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [_timeline addObject:dic];
    [self WriteToFile];
}

-(void)clearMemory{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"clearMemory" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [_timeline addObject:dic];
    [self WriteToFile];
}
/**
 1.检查时候有之前没被上传的数据 如果有上传 成功后删除文件
 2.创建userAction 并且赋值头信息
 */
- (void)LogStartWithURL:(NSString*)url FileType:(NSString*)type keyInformation:(NSDictionary*)Information;{
//    基础信息设定
    _logServiceUrl = url;
    _fileType = type;
    [_userAction setObject:_userID forKey:@"userID"];
    [_userAction setObject:_userName forKey:@"userName"];
    [_userAction setObject:_phoneNumber forKey:@"phoneNumber"];
    [_userAction setObject:_deviceType forKey:@"deviceType"];
    [_userAction setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [[Information allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_userAction setObject:Information[obj] forKey:obj];
    }];
}

- (void)LogEnd;{
    _userID = @"99999999";
    _userName = @"tourists";
    _phoneNumber = @"";
    _deviceType = @"iOS";
}

- (void)BecomeActive;{
    [self endBackground];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"BecomeActive" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [_timeline addObject:dic];
    [self chackLogFolder];
    [self chackLogZipFolder];
}

- (void)EnterBackground;{
//    只要调用了此函数系统就会允许app的所有线程继续执行，直到任务结束
    [self startBackground];
//    每次进入后台都会保存并覆盖文件 保证数据的完整性 下次AppStart的时候上传成功后清除
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"EnterBackground" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [_timeline addObject:dic];
    [self WriteToFile];
    [self zipFile:_currentLogPath];
    [self sendCurrentZipSynchronous:NO];
    
}

- (void)showVCWithName:(NSString*)name;{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"EnterActivity" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [dic setObject:name forKey:@"name"];
    [_timeline addObject:dic];
}

- (void)ButtonPressWithName:(NSString*)name;{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"Click" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [dic setObject:name forKey:@"name"];
    [_timeline addObject:dic];
}

- (void)GetNotification:(NSDictionary*)message;{
    #pragma need change需要后台配合推送定字段
    [_timeline addObject:@{@"notice":message}];
}

- (void)scrollViewStartDraggingWithName:(NSString*)name :(CGFloat)x :(CGFloat)y{
    _pointX = x;
    _pointY = y;
    _scrollName = name;
}

- (void)scrollViewEndDragging:(CGFloat)x :(CGFloat)y{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"ScrollView" forKey:@"Type"];
    [dic setObject:_scrollName forKey:@"name"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    if (_pointX > x) {
        [dic setObject:@"right" forKey:@"direction"];
        [_timeline addObject:dic];
    }else if (_pointX < x){
        [dic setObject:@"left" forKey:@"direction"];
        [_timeline addObject:dic];
    }
    if (_pointY > y) {
        [dic setObject:@"down" forKey:@"direction"];
        [_timeline addObject:dic];
    }else if (_pointY < y){
        [dic setObject:@"up" forKey:@"direction"];
        [_timeline addObject:dic];
    }
}

- (void)TextFieldBeginEditing:(NSString*)name;{
    [_textFieldAction setValue:@"Text" forKey:@"Type"];
    [_textFieldAction setValue:name forKey:@"name"];
    [_textFieldAction setValue:[NSString stringWithCurrentTime] forKey:@"startTime"];
}
- (void)TextFieldChangedWithText:(NSString*)text;{
    [_textFieldActionArray addObject:@{@"value":text}];
}
- (void)TextFieldEndEditing;{
    [_textFieldAction setValue:[NSString stringWithCurrentTime] forKey:@"EndTime"];
//    复制信息
    NSArray* arr = [_textFieldActionArray copy];
    [_textFieldAction setObject:arr forKey:@"actions"];
    [_timeline addObject:[_textFieldAction copy]];
//    重置键盘操作
    [_textFieldActionArray removeAllObjects];
    [_textFieldAction removeAllObjects];
}

- (void)SelectCellWithName:(NSString*)name IndexPath:(NSString*)indexPath;{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"Item" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:indexPath forKey:@"indexPath"];
    [_timeline addObject:dic];
}


- (void)RequestErrorWithUrl:(NSString*)url Parameter:(NSDictionary*)parameter Message:(NSString*)message Error:(NSError*)error;{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"RequestError" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [dic setObject:url forKey:@"url"];
    if (parameter) {
        [dic setObject:parameter forKey:@"parameter"];
    }
    if (message) {
        [dic setObject:message forKey:@"message"];
    }
    if (error) {
        [dic setObject:error forKey:@"error"];
    }
    [_timeline addObject:dic];
}


- (void)SaveCrash:(NSDictionary*)crash;{
//    每次进入后台都会保存并覆盖文件 保证数据的完整性 下次AppStart的时候上传成功后清除
//    主要用于手动写入文件 崩溃
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"Crash" forKey:@"Type"];
    [dic setObject:[NSString stringWithCurrentTime] forKey:@"Time"];
    [dic setObject:crash forKey:@"Crash"];
    [_timeline addObject:dic];
    [self WriteToFile];
    [self zipFile:_currentLogPath];
    [self sendCurrentZipSynchronous:YES];
}

-(BOOL)zipFile:(NSString*)path{
    NSMutableArray* arr = [NSMutableArray new];
    [arr addObject:path];
    _currentZipPath = [NSString stringWithFormat:@"%@/GQLOGZIP_%@.zip",DOCPATH_GQLOGZIP,[NSString stringWithFormat:@"%@_%@",_userID,[NSString stringWithCurrentTime]]];
    BOOL zipSucceed = [SSZipArchive createZipFileAtPath:_currentZipPath withFilesAtPaths:arr];
    if (zipSucceed) {
        [GQFileManager deleteFileWithPath:path];
    }
    return zipSucceed;
}

-(void)sendCurrentZipSynchronous:(BOOL)synchronous{
    NSArray* nameArray = [_currentZipPath componentsSeparatedByString:@"/"];
    if (synchronous) {
        [GQFileManager synchronousSendLog:_logServiceUrl WithDataUrl:_currentZipPath fileName:[nameArray lastObject] fileType:_fileType Succeed:^(id obj) {
            [GQFileManager deleteFileWithPath:_currentZipPath];
        } failed:^(id obj) {
            
        }];
    }else{
        NSString* path = _currentZipPath;
        NSArray* nameArray = [path componentsSeparatedByString:@"/"];
        NSData *data = [GQFileManager getDataWithPath:path];
        if (data&&[[nameArray lastObject] rangeOfString:@".zip"].location !=NSNotFound) {
            [GQFileManager sendLog:_logServiceUrl parameters:nil WithData:data fileName:[nameArray lastObject] fileType:_fileType Succeed:^(id obj) {
                [GQFileManager deleteFileWithPath:[NSString stringWithFormat:@"%@/%@",DOCPATH_GQLOGZIP,[nameArray lastObject]]];
            } failed:^(id obj) {
                
            }];
        }
    }
}

-(void)chackLogFolder{
    BOOL create = [GQFileManager creatrFolder];
    if (create) {
//        是否有未打包zip的 日志
        NSDictionary* fileDic = [GQFileManager LastLogExist];
        if ([[fileDic objectForKey:@"log"] count]>0) {
//            打包zip 如果成功打包 删除所有文件
            
            BOOL zipSucceed = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/GQLOGZIP_%@.zip",DOCPATH_GQLOGZIP,[NSString stringWithFormat:@"%@_%@",_userID,[NSString stringWithCurrentTime]]] withFilesAtPaths:[fileDic objectForKey:@"log"]];
            if (zipSucceed) {
                [[fileDic objectForKey:@"log"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [GQFileManager deleteFileWithPath:(NSString*)obj];
                }];
            }else{
                NSLog(@"压缩失败");
            }
        }
    }
}

-(void)chackLogZipFolder{
    NSDictionary* zipDic = [GQFileManager LastLogZipExist];
    if ([[zipDic objectForKey:@"logZip"] count]>0) {
        [[zipDic objectForKey:@"logZip"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* path = obj;
            NSArray* nameArray = [path componentsSeparatedByString:@"/"];
            NSData *data = [GQFileManager getDataWithPath:path];
            if (data&&[[nameArray lastObject] rangeOfString:@".zip"].location !=NSNotFound) {
                [GQFileManager sendLog:_logServiceUrl parameters:nil WithData:data fileName:[nameArray lastObject] fileType:_fileType Succeed:^(id obj) {
                    [GQFileManager deleteFileWithPath:[NSString stringWithFormat:@"%@/%@",DOCPATH_GQLOGZIP,[nameArray lastObject]]];
                } failed:^(id obj) {
                }];
            }
        }];
    }
}

-(void)WriteToFile{
    _currentLogPath = [NSString stringWithFormat:@"%@/GQLOG_%@.log",DOCPATH_GQLOG,self.fileName];
    if ([GQFileManager WriteToFile:_userAction.jsonStringEncoded Path:_currentLogPath]) {
        NSLog(@"写入文件成功");
    }else NSLog(@"写入文件失败");
}

- (NSString*)fileName{
    return  [NSString stringWithFormat:@"%@_%@",_userID,[NSString stringWithCurrentTime]];;
}

-(void)startBackground{
    BOOL result = NO;
    if ( [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    if (result) {
        UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            // Clean up any unfinished task business by marking where you
            // stopped or ending the task outright.
            [application endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }];
    }
}

-(void)endBackground{
    if (self.backgroundTaskId != UIBackgroundTaskInvalid){
        UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
        [application endBackgroundTask:self.backgroundTaskId];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
