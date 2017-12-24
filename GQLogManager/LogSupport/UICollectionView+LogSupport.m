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
    swizzleMethod([self class], @selector(setDelegate:), @selector(GQ_collectionSetDelegate:));
}

- (void)GQ_collectionSetDelegate:(id<UICollectionViewDelegate>)delegate {

    [self GQ_collectionSetDelegate:delegate];

    Class class = [delegate class];
    if (class_addMethod([delegate class], NSSelectorFromString(@"GQ_didSelectItemAtIndexPath"), (IMP)GQ_didSelectItemAtIndexPath, "v@:@@")) {

        Method dis_originalMethod = class_getInstanceMethod(class, @selector(collectionView:didSelectItemAtIndexPath:));
        Method dis_swizzledMethod = class_getInstanceMethod(class, NSSelectorFromString(@"GQ_didSelectItemAtIndexPath"));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
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

    NSArray* cellArray = (NSArray*)[collectionView visibleCells];
    UICollectionViewCell* cell;
    if ([cellArray count]>0) {
        cell = cellArray[0];
    }else return;

    NSLog(@"%@",NSStringFromClass([cell class]));
    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row]];
}

@end
