//
//  Request.h
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "errorModel.h"

@protocol requestDelegate<NSObject>
- (void) onSuccessWithData : (id) data RequestType:(NSString*)type;
- (void) onFailedWithData : (id) data RequestType:(NSString*)type;
- (void) onServiceFailedWithData : (id) data RequestType:(NSString*)type;
@end
/**
 网络回调block 
 */
typedef void(^Succeed)(id obj);
typedef void(^Failed)(id obj);

@interface Request : NSObject

/**
 网络回调代理
 */
@property(nonatomic,assign) id<requestDelegate>delegate;

/**
 数据解析

 @param modleClass 类名
 @param object 需要解析的object 可以是数组 或者字典
 @return 返回一个model
 */
+(id)parsingModle:(Class)modleClass WithOject:(id)object;
-(id)parsingModle:(Class)modleClass WithOject:(id)object;

/**
 网络请求成功 但是有错误

 @param dic 服务器返回错误信息
 @return errorModle
 */
+(errorModel*)getErrorMessage:(NSDictionary*)dic;
-(errorModel*)getErrorMessage:(NSDictionary*)dic;

+(void)serverError:(NSError*)error;
-(void)serverError:(NSError*)error;

+(void)showErrorURL:(NSString*)urlString;
-(void)showErrorURL:(NSString*)urlString;

@end
