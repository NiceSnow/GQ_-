//
//  UIViewController+AOP.m
//  demo
//
//  Created by bob smith on 2017/12/25.
//  Copyright © 2017年 bob smith. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "UIView+extension.h"

@implementation UIViewController (AOP)

+ (void)load
{
    Method originalMtd = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method swizzleMtd = class_getInstanceMethod([self class], @selector(aop_viewWillAppear:));
    method_exchangeImplementations(originalMtd, swizzleMtd);
    
    Method originalMtd1 = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method swizzleMtd1 = class_getInstanceMethod([self class], @selector(aop_viewDidDisAppear:));
    method_exchangeImplementations(originalMtd1, swizzleMtd1);
}

- (void)aop_viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", NSStringFromClass([self class]));
//    [[GQLogManager instance] showVCWithName:NSStringFromClass([self class])];
//    [self aop_viewWillAppear:animated];
}
- (void)aop_viewDidDisAppear:(BOOL)animated
{
    NSLog(@"%@", NSStringFromClass([self class]));
//    [[GQLogManager instance] dismissVCWithName:NSStringFromClass([self class])];
//    [self aop_viewDidDisAppear:animated];
}
@end

@implementation UIView (viewPath)

- (NSString *)viewPath {
    
    NSString *viewPath = nil;
    NSString *viewPathIndex = nil;
    
    UIView *view = self;
    id superView = self.nextResponder;
    
    while (superView) {
        NSString *viewClsName = NSStringFromClass([view class]);
        Class cls = view.class;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class==%@", cls];
        unsigned long index = 0;
        if ([superView isKindOfClass:[UIView class]] && [view isKindOfClass:[UIView class]]) {
            UIView *superV = (UIView *)superView;
            NSArray *sameViewList = [superV.subviews filteredArrayUsingPredicate:predicate];
            if ([sameViewList containsObject:view]) {
                index = [sameViewList indexOfObject:view];
            }else {
                index = 0;
            }
        }
        else if ([view isKindOfClass:[UIViewController class]]){
            
//            UIViewController *vc = (UIViewController *)view;
//            if ([vc canPerformAction:@selector(alias) withSender:nil]) {
//                NSString *alias = [vc performSelector:@selector(alias) withObject:nil];
//                viewClsName = alias;
//            }
        }
        else {
            index = 0;
        }

        if (viewPath) {
            viewPath = [NSString stringWithFormat:@"%@-%@", viewClsName, viewPath];
            viewPathIndex = [NSString stringWithFormat:@"%lu-%@", index, viewPathIndex];
        }else {
            viewPath = viewClsName;
            viewPathIndex = [NSString stringWithFormat:@"%lu", index];
        }
        NSArray *breakList = @[@"UIWindow", @"UIViewController"];
        BOOL stop = NO;
        for (NSString *clsName in breakList) {
            if ([view isKindOfClass:NSClassFromString(clsName)]) {
                stop = YES;
                break;
            }
        }
        if (stop) {
            break;
        }
        view = superView;
        superView = view.nextResponder;
    }
    viewPath = [NSString stringWithFormat:@"%@&%@", viewPath, viewPathIndex];
    NSLog(@"viewPath - %@", viewPath);
    
    return viewPath;
}

+ (void)load {
    
    Method originalMtd = class_getInstanceMethod(self, @selector(addGestureRecognizer:));
    Method swizzleMtd = class_getInstanceMethod(self, @selector(aop_addGestureRecognizer:));
    method_exchangeImplementations(originalMtd, swizzleMtd);
}

- (void)aop_addGestureRecognizer:(UIGestureRecognizer *)gesture {
    gesture.sourceView = self;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture-------%@", gesture);
    }
    [self aop_addGestureRecognizer:gesture];
}

@end

@implementation UIGestureRecognizer (sourceView)
static NSString *UIGestureRecognizer_startPointX;
static NSString *UIGestureRecognizer_startPointY;

- (UIView *)sourceView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSourceView:(UIView *)sourceView {
    objc_setAssociatedObject(self, @selector(sourceView), sourceView, OBJC_ASSOCIATION_ASSIGN);
}

