//
//  LogModel.h
//  GQ_****
//
//  Created by Madodg on 2017/12/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQLogManager.h"

@interface LogModel : NSObject
@property(nonatomic,copy) NSString* netType;
@property(nonatomic,copy) NSString* sliderValue;
@property(nonatomic,copy) NSString* isOn;
@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* time;
@property(nonatomic,copy) NSString* startTime;
@property(nonatomic,copy) NSString* endTime;
@property(nonatomic,copy) NSString* direction;
@property(nonatomic,copy) NSString* indexPath;
@property(nonatomic,strong) NSMutableArray* actions;
- (NSDictionary*)toDictionary;
@end
