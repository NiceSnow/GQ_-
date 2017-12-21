//
//  errorModel.h
//  GQ_****
//
//  Created by Madodg on 2017/12/5.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface errorModel : NSObject
@property(nonatomic,strong) NSString* errorUrl;
@property(nonatomic,strong) NSString* message;
@property(nonatomic,strong) NSString* code;
@end
