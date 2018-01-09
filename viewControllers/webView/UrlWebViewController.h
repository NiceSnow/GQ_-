//
//  UrlWebViewController.h
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ZBAddJSDelegate<JSExport>

- (void)callAndroid:(id)message;

@end

@interface UrlWebViewController : BaseViewController<ZBAddJSDelegate>
@property (nonatomic, copy)NSString* urlString;
@end
