//
//  UserTool.h
//  GQ_****
//
//  Created by Madodg on 2017/12/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject
+ (UserTool*)instance;

@property(nonatomic,copy) NSString* UID;
@property(nonatomic,copy) NSString* UName;

+ (BOOL)isLogin:(UIViewController*)vc;
+ (void)showGesturesPassword:(UIViewController*)vc;
+ (void)insertUserInfo;
@end
