//
//  UITableView+LogSupport.m
//  GQ_****
//
//  Created by Madodg on 2017/12/15.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UITableView+LogSupport.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITableView (LogSupport)


+ (void)load
{
    swizzleMethod([self class], @selector(setDelegate:), @selector(GQ_setDelegate:));
}

- (void)GQ_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self GQ_setDelegate:delegate];
    
    Class class = [delegate class];
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_didSelectRowAtIndexPath"), (IMP)GQ_didSelectRowAtIndexPath, "v@:@@")) {

        swizzleMethod(class, @selector(tableView:didSelectRowAtIndexPath:), NSSelectorFromString(@"GQ_didSelectRowAtIndexPath"));
    }
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"), (IMP)GQ_scrollViewWillBeginDragging, "v@:@")) {
        swizzleMethod(class, @selector(scrollViewWillBeginDragging:), NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"));
    }
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewDidEndDragging"), (IMP)GQ_scrollViewDidEndDragging, "v@:@@")) {
        swizzleMethod(class, @selector(scrollViewDidEndDragging:willDecelerate:), NSSelectorFromString(@"GQ_scrollViewDidEndDragging"));
    }
    
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


void GQ_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    NSString *contentPage = NSStringFromClass([self class]);
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)self;
        contentPage = vc.title?:vc.className;
    }
    SEL selector = NSSelectorFromString(@"GQ_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);

    UITableViewCell* cell = (UITableViewCell*)[tableView visibleCells][0];
    NSLog(@"%@",NSStringFromClass([cell class]));
    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row]];
}

@end
