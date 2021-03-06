//
//  LogModel.m
//  GQ_****
//
//  Created by Madodg on 2017/12/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "LogModel.h"

@implementation LogModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _netType = @"nuknow";
        _sliderValue = @"";
        _isOn = @"";
        _type = @"";
        _name = @"";
        _time = @"";
        _startTime = @"";
        _endTime = @"";
        _direction = @"";
        _indexPath = @"";
        _actions = [NSMutableArray new];
    }
    return self;
}

-(NSString *)netType{
    [GQLogManager checkNetWorlk:^(NSString *netType) {
        _netType = netType;
    }];
    return _netType;
}

-(NSString *)time{
    return _time = [GQLogManager stringWithCurrentTime];
}

- (NSDictionary*)toDictionary{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    NSArray* properNames = [LogModel allPropertyNames];
    [properNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dic setValue:[self valueForKey:obj] forKey:obj];
    }];
    return dic;
}

+ (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}
@end
