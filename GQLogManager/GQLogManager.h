//
//  GQLogManager.h
//  GQ_****
//
//  Created by Madodg on 2017/12/13.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogModel.h"

typedef void(^available)(NSString* netType);

@interface GQLogManager : NSObject

//登陆后需要设置此id
@property(nonatomic,copy) NSString* userID;
@property(nonatomic,copy) NSString* userName;
@property(nonatomic,copy) NSString* phoneNumber;
@property(nonatomic,copy) NSString* deviceType;
@property(nonatomic,copy) NSString* logServiceUrl;
@property(nonatomic,copy) NSString* fileType;

@property(nonatomic,assign) float pointX;
@property(nonatomic,assign) float pointY;
@property(nonatomic,copy) NSString* scrollName;

@property(nonatomic,strong) NSMutableDictionary* userAction;

@property(nonatomic,strong) NSMutableArray* timeline;

//@property(nonatomic,strong) NSMutableDictionary* textFieldAction;
//@property(nonatomic,strong) NSMutableArray* textFieldActionArray;
@property(nonatomic,strong) LogModel* logModel;

@property(nonatomic,copy) NSString* fileName;

@property(nonatomic,copy) NSString* currentZipPath;
@property(nonatomic,copy) NSString* currentLogPath;

@property(nonatomic,assign) BOOL immediately;

+ (GQLogManager*)instance;


/**
 检查网络状态

 @param netWork 网络类型
 */
+ (void)checkNetWorlk:(available)netWork;

//获取当前时间cuo
+(NSString*)stringWithCurrentTime;

/**
 开启日志服务 创建userAction 并且写入头信息
 */
- (void)LogStartWithURL:(NSString*)url FileType:(NSString*)type keyInformation:(NSDictionary*)Information;

- (void)LogEnd;

/**
 记录程序变为活跃状态
 */
- (void)BecomeActive;

/**
 记录程序进入后台
 并保存文件 userAction
 */
- (void)EnterBackground;


/**
 记录显示的viewcontroller

 @param name VC 的名字
 */
- (void)showVCWithName:(NSString*)name;

/**
 记录取消的viewcontroller
 
 @param name VC 的名字
 */
- (void)dismissVCWithName:(NSString*)name;


/**
 buttonPress 

 @param name 按钮的名字
 */
- (void)ButtonPressWithName:(NSString*)name;


/**
 SwitchChanged

 @param name 控件名字
 @param value bool值
 */
- (void)SwitchChangedWithName:(NSString*)name Value:(BOOL)value;


/**
 slider值的改变

 */
- (void)SliderValueChangeWithName:(NSString*)name Value:(CGFloat)value;


/**
 web点击统计

 @param name 名字
 */
- (void)WebViewMessageWithName:(NSString*)name;

/**
 推送消息获取

 @param message 消息
 */
- (void)GetNotification:(NSDictionary*)message;


/**
 textField记录 编辑开始创建对象  结束时写入userAction 从新开始时  从新创建对象

 @param name textField的名字
 */
- (void)TextFieldBeginEditing:(NSString*)name;
- (void)TextFieldChangedWithText:(NSString*)text;
- (void)TextFieldEndEditing;

/**
 记录scrollView的开始拖拽和起始坐标

 @param name 名字
 @param x pointX
 @param y pointY
 */
- (void)scrollViewStartDraggingWithName:(NSString*)name :(float)x :(float)y;


/**
 scrollView 停止拖拽  及时写入userAction

 @param x pointX
 @param y pointY
 */
- (void)scrollViewEndDragging:(float)x :(float)y;


/**
 cell的点击

 @param name tableview的名字
 @param indexPatch 点击的indexpatch
 */
- (void)SelectCellWithName:(NSString*)name IndexPath:(NSString*)indexPatch;


/**
 网络请求错误

 @param url 请求的url
 @param parameter 参数
 @param message 返回消息
 @param error 错误消息
 */
- (void)RequestErrorWithUrl:(NSString*)url Parameter:(NSDictionary*)parameter Message:(NSString*)message Error:(NSError*)error;


/**
 保存用户行为
 id为当前时间戳
 主要用于手动写入文件 崩溃
 */
- (void)SaveCrash:(NSArray*)crash;

@end
