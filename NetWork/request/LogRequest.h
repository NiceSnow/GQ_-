//
//  LogRequest.h
//  GQ_****
//
//  Created by Madodg on 2017/12/14.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Request.h"

@interface LogRequest : Request
//异步上传
+(void)sendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;
+(void)synchronousSendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;
@end
