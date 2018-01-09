//
//  HUDView.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.

#import "HUDView.h"

#import "UIImage+GIF.h"

@implementation HUDView

static HUDView* _HUDInstance = nil;

+(instancetype) instance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _HUDInstance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _HUDInstance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [HUDView instance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [HUDView instance] ;
}

+(void)showGIFHUD:(UIViewController*)VC;{
    [VC.view addSubview:[HUDView instance]];
    [[HUDView instance] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

+(void)hiddenHUD;{
    [UIView transitionWithView:[HUDView instance] duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [HUDView instance].alpha = 0;
    } completion:^(BOOL finished) {
        [[HUDView instance] removeFromSuperview];
        [HUDView instance].alpha = 1;
    }];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"Londing.gif" ofType:nil];
        
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImageView* imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.image =  [UIImage sd_animatedGIFWithData:imageData];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(@80);
        }];
        
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

-(void)handleDoubleTap:(id)sender{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
