//
//  UIImage+extension.h
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)


/**
 图片拉伸

 @param edgeInsets 上左下右
 @return UIImage
 */

-(UIImage*_Nullable)imageStretch:(UIEdgeInsets)edgeInsets;

/**
 图片缩放

 @param size 缩放大小
 @return 缩放后的image
 */
-(UIImage*_Nullable)imageZoom:(CGSize)size;

/**
 图片压缩
 
 @return 缩放后的image
 */
-(UIImage*_Nullable)imageZip;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *_Nullable)imageInRect:(CGRect)rect;

/**
 引导页图片适配  查看NewFeature

 @param imageName @"new_features_%d"
 @return 返回对应尺寸图片
 */
+(UIImage*_Nullable)AutorImage:(NSString*_Nullable)imageName;


/**
 固定高度求宽的比率

 @return 比率
 */
-(CGFloat)FixedHeightRate;
-(CGFloat)FixedWidethRate;


//保持原来的长宽比，生成一个缩略图
+ (UIImage *_Nullable)thumbnailWithImageWithoutScale:(UIImage *_Nullable)image size:(CGSize)asize;
//content
+ (UIImage *_Nullable)contentFileWithName:(NSString *_Nullable)fileName Type:(NSString *_Nullable)type;
//返回一张自由拉伸的图片
+(UIImage *_Nullable)resizedImageWithName:(NSString *_Nullable)name;
//返回一张自由调整大小的图片
+(UIImage *_Nullable)newImageWithNamed:(NSString *_Nullable)name size:(CGSize)size;
///改变一张图片的大小
+ (UIImage *_Nullable)changeImageSize:(UIImage *_Nullable)icon AndSize:(CGSize)size;
+ (UIImage *_Nullable)imageWithOriginal:(NSString *_Nullable)imageName;
+ (UIImage *_Nullable)resizedImage:(NSString *_Nullable)name;
//根据颜色值生成纯色图片
+ (UIImage *_Nullable)createImageWithColor:(UIColor *_Nullable)color frame:(CGRect)frame;
//原图输出
+ (UIImage *_Nullable)imageWithName:(NSString *_Nullable)name size:(CGSize)size;
///压缩
+ (UIImage*_Nullable)imageWithImageSimple:(UIImage*_Nullable)image scaledToSize:(CGSize)newSize;
+ (UIImage *_Nullable)createThumbImage:(UIImage *_Nullable)image size:(CGSize )thumbSize;
/**
 *  高斯模糊
 *
 *  @param view   view
 *  @param radius radius
 *  @param size   size
 *
 *  @return image
 */
+ (UIImage*_Nullable)imageWithView:(UIView*_Nullable)view radius:(CGFloat)radius size:(CGSize)size;

+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nullable)color;

+ (UIImage *_Nullable)qrCodeImageWithContent:(NSString *_Nullable)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *_Nullable)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;

+ (UIImage *_Nullable)getTheLaunchImage;
+ (UIImage*_Nullable)imageWithUIView:(UIView*_Nullable)view;
- (UIImage *_Nullable)imageWithTitle:(NSString *_Nullable)title fontSize:(CGFloat)fontSize;
+ (CGSize)getImageSizeWithURL:(id _Nullable)URL;

/**
 将图片进行圆形切割处理，默认无边框(PS:此操作是线程安全的)。
 @param scaleSize 图片将会缩放成的目标大小
 @return 返回处理之后的图片
 */
- (nullable UIImage *)dd_imageByRoundScaleSize:(CGSize)scaleSize;

/**
 将图片进行圆角处理，并加上边框(PS:此操作是线程安全的)。
 @param radius 圆角大小
 @param scaleSize 图片将会缩放成的目标大小
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param corners 图片圆角样式（UIRectCorner）
 @return 返回处理之后的图片
 */
- (nullable UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                                   scaleSize:(CGSize)scaleSize
                                 borderWidth:(CGFloat)borderWidth
                                 borderColor:(nullable UIColor *)borderColor
                                     corners:(UIRectCorner)corners;

/**
 图片加上圆形边框，图片必须得是正方形的，否则直接返回未加边框的原图片(PS:此操作是线程安全的)
 @param color 边框颜色
 @param width 边框宽度
 @return 返回处理之后的图片
 */
- (nullable UIImage *)dd_imageByRoundBorderedColor:(nullable UIColor *)color
                                       borderWidth:(CGFloat)width;

/**
 创建一张纯色的圆形图片
 @param color 图片填充的颜色
 @param size 图片的大小
 @return 返回纯色的圆形图片
 */
+ (nullable UIImage *)dd_roundImageWithColor:(nullable UIColor *)color
                                        size:(CGSize)size;

/**
 图片加上边框 (PS:此操作是线程安全的)
 @param radius 圆角大小
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param corners 图片圆角样式（UIRectCorner）
 @return 返回处理之后的图片
 */
- (nullable UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                               borderedColor:(nullable UIColor *)borderColor
                                 borderWidth:(CGFloat)borderWidth
                                     corners:(UIRectCorner)corners;

/**
 将图片指定圆角样式处理，并加上边框(PS:此操作是线程安全的)。
 @param radius 圆角大小
 @param corners 图片圆角样式（UIRectCorner）
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 返回处理之后的图片
 */
- (nullable UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                                     corners:(UIRectCorner)corners
                                 borderWidth:(CGFloat)borderWidth
                                 borderColor:(nullable UIColor *)borderColor;

@end
