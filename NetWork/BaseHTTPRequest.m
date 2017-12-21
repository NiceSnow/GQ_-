//
//  BaseHTTPRequest.m
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseHTTPRequest.h"

static BOOL netAvailable;
@interface BaseHTTPRequest ()

@end

@implementation BaseHTTPRequest



+ (BaseHTTPRequest*)instance
{
    static BaseHTTPRequest *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer.timeoutInterval = 30;
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/pdf", nil];
        _session.responseSerializer = response;
        _session.securityPolicy.allowInvalidCertificates = YES;
        _session.securityPolicy.validatesDomainName = NO;
    }
    return self;
}

-(void)PostRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;{
    [self.session POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

-(void)GetRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;{
    [self.session GET:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

-(void)sendData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type URL:(NSString*)url parameters:(NSDictionary*)params succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;{
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    [self.session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData != NULL) {
            [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:type];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_semaphore_signal(semaphore);   //发送信号
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);

    }];
//    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
//    NSLog(@"数据加载完成！");
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *URL =[NSURL URLWithString:url];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"POST";
//    //2.3.设置请求头
//    NSString *header = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"----WebKitFormBoundary35cxmtFcIglrlsad"];
//    [request setValue:header forHTTPHeaderField:@"Content-Type"];
//
//    // session上传不需要设置请求体,如果数据在request中会被忽略。
//    [self getBody:data];
//    NSURLSessionUploadTask *upLoadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//    }];
//    // 开启执行
//    [upLoadTask resume];

}

-(void)downLoadDataWithURL:(NSString*)url Parameter:(NSDictionary*)parameter saveAs:(NSString*)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
//        __weak typeof(self) weakSelf = self;
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            // 下载进度
//            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        }];
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:fileName];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
    
}

- (BOOL)isConnectionAvailable{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                
                netAvailable = YES;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                netAvailable = NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                netAvailable = NO;
                
            }
                break;
            default:
                break;
        }
    }];
    return !netAvailable;
}

-(NSData *)getBody:(NSData*)data
{
    //5.设置请求体
    NSMutableData *fileData = [NSMutableData data];
    //5.1 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="123.png"
     Content-Type: image/png
     空行
     文件数据
     */
    NSString *str = [NSString stringWithFormat:@"--%@",@"123"];
    [fileData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"123.txt\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Type: application/octet-stream" dataUsingEncoding:NSUTF8StringEncoding]];

    [fileData appendData:data];
    //5.2 非文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="username"
     空行
     yy
     */
    [fileData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"yy" dataUsingEncoding:NSUTF8StringEncoding]];

    //5.3 结尾标识
    /*
     --分隔符--
     */
    return fileData;
}

@end
