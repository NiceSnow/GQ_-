//
//  BaseViewController.h
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseScrollView.h"
@interface BaseViewController : UIViewController
@property(nonatomic,strong) UIImageView* barImageView;

- (void)setleftBarItem:(NSString*)imageStr;
- (void)setleftBarItems:(NSString*)firstImage :(NSString*)secondImage;

- (void)setrightBarItem:(NSString*)imageStr;
- (void)setrightBarItems:(NSString*)firstImage :(NSString*)secondImage;
@end
