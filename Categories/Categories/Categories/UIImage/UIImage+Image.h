//
//  UIImage+Image.h
//  
//
//  Created by yz on 15/7/6.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)


// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  生成一张不被渲染的图片
 */
+ (UIImage *)imageForOriginalWithName:(NSString *)name;

/**
 *  生成一张50%拉伸保护的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)imageName;

/**
 *  设置图片的拉伸比例 
 */
+ (UIImage *)resizedImageWithName:(NSString *)imageName width:(CGFloat)width height:(CGFloat)height;

@end
