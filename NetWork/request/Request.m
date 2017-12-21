//
//  Request.m
//  31jinfu
//
//  Created by 刘厚宽 on 2017/8/14.
//  Copyright © 2017年 刘厚宽. All rights reserved.
//

#import "Request.h"
#import "myModle.h"
@implementation Request
+(id)parsingModle:(Class)modleClass WithOject:(id)object;{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [modleClass modelWithDictionary:object];
    }else if ([object isKindOfClass:[NSArray class]]){
        return  [NSArray modelArrayWithClass:modleClass json:object];
    }
    return nil;
}

-(id)parsingModle:(Class)modleClass WithOject:(id)object;{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [modleClass modelWithDictionary:object];
    }else if ([object isKindOfClass:[NSArray class]]){
        return  [NSArray modelArrayWithClass:modleClass json:object];
    }
    return nil;
}

+(errorModel*)getErrorMessage:(NSDictionary*)dic;{
    errorModel* model = [errorModel modelWithDictionary:dic];;
    return model;
}
-(errorModel*)getErrorMessage:(NSDictionary*)dic;{
    errorModel* model = [errorModel modelWithDictionary:dic];;
    return model;
}


+(void)showErrorURL:(NSString*)urlString;{
    NSLog(@"错误的url是：%@",urlString);
}
-(void)showErrorURL:(NSString*)urlString;{
    NSLog(@"错误的url是：%@",urlString);
}

@end
