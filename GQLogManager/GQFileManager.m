//
//  GQFileManager.m
//  GQ_****
//
//  Created by Madodg on 2017/12/13.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "GQFileManager.h"
#import "NSURLSession+SynchronousRequest.h"

@interface GQFileManager ()
@property(nonatomic,strong) AFHTTPSessionManager* session;
@end

@implementation GQFileManager

static GQFileManager* _FileManagerInstance = nil;

+(instancetype) instance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _FileManagerInstance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _FileManagerInstance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [GQFileManager instance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [GQFileManager instance] ;
}

+ (BOOL)creatrFolder;{
    return ([FileUtil creatrFolderWithPath:DOCPATH_GQLOG]&&[FileUtil creatrFolderWithPath:DOCPATH_GQLOGZIP]);
}

+ (NSDictionary*)LastLogExist;{
    NSMutableDictionary* dataDic = [@{@"log":@[]} mutableCopy];
    NSArray* GQLOGArray = [FileUtil fileExistsInFolder:DOCPATH_GQLOG];
    if ([GQLOGArray count]>0) {
        [dataDic setObject:GQLOGArray forKey:@"log"];
    };
    return dataDic;
}

+ (NSDictionary*)LastLogZipExist;{
    NSMutableDictionary* dataDic = [@{@"logZip":@[]} mutableCopy];
    NSArray* GQLOGZipArray = [FileUtil fileExistsInFolder:DOCPATH_GQLOGZIP];
    if ([GQLOGZipArray count]>0) {
        [dataDic setObject:GQLOGZipArray forKey:@"logZip"];
    };
    return dataDic;
}

+ (NSString*)getMessageWithPath:(NSString*)path;{
    return [FileUtil getFileContentWithPatch:path];
}

+ (NSData*)getDataWithPath:(NSString*)path;{
    return [FileUtil getDataContentWithPatch:path];
}

+ (BOOL)WriteToFile:(NSString*)UserActive Path:(NSString*)path;{
    return [UserActive writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)deleteFileWithPath:(NSString*)path;{
    return [FileUtil deleteFileAtPath:path];
}

+(void)sendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;{
    
    [[self instance].session POST:url parameters:paramet constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData != NULL) {
            [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:type];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}

+(void)synchronousSendLog:(NSString*)url WithDataUrl:(NSString*)dataUrl fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;{
    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setTimeoutInterval:10];
    [uploadRequest setValue:@"file" forHTTPHeaderField:@"name"];
    [uploadRequest setValue:name forHTTPHeaderField:@"filename"];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSString *fileUrl = dataUrl;
    NSError *error = nil;
    NSURLResponse *response = nil;
    [session sendSynchronousUploadTaskWithRequest:uploadRequest fromFile:fileUrl returningResponse:&response error:&error];
    if (!error) {
        succeed(response);
    }else{
        failed(error);
    }
}

-(AFHTTPSessionManager*)session{
    if (!_session) {
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer.timeoutInterval = 30;
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/pdf", nil];
        _session.responseSerializer = response;
        _session.securityPolicy.allowInvalidCertificates = YES;
        _session.securityPolicy.validatesDomainName = NO;
    }
    return _session;
}
@end
