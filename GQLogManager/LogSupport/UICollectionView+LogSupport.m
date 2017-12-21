//
//  UICollectionView+LogSupport.m
//  GQ_****
//
//  Created by Madodg on 2017/12/15.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UICollectionView+LogSupport.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UICollectionView (LogSupport)

+(void)load{
    swizzleMethod([self class], @selector(setDelegate:), @selector(GQ_setDelegate:));
}

- (void)GQ_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    [self GQ_setDelegate:delegate];
    
    Class class = [delegate class];
    if (class_addMethod([delegate class], NSSelectorFromString(@"GQ_didSelectItemAtIndexPath"), (IMP)GQ_didSelectItemAtIndexPath, "v@:@@")) {
        
        swizzleMethod(class, @selector(collectionView:didSelectItemAtIndexPath:), NSSelectorFromString(@"GQ_didSelectItemAtIndexPath"));
    }
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_collectionWillBeginDragging"), (IMP)GQ_collectionWillBeginDragging, "v@:@")) {
        swizzleMethod(class, @selector(scrollViewWillBeginDragging:), NSSelectorFromString(@"GQ_collectionWillBeginDragging"));
    }
    
    if (class_addMethod(class, NSSelectorFromString(@"GQ_collectionDidEndDragging"), (IMP)GQ_collectionDidEndDragging, "v@:@@")) {
        swizzleMethod(class, @selector(scrollViewDidEndDragging:willDecelerate:), NSSelectorFromString(@"GQ_collectionDidEndDragging"));
    }
}

void GQ_collectionWillBeginDragging(id self,SEL _cmd,id scrollView){
    //    交换回来
    SEL selector = NSSelectorFromString(@"GQ_collectionWillBeginDragging");
    ((void(*)(id, SEL,id))objc_msgSend)(self, selector, scrollView);
    UIScrollView* view = (UIScrollView*)scrollView;
    NSString* name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromClass([view class])];
    [[GQLogManager instance] scrollViewStartDraggingWithName:name :view.contentOffset.x :view.contentOffset.y];
}

void GQ_collectionDidEndDragging(id self,SEL _cmd,id scrollView,BOOL decelerate){
    SEL selector = NSSelectorFromString(@"GQ_collectionDidEndDragging");
    ((void(*)(id, SEL,id,BOOL))objc_msgSend)(self, selector, scrollView , decelerate);
    UIScrollView* view = (UIScrollView*)scrollView;
    [[GQLogManager instance] scrollViewEndDragging:view.contentOffset.x :view.contentOffset.y];
}

void GQ_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexpath)
{
    NSString *contentPage = NSStringFromClass([self class]);
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)self;
        contentPage = vc.title?:vc.className;
    }
    
    SEL selector = NSSelectorFromString(@"GQ_didSelectItemAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, collectionView, indexpath);
    
    UICollectionViewCell* cell = (UICollectionViewCell*)[collectionView visibleCells][0];
    NSLog(@"%@",NSStringFromClass([cell class]));
    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row]];
}

@end
