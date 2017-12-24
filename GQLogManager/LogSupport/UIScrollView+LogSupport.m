//
//  UIScrollView+LogSupport.m
//  GQ_****
//
//  Created by Madodg on 2017/12/24.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UIScrollView+LogSupport.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIScrollView (LogSupport)

+ (void)load
{
    swizzleMethod([self class], @selector(setDelegate:), @selector(GQ_setDelegate:));
}

- (void)GQ_setDelegate:(id<UITableViewDelegate>)delegate{
    Class class = [delegate class];
    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"), (IMP)GQ_scrollViewWillBeginDragging, "v@:@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, @selector(scrollViewWillBeginDragging:));
        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewDidEndDragging"), (IMP)GQ_scrollViewDidEndDragging, "v@:@@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, @selector(scrollViewDidEndDragging:willDecelerate:));
        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_scrollViewDidEndDragging"));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
    [self GQ_setDelegate:delegate];
}


void GQ_scrollViewDidEndDragging(id self,SEL _cmd,id scrollView,BOOL decelerate){
    SEL selector = NSSelectorFromString(@"GQ_scrollViewDidEndDragging");
    ((void(*)(id, SEL,id,BOOL))objc_msgSend)(self, selector, scrollView , decelerate);
    UIScrollView* view = (UIScrollView*)scrollView;
    [[GQLogManager instance] scrollViewEndDragging:view.contentOffset.x :view.contentOffset.y];
}


void GQ_scrollViewWillBeginDragging(id self,SEL _cmd,id scrollView){
    //    交换回来
    SEL selector = NSSelectorFromString(@"GQ_scrollViewWillBeginDragging");
    ((void(*)(id, SEL,id))objc_msgSend)(self, selector, scrollView);
    UIScrollView* view = (UIScrollView*)scrollView;
    NSString* name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromClass([view class])];
    [[GQLogManager instance] scrollViewStartDraggingWithName:name :view.contentOffset.x :view.contentOffset.y];
}


@end
