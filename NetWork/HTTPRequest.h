//
//  HTTPRequest.h
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseHTTPRequest.h"


typedef void(^Succeed)(id obj);
typedef void(^Failed)(id obj);
static NSInteger requestCount;
typedef NS_ENUM(NSUInteger, requestType) {
    REQUEST_POST = 0,
    REQUEST_GET,
    REQUEST_SENDDATA,
    REQUEST_DOWNLOAD,
    REQUEST_LAST,
};

#define DES_KEY @"%hn970lims@rJBijg0JmumOf"
#define SERVIVE_KEY @"zidingyi"

@interface HTTPRequest : BaseHTTPRequest


/**
 *  判断请求是否需要加密参数。
 */
@property(nonatomic,assign) BOOL encryptionParameter;
/**
 *  判断请求是否需要缓存数据。
 */
@property (nonatomic,assign) BOOL isCacheData;

/**
 *  设置请求头信息。
 */
@property(nonatomic,strong) NSDictionary* requestHeader;

/**
 *  发送文件需要设置3个参数。type @"image/png"  fileName @"1.png"
 */
@property(nonatomic,strong) NSData* data;
@property(nonatomic,strong) NSString* dataName;
@property(nonatomic,strong) NSString* dataType;

/**
 *  下载文件需要设置参数  fileName  用于保存
 */
@property(nonatomic,strong) NSString* fileName;

-(void)startRequestSucceed:(Succeed)succeed failed:(Failed)failed;
-(instancetype)initWithUrl:(NSString*)url Parameter:(NSDictionary*)parameter;
-(instancetype)initWithUrl:(NSString*)url Parameter:(NSDictionary*)parameter RequestType:(requestType)type;
@end

