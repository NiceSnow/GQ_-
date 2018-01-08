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
#import "ZipArchive.h"
#import "Reachability.h"


#define NETTYPE @[@"unknown",@"2G",@"3G",@"4G",@"5G",@"wifi"]
typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
}NETWORK_TYPE;

@interface GQLogManager ()
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
#endif
@end


@implementation GQLogManager

static GQLogManager* _instance = nil;

+(instancetype) instance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        if (LogService) {
            _instance = [[super allocWithZone:NULL] init] ;
        }else
            _instance = nil;
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [GQLogManager instance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [GQLogManager instance] ;
}

-(void)setImmediately:(BOOL)immediately{
    _immediately = immediately;
    if (!_immediately) {
        _instance = nil;
    }
}

//+ (GQLogManager*)instance
//{
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        if (LogService) {
//            instance = [[self alloc] init];
//        }else
//            instance = nil;
//    });
//    return instance;
//}

- (id)init{
    if (self = [super init]){
//        注册崩溃
        [GQCrashHandler installExceptionHandler];
        _userAction = [NSMutableDictionary new];
        _timeline = [NSMutableArray new];
        [_userAction setObject:_timeline forKey:@"timeLine"];
        
        _logModel = [LogModel new];
        
        _userID = @"99999999";
        _userName = @"tourists";
        _phoneNumber = @"";
        _deviceType = @"iOS";
        _immediately = YES;
        
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
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"cleanDisk";
    modle.time = [GQLogManager stringWithCurrentTime];
    [_timeline addObject:modle.toDictionary];
    [self WriteToFile];
}

-(void)clearMemory{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"clearMemory";
    modle.time = [GQLogManager stringWithCurrentTime];
    [_timeline addObject:modle.toDictionary];
    [self WriteToFile];
}

-(void)setUserID:(NSString *)userID{
    if (userID) {
        _userID = userID;
        [_userAction setObject:_userID forKey:@"userID"];
    }
}
-(void)setUserName:(NSString *)userName{
    if (userName) {
        _userName = userName;
        [_userAction setObject:_userName forKey:@"userName"];
    }
}

-(void)setPhoneNumber:(NSString *)phoneNumber{
    if (phoneNumber) {
        _phoneNumber = phoneNumber;
        [_userAction setObject:_phoneNumber forKey:@"phoneNumber"];
    }
}

-(void)setDeviceType:(NSString *)deviceType{
    if (deviceType) {
        _deviceType = deviceType;
        [_userAction setObject:_deviceType forKey:@"deviceType"];
    }
}
/**
 1.创建userAction 并且赋值头信息
 */
- (void)LogStartWithURL:(NSString*)url FileType:(NSString*)type keyInformation:(NSDictionary*)Information{
//    基础信息设定
    _logServiceUrl = url;
    _fileType = type;
    [_userAction setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    [_userAction setObject:[GQLogManager stringWithCurrentTime] forKey:@"time"];
    [[Information allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_userAction setObject:Information[obj] forKey:obj];
    }];
}

- (void)LogEnd;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"loginOut";
    modle.time = [GQLogManager stringWithCurrentTime];
    [_timeline addObject:modle.toDictionary];
    [self WriteToFile];
    [self zipFile:_currentLogPath];
    [self sendCurrentZipSynchronous:NO];
    [_userAction removeAllObjects];
    [_timeline removeAllObjects];
    [_userAction setObject:_timeline forKey:@"timeLine"];
    
    _logModel = nil;
    _logModel = [LogModel new];
    
    self.userID = @"99999999";
    self.userName = @"tourists";
    self.phoneNumber = @"";
    self.deviceType = @"iOS";
}

- (void)BecomeActive;{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self endBackground];
        LogModel* modle = [[LogModel alloc]init];
        modle.type = @"becomeActive";
        modle.time = [GQLogManager stringWithCurrentTime];
        [_timeline addObject:modle.toDictionary];
        [self checkLogFolder];
        [self checkLogZipFolder];
    });
}

- (void)EnterBackground;{
//    只要调用了此函数系统就会允许app的所有线程继续执行，直到任务结束
    [self startBackground];
//    每次进入后台都会保存并覆盖文件 保证数据的完整性
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"enterBackground";
    modle.time = [GQLogManager stringWithCurrentTime];
    [_timeline addObject:modle.toDictionary];
    [self WriteToFile];
    [self zipFile:_currentLogPath];
    [self sendCurrentZipSynchronous:NO];
    
    [_timeline removeAllObjects];
    
    _logModel = nil;
    _logModel = [LogModel new];
}

- (void)showVCWithName:(NSString*)name;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"enterActivity";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    [_timeline addObject:modle.toDictionary];
}

- (void)dismissVCWithName:(NSString*)name;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"leaveActivity";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    [_timeline addObject:modle.toDictionary];
}

- (void)ButtonPressWithName:(NSString*)name;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"click";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    [_timeline addObject:modle.toDictionary];
}

- (void)SwitchChangedWithName:(NSString*)name Value:(BOOL)value;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"switchChange";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    modle.isOn = [NSString stringWithFormat:@"%d",value];
    [_timeline addObject:modle.toDictionary];
}

- (void)SliderValueChangeWithName:(NSString*)name Value:(CGFloat)value;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"sliderChange";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    modle.sliderValue = [NSString stringWithFormat:@"%f",value];
    [_timeline addObject:modle.toDictionary];
}

