//
//  GQFileManager.h
//  GQ_****
//
//  Created by Madodg on 2017/12/13.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileUtil.h"
//日志存储路径
#define DOCPATH_GQLOG [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GQLOG"]
//日志zip包存储路径
#define DOCPATH_GQLOGZIP [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GQLOGZIP"]

typedef void(^Succeed)(id obj);
typedef void(^Failed)(id obj);

@interface GQFileManager : NSObject

+ (GQFileManager*)instance;

/**
 判断是否存在文件夹 如果存在返回yes 不存在创建成功返回yes

 @return yes
 */
+ (BOOL)creatrFolder;

/**
 查看是否有未被打成zip的日志文件

 @return 返回存在的文件路径
 */
+ (NSDictionary*)LastLogExist;

/**
 查看是否含有需要上传的zip包

 @return 返回存在的文件路径
 */
+ (NSDictionary*)LastLogZipExist;

/**
 获取文件的内容

 @param path 文件绝对路径
 @return 字符串
 */
+ (NSString*)getMessageWithPath:(NSString*)path;


/**
 获取文件内容

 @param path 文件绝对路径
 @return nsdata
 */
+ (NSData*)getDataWithPath:(NSString*)path;

/**
 把获得的数据写入文件

 @param UserActive 数据
 @return 是否成功
 */
+ (BOOL)WriteToFile:(NSString*)UserActive Path:(NSString*)path;

/**
 删除文件

 @param path 路径
 @return 是否删除成功
 */
+ (BOOL)deleteFileWithPath:(NSString*)path;


//异步上传
+(void)sendLog:(NSString*)url parameters:(NSDictionary*)paramet WithData:(NSData*)data fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;
//同步上传
+(void)synchronousSendLog:(NSString*)url WithDataUrl:(NSString*)dataUrl fileName:(NSString*)name fileType:(NSString*)type Succeed:(Succeed)succeed failed:(Failed)failed;

@end
