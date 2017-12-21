//
//  LogRequest.m
//  GQ_****
//
//  Created by Madodg on 2017/12/14.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "LogRequest.h"
#import "HTTPRequest.h"

@implementation LogRequest
+(void)sendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;{
    
    HTTPRequest* request = [[HTTPRequest alloc]initWithUrl:url Parameter:paramet RequestType:REQUEST_SENDDATA];
    request.data = data;
    request.dataName = name;
    request.dataType = type;
    [request startRequestSucceed:^(id obj) {
        if (obj) {
            
        }else{

        }
        
    } failed:^(id obj) {
        failed(obj);
    }];
}

+(void)synchronousSendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;{
    
}
@end
