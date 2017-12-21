//
//  NSURLSession+SynchronousRequest.h
//  demo
//
//  Created by bob smith on 2017/12/19.
//  Copyright © 2017年 bob smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (SynchronousRequest)

#pragma mark - UploadTask

- (nullable NSData *)sendSynchronousUploadTaskWithRequest:(nonnull NSURLRequest *)request fromFile:(nonnull NSString *)fileURL returningResponse:(NSURLResponse *_Nullable*_Nullable)response error:(NSError *_Nullable*_Nullable)error;
- (nullable NSData *)sendSynchronousUploadTaskWithRequest:(nonnull NSURLRequest *)request fromData:(nonnull NSData *)bodyData returningResponse:(NSURLResponse *_Nullable*_Nullable)response error:(NSError *_Nullable*_Nullable)error;

@end
