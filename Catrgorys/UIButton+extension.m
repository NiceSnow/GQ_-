//
//  UIButton+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "UIButton+extension.h"


@implementation UIButton (extension)
-(void)setSpacing:(CGFloat)spacing withText:(NSString*)text forState:(UIControlState)state numberOfLine:(NSInteger)line;{
    if (text.length<=0||!self ||!spacing) {
        return;
    }
    self.titleLabel.numberOfLines = line;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spacing];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self setAttributedTitle:attributedString1 forState:state];
}

-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle complate:(void (^)(void))complate{
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                complate();
            });
        }else{
            NSInteger seconds = timeOut % 60;
            NSInteger minutes = (timeOut / 60) % 60;
            NSInteger hours   = (timeOut / 3600)%24;
            NSInteger day     = timeOut / 3600 / 24;
            NSString *strTime=nil;
            if (day>0) {
                strTime = [NSString stringWithFormat:@"  %@ 后开始  ", [NSString stringWithFormat:@"%01ld天%02ld:%02ld:%02ld",day,hours, minutes, seconds]];
            }else{
                strTime = [NSString stringWithFormat:@"  %@ 后开始  ", [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds]];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:strTime forState:UIControlStateNormal];
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
}
@end