- (void)GetNotification:(NSDictionary*)message;{
    #pragma need change需要后台配合推送定字段
    [_timeline addObject:@{@"notice":message}];
}

- (void)scrollViewStartDraggingWithName:(NSString*)name :(float)x :(float)y{
    _pointX = x;
    _pointY = y;
    _scrollName = name;
}

- (void)scrollViewEndDragging:(float)x :(float)y{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"ScrollView";
    if (_scrollName) {
        modle.name = _scrollName;
    }
    modle.time = [GQLogManager stringWithCurrentTime];
    if (fabsf((float)_pointX - (float)x) > fabsf((float)_pointY - (float)y)) {
        if (_pointX>x) {
            modle.direction = @"left";
            [_timeline addObject:modle.toDictionary];
        }else{
            modle.direction = @"right";
            [_timeline addObject:modle.toDictionary];
        }
    }else{
        if (_pointY>y) {
            modle.direction = @"up";
            [_timeline addObject:modle.toDictionary];
        }else{
            modle.direction = @"down";
            [_timeline addObject:modle.toDictionary];
        }
    }
}

- (void)TextFieldBeginEditing:(NSString*)name;{
    _logModel.type = @"text";
    _logModel.name = name;
    _logModel.startTime = [GQLogManager stringWithCurrentTime];
}
- (void)TextFieldChangedWithText:(NSString*)text;{

    [_logModel.actions addObject:@{@"value":text}];
}
- (void)TextFieldEndEditing;{

    _logModel.endTime = [GQLogManager stringWithCurrentTime];
//    复制信息

    [_timeline addObject:_logModel.toDictionary];
//    重置键盘操作
    _logModel = nil;
    _logModel = [LogModel new];
}

- (void)SelectCellWithName:(NSString*)name IndexPath:(NSString*)indexPath;{
    LogModel* modle = [[LogModel alloc]init];
    modle.type = @"itemSelect";
    modle.time = [GQLogManager stringWithCurrentTime];
    modle.name = name;
    modle.indexPath = indexPath;
    [_timeline addObject:modle.toDictionary];
}


- (void)RequestErrorWithUrl:(NSString*)url Parameter:(NSDictionary*)parameter Message:(NSString*)message Error:(NSError*)error;{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@"RequestError" forKey:@"Type"];
    [dic setObject:[GQLogManager stringWithCurrentTime] forKey:@"time"];
    [dic setObject:url forKey:@"url"];
    if (parameter) {
        [dic setObject:parameter forKey:@"parameter"];
    }
    if (message) {
        [dic setObject:message forKey:@"message"];
    }
    if (error) {
        #pragma need change error nserror不能写入文件
//        [dic setObject:error forKey:@"error"];
    }
    [GQLogManager checkNetWorlk:^(NSString *netType) {
        [dic setObject:netType forKey:@"netType"];
    }];
    [_timeline addObject:dic];
}


- (void)SaveCrash:(NSArray*)crash;{
//    每次进入后台都会保存并覆盖文件 保证数据的完整性 下次AppStart的时候上传成功后清除
//    主要用于手动写入文件 崩溃
    [GQLogManager checkNetWorlk:^(NSString *netType) {
        if (![netType isEqualToString:@"nuknow"]) {
            NSDictionary* dic = @{@"crash":crash,@"time":[GQLogManager stringWithCurrentTime]};
            [_userAction setValue:dic forKey:@"crash"];
            [self WriteToFile];
            [self zipFile:_currentLogPath];
            [self sendCurrentZipSynchronous:YES];
        }
    }];
}

-(BOOL)zipFile:(NSString*)path{
    
    NSMutableArray* arr = [NSMutableArray new];
    [arr addObject:path];
    _currentZipPath = [NSString stringWithFormat:@"%@/GQLOGZIP_%@.zip",DOCPATH_GQLOGZIP,[NSString stringWithFormat:@"%@_%@",_userID,[GQLogManager stringWithCurrentTime]]];
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

-(void)checkLogFolder{
    BOOL create = [GQFileManager creatrFolder];
    if (create) {
//        是否有未打包zip的 日志
        NSDictionary* fileDic = [GQFileManager LastLogExist];
        if ([[fileDic objectForKey:@"log"] count]>0) {
//            打包zip 如果成功打包 删除所有文件
            
            BOOL zipSucceed = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/GQLOGZIP_%@.zip",DOCPATH_GQLOGZIP,[NSString stringWithFormat:@"%@_%@",_userID,[GQLogManager stringWithCurrentTime]]] withFilesAtPaths:[fileDic objectForKey:@"log"]];
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

-(void)checkLogZipFolder{
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
    return  [NSString stringWithFormat:@"%@_%@",_userID,[GQLogManager stringWithCurrentTime]];;
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

+ (void)checkNetWorlk:(available)netWork{
//    netWork([self getNetworkTypeFromStatusBar]);
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
        {
            netWork(@"nuknow");
        }
            break;
        case ReachableViaWiFi:
        {
            netWork(@"wifi");
        }
            break;
        case ReachableViaWWAN:
        {
            netWork([self getNetworkTypeFromStatusBar]);
        }
            break;

        default:
            break;
    }
}

+(NSString*)stringWithCurrentTime;{
    NSTimeInterval a= [[NSDate date] timeIntervalSince1970]* 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

+(NSString *)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return NETTYPE[nettype];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
