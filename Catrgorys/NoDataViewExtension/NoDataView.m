//
//  NoDataView.m
//  GQ_****
//
//  Created by Madodg on 2017/12/29.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "NoDataView.h"

NSString * const GQNoDataViewObserveKeyPath = @"frame";

@implementation NoDataView

- (void)dealloc {
    NSLog(@"占位视图正常销毁");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
