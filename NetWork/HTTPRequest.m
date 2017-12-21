//
//  HTTPRequest.m
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "HTTPRequest.h"
#import "NSString+extension.h"

@interface HTTPRequest()
/**
 *  请求的url。
 */
@property(nonatomic,copy) NSString* urlString;
/**
 *  请求的参数。
 */
@property(nonatomic,strong) NSDictionary* parameter;

/**
 *  请求的类型。
 */
@property(nonatomic,assign) requestType type;

@end

@implementation HTTPRequest

-(void)startRequestSucceed:(Succeed)succeed failed:(Failed)failed;{
//    加密参数
    if (_encryptionParameter) {
        _parameter = [self encryptionValue:_parameter];
    }
    switch (_type) {
        case REQUEST_POST:
        {
            [[BaseHTTPRequest instance] PostRequestWithURL:_urlString Parameter:_parameter succeed:^(NSURLSessionDataTask *task, id responseObject) {
                [self cacheData:responseObject];
                succeed(responseObject);
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                id responseObject = [self getData];
                if (responseObject) {
                    succeed(responseObject);
                }
                failed(error);
            }];
        }
            break;
        case REQUEST_GET:
        {
            [[BaseHTTPRequest instance] GetRequestWithURL:_urlString Parameter:_parameter succeed:^(NSURLSessionDataTask *task, id responseObject) {
                [self cacheData:responseObject];
                succeed(responseObject);
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                id responseObject = [self getData];
                if (responseObject) {
                    succeed(responseObject);
                }
                failed(error);
            }];
        }
            break;
        case REQUEST_SENDDATA:
        {
            if (_dataType&&_data&&_dataName) {
                [[BaseHTTPRequest instance] sendData:_data fileName:_dataName fileType:_dataType URL:_urlString parameters:_parameter succeed:^(NSURLSessionDataTask *task, id responseObject) {
                    [self cacheData:responseObject];
                    succeed(responseObject);
                } failed:^(NSURLSessionDataTask *task, NSError *error) {
                    id responseObject = [self getData];
                    if (responseObject) {
                        succeed(responseObject);
                    }
                    failed(error);
                }];
            }else {
                NSLog(@"请检查文件传输参数 data dataname dataType");
            }
        }
            break;
        case REQUEST_DOWNLOAD:
        {
            if (_fileName) {
                [[BaseHTTPRequest instance] downLoadDataWithURL:_urlString Parameter:_parameter saveAs:_fileName progress:^(NSProgress *downloadProgress) {
                    
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    succeed(filePath);
                }];
            }else{
                NSLog(@"请检查文件保存名称 fileName");
            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void)cacheData:(id)responseObject{
    if (_isCacheData) {
        YYCache *yyCache=[YYCache cacheWithName:@"GQCache"];
        [yyCache setObject:responseObject forKey:[self getCacheKey] withBlock:^{
            NSLog(@"set Object sucess");
        }];
    }
}
-(id)getData{
    YYCache *yyCache=[YYCache cacheWithName:@"GQCache"];
    return [yyCache objectForKey:[self getCacheKey]];
}

-(NSDictionary*)encryptionValue:(NSDictionary*)parameter{
    
    __block NSMutableDictionary* newParameter = [NSMutableDictionary new];
    NSString* jsonString = parameter.jsonStringEncoded;
    [newParameter setObject:[jsonString encryptWithKey:DES_KEY] forKey:SERVIVE_KEY];
    return newParameter;
}

-(void)setRequestHeader:(NSDictionary *)requestHeader{
    [requestHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [[BaseHTTPRequest instance].session.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

-(void)serverError:(NSError*)error;{
    
}

-(void)showErrorURL{
    NSLog(@"错误的url是：%@",_urlString);
}

-(instancetype)initWithUrl:(NSString*)url Parameter:(id)parameter;{
    _type = _type?_type:REQUEST_POST;
    _urlString = kStringIsEmpty(url)?url:@"";
    if (_urlString.length == 0) {
        NSLog(@"url为空");
        return nil;
    }
    if ([parameter isKindOfClass:[NSDictionary class]]||[parameter isKindOfClass:[NSMutableDictionary class]]) {
        _parameter = parameter;
    }
    return self;
}
-(instancetype)initWithUrl:(NSString*)url Parameter:(id)parameter RequestType:(requestType)type;{
    _type = (type>=REQUEST_POST&&type<REQUEST_LAST)?type:REQUEST_POST;
    return [self initWithUrl:url Parameter:parameter];
}

-(NSString *)getCacheKey{
    return [NSString stringWithFormat:@"%@%@",_urlString,_parameter.jsonStringEncoded];
}

@end

