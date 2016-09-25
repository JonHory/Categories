//
//  UIImage+QRCode.h
//  QRCode二维码
//
//  Created by LeungChaos on 16/9/8.
//  Copyright © 2016年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

- (UIImage*)imageToTransparentRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/* 黑白的二维码图片 */
+ (UIImage *)creatQRCodeImageWithString:(NSString *)string;

/* 修改完前景色的二维码图片 */
+ (UIImage *)creatQRCodeImageWithString:(NSString *)string foregroundColorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/* 给图片添加前景图片 */
- (UIImage *)addForegroundImage:(UIImage *)fgImage;

@end
