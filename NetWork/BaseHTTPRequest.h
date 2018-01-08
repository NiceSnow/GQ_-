//
//  BaseHTTPRequest.h
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseHTTPRequest : NSObject

@property(nonatomic,retain) AFHTTPSessionManager *session;

+ (BaseHTTPRequest*)instance;

-(void)PostRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)GetRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)sendData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type URL:(NSString*)url parameters:(NSDictionary*)params succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)downLoadDataWithURL:(NSString*)url Parameter:(NSDictionary*)parameter saveAs:(NSString*)fileName progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
@end
