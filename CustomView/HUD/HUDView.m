//
//  HUDView.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.

#import "HUDView.h"

#import "UIImage+GIF.h"

@implementation HUDView
+ (HUDView *)Instance
{
    static HUDView *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+(void)showGIFHUD:(UIViewController*)VC;{
    [VC.view addSubview:[HUDView Instance]];
    [[HUDView Instance] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

+(void)hiddenHUD;{
    [UIView transitionWithView:[HUDView Instance] duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [HUDView Instance].alpha = 0;
    } completion:^(BOOL finished) {
        [[HUDView Instance] removeFromSuperview];
        [HUDView Instance].alpha = 1;
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
