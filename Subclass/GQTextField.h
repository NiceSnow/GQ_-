//
//  GQTextField.h
//  GQ_****
//
//  Created by Madodg on 2018/1/9.
//  Copyright © 2018年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GQTextFieldType){
    GQTextFieldTypeAny = 0,        //没有限制
    GQTextFieldTypeOnlyUnsignInt,  //只允许非负整型
    GQTextFieldTypeOnlyInt,        //只允许整型输入
    GQTextFieldTypeForbidEmoj,     //禁止Emoj表情输入
};

typedef NS_ENUM(NSUInteger, GQTextFieldEvent){
    GQTextFieldEventBegin,         //准备输入文字
    GQTextFieldEventInputChar,     //准备输入字符
    GQTextFieldEventFinish         //输入完成
};

@interface GQTextField : UITextField

/**
 *  如果按了return需要让键盘收起
 */
@property(nonatomic,assign) BOOL isResignKeyboardWhenTapReturn;
/**
 *  输入类型
 */
@property(nonatomic,assign) GQTextFieldType inputType;

/**
 *  最大字符数
 */
@property(nonatomic,assign) NSInteger maxLength;

/**
 *  最大字节数
 */
@property(nonatomic,assign) NSInteger maxBytesLength;
/**
 *  左间距
 */
@property (nonatomic, assign) BOOL isAutoSpaceInLeft;
/**
 *  中文联想，字符改变的整个字符串回调
 */
@property (nonatomic,copy) void (^textFieldChange)(GQTextField *textField, NSString *string);
/**
 *  成功输入一个字符的回调
 */
@property (nonatomic,copy) void (^inputCharacter)(GQTextField *textField, NSString *string);

/**
 *  控件状态变化的事件回调
 */
@property (nonatomic,copy) void (^notifyEvent)(GQTextField *textField, GQTextFieldEvent event);

@end
