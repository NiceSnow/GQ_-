//
//  myRequest.h
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Request.h"
#import "myModle.h"

@interface myRequest : Request

//block方式
+(void)LoginRequest:(NSString*)url parameters:(NSDictionary*)paramet Succeed:(Succeed)succeed failed:(Failed)failed;
//代理方式 别忘设置代理啊
-(void)DelegateRequest:(NSString*)url parameters:(NSDictionary*)paramet RequestType:(NSString*)type;
-(void)DelegateRequest2:(NSString*)url parameters:(NSDictionary*)paramet RequestType:(NSString*)type;

@end
