//
//  myRequest.m
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "myRequest.h"
#import "HTTPRequest.h"

@implementation myRequest

+(void)LoginRequest:(NSString*)url parameters:(NSDictionary*)paramet Succeed:(Succeed)succeed failed:(Failed)failed;{
    HTTPRequest* request = [[HTTPRequest alloc]initWithUrl:url Parameter:paramet RequestType:REQUEST_POST];
    [request startRequestSucceed:^(id obj) {
        if (obj) {
            NSDictionary* error = @{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18",@"myModleArray":@[@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"}]};
            
            myModle* modle =[self parsingModle:[myModle class] WithOject:error];
            succeed(modle);
        }else{
            NSDictionary* error = @{@"message":@"asdfsadf",@"url":@"123",@"code":@"19"};
            errorModel* modle = [self getErrorMessage:error];
            failed(modle);
        }
        
    } failed:^(id obj) {
        failed(obj);
    }];
}

-(void)DelegateRequest:(NSString*)url parameters:(NSDictionary*)paramet RequestType:(NSString*)type{
    HTTPRequest* request = [[HTTPRequest alloc]initWithUrl:url Parameter:paramet RequestType:REQUEST_POST];
    [request startRequestSucceed:^(id obj) {
        if (obj) {
            NSDictionary* error = @{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18",@"myModleArray":@[@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"}]};
            
            myModle* modle =[self parsingModle:[myModle class] WithOject:error];
            [self.delegate onSuccessWithData:modle RequestType:type];
        }else{
            NSDictionary* error = @{@"message":@"asdfsadf",@"url":@"123",@"code":@"19"};
            errorModel* modle = [self getErrorMessage:error];
            [self.delegate onFailedWithData:modle RequestType:type];
        }
        
    } failed:^(id obj) {
        [self.delegate onServiceFailedWithData:obj RequestType:type];
    }];
}

-(void)DelegateRequest2:(NSString*)url parameters:(NSDictionary*)paramet RequestType:(NSString*)type;{
    HTTPRequest* request = [[HTTPRequest alloc]initWithUrl:url Parameter:paramet RequestType:REQUEST_POST];
    [request startRequestSucceed:^(id obj) {
        if (obj) {
            NSDictionary* error = @{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18",@"myModleArray":@[@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"},@{@"n":@"madong",@"p":@"123123",@"id":@"19",@"age":@"18"}]};
            
            myModle* modle =[self parsingModle:[myModle class] WithOject:error];
            [self.delegate onSuccessWithData:modle RequestType:type];
        }else{
            NSDictionary* error = @{@"message":@"asdfsadf",@"url":@"123",@"code":@"19"};
            errorModel* modle = [self getErrorMessage:error];
            [self.delegate onFailedWithData:modle RequestType:type];
        }
        
    } failed:^(id obj) {
        [self.delegate onServiceFailedWithData:obj RequestType:type];
    }];
}

@end
