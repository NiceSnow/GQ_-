//
//  Tools.h
//  GQ_****
//
//  Created by Madodg on 2017/12/1.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
//设置返回按钮back
+(UIBarButtonItem *_Nonnull)getBarButtonItemWithTarget:(nullable id)target action:(SEL _Nullable )action;

+ (CGFloat)getHeightWithText:(NSString *_Nonnull)text withFontFloat:(CGFloat)fontFloat andWidth:(CGFloat)width;

/**
 生成后面固定长度的不同字体大小字符串
 
 @param needText 字符串
 @param count 后面个数
 @return 字符串
 */
+(NSMutableAttributedString*_Nullable) changeLabelWithText:(NSString*_Nullable)needText lastConut:(NSInteger)count;

//根据文字生成 文字图片
+ (UIImage *_Nullable)getImage:(NSString *_Nullable)name size:(CGSize)size font:(UIFont *_Nonnull)font  backgroundColor:(UIColor *_Nullable)color textColor:(UIColor *_Nullable)textColor;
//随机颜色
+ (UIColor *_Nullable)randomColor;
//把文字绘制到图片上
+ (UIImage *_Nullable)imageToAddText:(UIImage *_Nonnull)img withText:(NSString *_Nullable)text font:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)textColor;

//根据UIColor生成图片
+ (UIImage *_Nullable) ImageWithColor: (UIColor *_Nonnull) color frame:(CGRect)aFrame;
//生成颜色不同的 string
+ (NSMutableAttributedString *_Nullable)labelWithText:(NSString *_Nullable)text font:(UIFont *_Nullable)font range:(NSRange)range color:(UIColor *_Nullable)color;
//将数字字符串变成科学计数法字符串
+ (NSString *_Nullable)formartScientificNotationWithString:(NSString *_Nullable)str;

/**
 生成指定大小的image
 
 @param size 大小
 @return image
 */

+ (UIImage *_Nullable)createNonInterpolatedUIImageFormCIImage:(CIImage *_Nullable)image withSize:(CGFloat) size;
//获取当前页面VC
+(UIViewController*_Nullable)getCurrentVC;
/**
 *  加密方法
 *
 *  @param str   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *_Nullable)encryptString:(NSString *_Nullable)str publicKeyWithContentsOfFile:(NSString *_Nullable)path;

/**
 *  解密方法
 *
 *  @param str       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *_Nonnull)decryptString:(NSString *_Nullable)str privateKeyWithContentsOfFile:(NSString *_Nullable)path password:(NSString *_Nullable)password;

/**
 *  加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *_Nullable)encryptString:(NSString *_Nonnull)str publicKey:(NSString *_Nullable)pubKey;

/**
 *  解密方法
 *
 *  @param str     需要解密的字符串
 *  @param privKey 私钥字符串
 */
+ (NSString *_Nonnull)decryptString:(NSString *_Nullable)str privateKey:(NSString *_Nonnull)privKey;
@end