-(float)startPointX{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
-(void)setStartPointX:(float)startPointX{
    objc_setAssociatedObject(self, @selector(startPointX), [NSNumber numberWithFloat:startPointX], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(float)startPointY{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}
-(void)setStartPointY:(float)startPointY{
    objc_setAssociatedObject(self, @selector(startPointY), [NSNumber numberWithFloat:startPointY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation UIApplication (AOP)


+ (void)load {
    
    Method originalMtd = class_getInstanceMethod(NSClassFromString(@"UIGestureRecognizerTarget"), NSSelectorFromString(@"_sendActionWithGestureRecognizer:"));
    
    SEL sel = @selector(aop_sendActionWithGestureRecognizer:);
    Method func = class_getInstanceMethod([self class], sel);
    IMP imp = method_getImplementation(func);
    const char *types = method_getTypeEncoding(func);

    if (class_addMethod(NSClassFromString(@"UIGestureRecognizerTarget"), sel, imp, types)) {
        Method swizzleMtd = class_getInstanceMethod(NSClassFromString(@"UIGestureRecognizerTarget"), @selector(aop_sendActionWithGestureRecognizer:));
        method_exchangeImplementations(originalMtd, swizzleMtd);
    }
}

- (void)aop_sendActionWithGestureRecognizer:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            
            UIView *sourceView = gesture.sourceView;
            CGPoint point = [gesture locationInView:sourceView.ViewController.view];
            
            NSString *viewPath = [sourceView viewPath];
            [[GQLogManager instance] scrollViewStartDraggingWithName:viewPath :point.x :point.y];
        }
        if (gesture.state == UIGestureRecognizerStateEnded) {
            UIView *sourceView = gesture.sourceView;
            CGPoint point = [gesture locationInView:sourceView.ViewController.view];
            [[GQLogManager instance] scrollViewEndDragging:point.x :point.y];
        }
    }
    [self aop_sendActionWithGestureRecognizer:gesture];
}

@end

@interface UIControl()

@property (nonatomic, assign) NSTimeInterval aop_acceptEventTime;

@end
@implementation UIControl (AOP)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";


- (NSTimeInterval )aop_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setAop_acceptEventInterval:(NSTimeInterval)aop_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(aop_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )aop_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setAop_acceptEventTime:(NSTimeInterval)aop_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(aop_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    Method originalMtd = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method swizzleMtd = class_getInstanceMethod([self class], @selector(aop_sendAction:to:forEvent:));
    method_exchangeImplementations(originalMtd, swizzleMtd);
    swizzleMethod([self class], @selector(init), @selector(GQ_init));
    swizzleMethod([self class], @selector(awakeFromNib), @selector(GQ_awakeFromNib));
}

- (instancetype)GQ_init{
    id privateSelf = [self GQ_init];
    [privateSelf addTarget:self action:@selector(GQ_startEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [privateSelf addTarget:self action:@selector(GQ_endEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [privateSelf addTarget:self action:@selector(GQ_textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [privateSelf addTarget:self action:@selector(GQ_TouchCancel:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchUpInside];
    return privateSelf;
}

- (void)GQ_awakeFromNib {
    [self GQ_awakeFromNib];
    [self addTarget:self action:@selector(GQ_startEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(GQ_endEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(GQ_textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(GQ_TouchCancel:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchUpInside];
}

-(void)GQ_TouchCancel:(id)sender{
    if ([sender isKindOfClass:[UISlider class]]) {
        NSLog(@"bingo");
    }
}

#pragma need change 埋点textfield事件
-(void)GQ_startEditing:(UITextField*)textField{
    NSString *tfName = textField.placeholder?[NSString stringWithFormat:@"%@_%@",NSStringFromClass([textField.viewController class]),textField.placeholder]:[NSString stringWithFormat:@"%@_%@",[textField.viewController class],textField.className];
    [[GQLogManager instance] TextFieldBeginEditing:tfName];
}

-(void)GQ_endEditing:(UITextField*)textField{
    [[GQLogManager instance] TextFieldEndEditing];
}

-(void)GQ_textFieldEditing:(UITextField*)textField{
    [[GQLogManager instance] TextFieldChangedWithText:textField.text];
}

- (void)aop_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if ([NSStringFromSelector(action) isEqualToString:@"GQ_TouchCancel:"]) {
        if ([self isKindOfClass:[UISlider class]]){
            UISlider *sl = (UISlider*)self;
            NSString *viewPath = [self viewPath];
            [[GQLogManager instance] SliderValueChangeWithName:viewPath Value:sl.value];
            NSLog(@"%@",NSStringFromSelector(action));
        }
        return;
    }
    if (([self isKindOfClass:NSClassFromString(@"UITabBarButton")] && [NSStringFromSelector(action) isEqualToString:@"_sendAction:withEvent:"])) {
        NSString *viewPath = [self viewPath];
        [[GQLogManager instance] ButtonPressWithName:viewPath];
        NSLog(@"UIControl-------%@-%@\n|||viewPath - %@|||", NSStringFromSelector(action), [target description], viewPath);
    }
    else if ([self isKindOfClass:[UIButton class]]){
        NSString *viewPath = [self viewPath];
        if (NSDate.date.timeIntervalSince1970 - self.aop_acceptEventTime < self.aop_acceptEventInterval) {
            self.aop_acceptEventTime = NSDate.date.timeIntervalSince1970;
            return;
        }
        
        if (self.aop_acceptEventInterval > 0) {
            self.aop_acceptEventTime = NSDate.date.timeIntervalSince1970;
        }
        UIButton* btn = (UIButton*)self;
        NSString *btnName = btn.currentTitle?[NSString stringWithFormat:@"%@_%@",NSStringFromClass([btn.viewController class]),btn.currentTitle]:[NSString stringWithFormat:@"%@_%@_%@",[btn.viewController class],btn.className, NSStringFromSelector(action)];
        [[GQLogManager instance] ButtonPressWithName:btnName];
        NSLog(@"UIButton---%@----%@-%@|||viewPath - %@|||", btnName, NSStringFromSelector(action), [target description], viewPath);
    }
    else if ([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]]) {
//        UITextField *tf = (UITextField *)self;
        
    }
    else if ([self isKindOfClass:[UISwitch class]]) {
        UISwitch *sw = (UISwitch *)self;
        NSString *viewPath = [self viewPath];
        [[GQLogManager instance] SwitchChangedWithName:viewPath Value:sw.isOn];
        NSLog(@"UISwitch---%@----%@|||viewPath - %@|||", NSStringFromSelector(action), [NSNumber numberWithBool:sw.isOn], viewPath);
    }
    [self aop_sendAction:action to:target forEvent:event];
}

@end

@implementation UIScrollView (AOP)

//+ (void)load {
//    Method originalMtd = class_getInstanceMethod([self class], @selector(setDelegate:));
//    Method swizzleMtd = class_getInstanceMethod([self class], @selector(aop_setScrollviewDelegate:));
//    method_exchangeImplementations(originalMtd, swizzleMtd);
//}
//
//- (void)aop_setScrollviewDelegate:(id)delegate {
//    if (!delegate) {
//        [self aop_setScrollviewDelegate:delegate];
//        return;
//    }
//
//    Method originalMtd = class_getInstanceMethod([delegate class], @selector(scrollViewWillBeginDragging:));
//    SEL sel = @selector(aop_scrollViewWillBeginDragging:);
//    Method func = class_getInstanceMethod([self class], sel);
//    IMP imp = method_getImplementation(func);
//    const char *types = method_getTypeEncoding(func);
//
//    if (class_addMethod([delegate class], sel, imp, types)) {
//        Method swizzleMtd = class_getInstanceMethod([delegate class], @selector(aop_scrollViewWillBeginDragging:));
//        method_exchangeImplementations(originalMtd, swizzleMtd);
//    }
//
//
//    Method originalMtd1 = class_getInstanceMethod([delegate class], @selector(scrollViewDidEndDragging:willDecelerate:));
//    SEL scrSel = @selector(aop_scrollViewDidEndDragging:willDecelerate:);
//    Method scrFunc = class_getInstanceMethod([self class], scrSel);
//    IMP scrImp = method_getImplementation(scrFunc);
//    const char *scrTypes = method_getTypeEncoding(scrFunc);
//
//    if (class_addMethod([delegate class], scrSel, scrImp, scrTypes)) {
//        Method swizzleMtd1 = class_getInstanceMethod([delegate class], @selector(aop_scrollViewDidEndDragging:willDecelerate:));
//        method_exchangeImplementations(originalMtd1, swizzleMtd1);
//    }
//    [self aop_setScrollviewDelegate:delegate];
//
//}
//
//- (void)aop_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollView-------%@", NSStringFromCGPoint(scrollView.contentOffset));
//    NSString* name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromClass([scrollView class])];
//    [[GQLogManager instance] scrollViewStartDraggingWithName:name :scrollView.contentOffset.x :scrollView.contentOffset.y];
//    [self aop_scrollViewWillBeginDragging:scrollView];
//}
//
//- (void)aop_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"scrollView-------%@", NSStringFromCGPoint(scrollView.contentOffset));
//    [[GQLogManager instance] scrollViewEndDragging:scrollView.contentOffset.x :scrollView.contentOffset.y];
//    [self aop_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
//
//}

@end

@implementation UICollectionView (AOP)

+ (void)load {
    Method originalMtd = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method swizzleMtd = class_getInstanceMethod([self class], @selector(aop_setDelegate:));
    method_exchangeImplementations(originalMtd, swizzleMtd);
}

- (void)aop_setDelegate:(id)delegate {
//    if (!delegate) {
//        [self aop_setScrollviewDelegate:delegate];
//        return;
//    }
    [self aop_setDelegate:delegate];
    
//    if (!([delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]||[delegate respondsToSelector:@selector(aop_scrollViewDidEndDragging:willDecelerate:)])) {
//        NSAssert(NO, @"为了埋点😆，添加一下scrollViewDidScroll代理");
//    }
    
    Method originalMtd = class_getInstanceMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:));
    SEL sel = @selector(aop_collectionView:didSelectItemAtIndexPath:);
    Method func = class_getInstanceMethod([UICollectionView class], sel);
    IMP imp = method_getImplementation(func);
    const char *types = method_getTypeEncoding(func);
    
    if (class_addMethod([delegate class], sel, imp, types)) {
        Method swizzleMtd = class_getInstanceMethod([delegate class], @selector(aop_collectionView:didSelectItemAtIndexPath:));
        method_exchangeImplementations(originalMtd, swizzleMtd);
    }
    
}

- (void)aop_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    NSLog(@"UICollectionView-------%@", [collectionView description]);
    NSArray* cellArray = (NSArray*)[collectionView visibleCells];
    UICollectionViewCell* cell;
    if ([cellArray count]>0) {
        cell = cellArray[0];
    }else return;
    
    NSLog(@"%@",NSStringFromClass([cell class]));
    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexPath).section,((NSIndexPath *)indexPath).row]];
    [self aop_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

@end

@implementation UITableView (AOP)

+ (void)load {
    Method originalMtd = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method swizzleMtd = class_getInstanceMethod([self class], @selector(aop_setDelegate:));
    method_exchangeImplementations(originalMtd, swizzleMtd);
}

- (void)aop_setDelegate:(id)delegate {
//    if (!delegate) {
//        [self aop_setScrollviewDelegate:delegate];
//        return;
//    }
    [self aop_setDelegate:delegate];
    
//    if (!([delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]||[delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])) {
//        NSAssert(NO, @"为了埋点😆，添加一下scrollViewDidScroll代理");
//    }
    
    Method originalMtd = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
    SEL sel = @selector(aop_tableView:didSelectRowAtIndexPath:);
    Method func = class_getInstanceMethod([UITableView class], sel);
    IMP imp = method_getImplementation(func);
    const char *types = method_getTypeEncoding(func);
    
    if (class_addMethod([delegate class], sel, imp, types)) {
        Method swizzleMtd = class_getInstanceMethod([delegate class], @selector(aop_tableView:didSelectRowAtIndexPath:));
        method_exchangeImplementations(originalMtd, swizzleMtd);
    }
}

- (void)aop_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"UITableView-------%@", [tableView description]);
    NSArray* cellArray = (NSArray*)[tableView visibleCells];
    UICollectionViewCell* cell;
    if ([cellArray count]>0) {
        cell = cellArray[0];
    }else return;
    
    NSString *cellId = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([cell.viewController class]),NSStringFromClass([cell class])];
    [[GQLogManager instance] SelectCellWithName:cellId IndexPath:[NSString stringWithFormat:@"%ld_%ld",((NSIndexPath *)indexPath).section,((NSIndexPath *)indexPath).row]];
    [self aop_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
