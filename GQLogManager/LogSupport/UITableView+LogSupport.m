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
    swizzleMethod([self class], @selector(setDelegate:), @selector(GQ_tableSetDelegate:));
}

- (void)GQ_tableSetDelegate:(id<UITableViewDelegate>)delegate
{

    Class class = [delegate class];

    if (class_addMethod(class, NSSelectorFromString(@"GQ_didSelectRowAtIndexPath"), (IMP)GQ_didSelectRowAtIndexPath, "v@:@@")) {

        Method dis_originalMethod = class_getInstanceMethod(class, @selector(tableView:didSelectRowAtIndexPath:));
        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_didSelectRowAtIndexPath"));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
    [self GQ_tableSetDelegate:delegate];

//    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"), (IMP)GQ_scrollViewWillBeginDragging, "v@:@")) {
//        Method dis_originalMethod = class_getInstanceMethod(class, @selector(scrollViewWillBeginDragging:));
//        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_scrollViewWillBeginDragging"));
//        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
//    }
//
//    if (class_addMethod(class, NSSelectorFromString(@"GQ_scrollViewDidEndDragging"), (IMP)GQ_scrollViewDidEndDragging, "v@:@@")) {
//        Method dis_originalMethod = class_getInstanceMethod(class, @selector(scrollViewDidEndDragging:willDecelerate:));
//        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_scrollViewDidEndDragging"));
//        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
//    }

}

//void GQ_scrollViewDidEndDragging(id self,SEL _cmd,id scrollView,BOOL decelerate){
//    SEL selector = NSSelectorFromString(@"GQ_scrollViewDidEndDragging");
//    ((void(*)(id, SEL,id,BOOL))objc_msgSend)(self, selector, scrollView , decelerate);
//    UIScrollView* view = (UIScrollView*)scrollView;
//    [[GQLogManager instance] scrollViewEndDragging:view.contentOffset.x :view.contentOffset.y];
//}
//
//
//void GQ_scrollViewWillBeginDragging(id self,SEL _cmd,id scrollView){
////    交换回来
//    SEL selector = NSSelectorFromString(@"GQ_scrollViewWillBeginDragging");
//    ((void(*)(id, SEL,id))objc_msgSend)(self, selector, scrollView);
//    UIScrollView* view = (UIScrollView*)scrollView;
//    NSString* name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromClass([view class])];
//    [[GQLogManager instance] scrollViewStartDraggingWithName:name :view.contentOffset.x :view.contentOffset.y];
//}


void GQ_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    NSString *contentPage = NSStringFromClass([self class]);
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)self;
        contentPage = vc.title?:vc.className;
    }
    SEL selector = NSSelectorFromString(@"GQ_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);

    NSArray* cellArray = (NSArray*)[tableView visibleCells];
    UICollectionViewCell* cell;
    if ([cellArray count]>0) {
        cell = cellArray[0];
    }else return;

    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row]];
}

@end
