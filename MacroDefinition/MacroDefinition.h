//
//  MacroDefinition.h
//  项目整理
//
//  Created by shengtian on 2017/6/22.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

#import <objc/runtime.h>

//安全区域
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

/**
 给系统方法添加东西 *****切记要交换回来******
 eg:
 - (void)aop_viewWillAppear:(BOOL)animation
 {
 [self aop_viewWillAppear:animation];
 }
 @param class 类名
 @param originalSelector 要交换的系统方法
 @param swizzledSwlector 自己的方法
 @return void
 */
#define swizzleMethod(class,originalSelector,swizzledSwlector)\
{\
    Method  originalMethod = class_getInstanceMethod(class , originalSelector);\
    Method  swizzledMethod = class_getInstanceMethod(class , swizzledSwlector);\
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));\
    if (didAddMethod) {\
        class_replaceMethod(class, swizzledSwlector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));\
    }else{\
        method_exchangeImplementations(originalMethod, swizzledMethod);\
    }\
}

//状态栏高度
#define statusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define NavgationHeight CGRectGetMaxY(self.navigationController.navigationBar.frame)
//tabbar高度
#define tabBarHeight CGRectGetHeight(self.tabBarController.tabBar.frame)
/**
 禁止scrollView自动调节位置 兼容ios11
 */
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

// 判断是否高清屏
#define isRetina ([UIScreen instancesRespondToSelector:@selector(scale)] ? (2 == [[UIScreen mainScreen] scale]) : NO)

#define SINGLE_LINE_HEIGHT           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

/**
 debug版本输出查看信息
 */
#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

/**
 放在dealloc里面 打印界面是否被释放
 */

#ifdef DEBUG
#define chackMemory [MBProgressHUD showTitleToView:[UIApplication sharedApplication].keyWindow contentStyle:NHHUDContentBlackStyle title:@"dealloc" afterDelay:2];;
#else
#define chackMemory
#endif

/**
 版本号
 */
#define VersionNumber [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 NavBar高度
 */
#define NavigationBar_HEIGHT 64

/**
 tabbar高度
 */
#define Tabbar_HEIGHT 49

/**
 这个View的宽高
 */
#define This_View_Height   self.frame.size.height
#define This_View_Width    self.frame.size.width
/**
 屏幕的宽高和大小
 */
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenBounds [UIScreen mainScreen].bounds
/**
 沙河路径
 */
#define DocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
/**
 UserDefault
 */
#define UserDefault [NSUserDefaults standardUserDefaults]
/**
 强弱引用
 */
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define STRONGSELF(weakSelf) __strong __typeof(&*weakSelf) self = weakSelf;
/**
 16进制颜色以及透明度
 */
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]

/**
 RGB颜色以及透明度
 */
#define RGBCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/**
 定义UIImage对象
 */
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］

/**
 字符串是否为空
 */
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? NO : YES )

/**
 数组是否为空
 */
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 字典是否为空
 */
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 是否是空对象
 */
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/**
 系统版本号
 */
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#define versionKey  (NSString *)kCFBundleVersionKey
#define oldVersion [[NSUserDefaults standardUserDefaults] objectForKey:versionKey]
#define newVersion [NSBundle mainBundle].infoDictionary[versionKey]
#define showNewFeature  ![oldVersion isEqualToString:newVersion]
#endif /* MacroDefinition_h */

