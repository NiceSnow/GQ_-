//
//  FileUtil.m
//  GQ_****
//
//  Created by Madodg on 2017/12/12.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+ (unsigned long long)fileSizeForPath:(NSString*)path
{
    unsigned long long fileSize = 0;
    
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSError* error = nil;
        NSDictionary* fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

+ (NSString*)tempPathFor:(NSString*)path saveIn:(NSString *)saveIn
{
    NSString* tempFilePath = nil;
    
    NSString* tempFileName = [path lastPathComponent];
    
    tempFilePath = [[FileUtil getPathInCacheDirBy:saveIn createIfNotExist:YES] stringByAppendingPathComponent:tempFileName];
    
    return tempFilePath;
}

+ (NSString*)getPathInDocumentsDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate
{
    NSString* subPath;
    
    NSString* dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    subPath = [dir stringByAppendingPathComponent:subFolder];
    
    if (![FileUtil fileExistsAtPath:subPath])
    {
        if (needCeate)
        {
            NSError* error = nil;
            if (![[NSFileManager new] createDirectoryAtPath:subPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"创建%@失败,Error=%@", subFolder,error);
            }
        }
    }
    
    return subPath;
}

+ (NSString*)getPathInCacheDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate
{
    
    NSString* subPath;
    
    NSString* dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Cache"];
    subPath = [dir stringByAppendingPathComponent:subFolder];
    
    if (![FileUtil fileExistsAtPath:subPath])
    {
        
        if (needCeate)
        {
            NSError* error = nil;
            if (![[NSFileManager new] createDirectoryAtPath:subPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"创建%@失败,Error=%@", subFolder,error);
            }
        }
    }
    
    return subPath;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:path];
    
    // NSLog(@"fileExistsAtPath:%@ = %@",path, (isExist ? @"YES" : @"NO"));
    
    return isExist;
    
}


+ (BOOL)deleteFileAtPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL result = NO;
    
    if ([FileUtil fileExistsAtPath:path])
    {
        result = [fileManager removeItemAtPath:path error:&error];
    }
    else
    {
        result = YES;
    }
    
    if (error)
    {
        // NSLog(@"removeItemAtPath:%@ 失败,error = %@",path,error);
    }
    else
    {
        // NSLog(@"removeItemAtPath:%@ 成功,error = %@",path,error);
    }
    
    return result;
}

+ (BOOL) cutFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL result = NO;
    
    if ([FileUtil deleteFileAtPath:dstPath])
    {
        
        if ([FileUtil fileExistsAtPath:srcPath])
        {
            result = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
        }
        
    }
    
    if (error)
    {
        // NSLog(@"moveItemAtPath:%@ toPath:%@ 失败,error = %@",srcPath,dstPath,error);
    }
    else
    {
        // NSLog(@"moveItemAtPath:%@ toPath:%@ 成功,error = %@",srcPath,dstPath,error);
    }
    
    return result;
}

+ (NSArray*)fileExistsInFolder:(NSString*)path;{
    NSMutableArray* array = [NSMutableArray new];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

+ (BOOL)creatrFolderWithPath:(NSString*)path;{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return bCreateDir;
    }else return YES;
    return NO;
}

+ (NSString*)getFileContentWithPatch:(NSString*)patch;{
    return [[NSString alloc] initWithContentsOfFile:patch encoding:NSUTF8StringEncoding error:nil];
}
+ (NSData*)getDataContentWithPatch:(NSString*)patch;{
    return [NSData dataWithContentsOfFile:patch];
}

@end
