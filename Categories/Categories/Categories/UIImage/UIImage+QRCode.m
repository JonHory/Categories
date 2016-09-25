//
//  UIImage+QRCode.m
//  QRCode二维码
//
//  Created by LeungChaos on 16/9/8.
//  Copyright © 2016年 liang. All rights reserved.
//

#import "UIImage+QRCode.h"
#import <CoreImage/CoreImage.h>


static CGFloat ratio = 0.7;

@implementation UIImage (QRCode)

void ProviderReleaseDatacc (void *info, const void *data, size_t size)
{
    free((void*)data);
}


- (UIImage*)imageToTransparentRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    // 分配内存
    const int imageWidth = self.size.width;
    
    const int imageHeight = self.size.height;
    
    size_t      bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
        
    {
        //把绿色变成黑色，把背景色变成透明

        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
            
        {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[0] = 0;
            
        }
        
        else
            
        {
            
            // 改成下面的代码，会将图片转成想要的颜色
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[3] = red; //0~255
            
            ptr[2] = green;
            
            ptr[1] = blue;
            
        }
        
        
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseDatacc);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true,kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
}


+ (UIImage *)creatQRCodeImageWithString:(NSString *)string foregroundColorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [[self creatQRCodeImageWithString:string] imageToTransparentRed:red green:green blue:blue];
}


/* 生成二维码图片 */
+ (UIImage *)creatQRCodeImageWithString:(NSString *)string
{
    // 判断字符串长度是否大于0、
    if (string.length <= 0 ) return nil;
    
    // 创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 给滤镜设置内容(KVC)
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKeyPath:@"inputMessage"];
    
    // 设置容错率
    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
    
    // 获取生成的二维码
    CIImage *outputImage = filter.outputImage;
    if (outputImage == nil) return nil;
    
    // 转成高清图片
    UIImage *hdImage = [self createNonInterpolatedUIImageFormCIImage:outputImage];
    
    return hdImage;
}

// 转换成高清图片
+ (UIImage *)creatHdImage:(CIImage *)cimage ratioForImageWidth:(CGFloat)ratio {
    CGFloat screenw = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat ImageWH = screenw * ratio * scale;
    
    UIImage *tempImage = [UIImage imageWithCIImage:cimage];
    
    CGFloat ratioForHD =  ImageWH / tempImage.size.width;
    
    CGAffineTransform transForm = CGAffineTransformMakeScale(ratioForHD, ratioForHD);
    
    CIImage *newImage = [cimage imageByApplyingTransform:transForm];
    
    return [UIImage imageWithCIImage:newImage];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
{
    CGFloat screenw = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat size = screenw * ratio * screenScale;
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (UIImage *)addForegroundImage:(UIImage *)fgImage
{
    // 开启图片上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 画高清图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGFloat imageWH = self.size.width * 0.3;
    
    CGFloat imageX = (self.size.width - imageWH) * 0.5;
    
    CGFloat imageY = (self.size.height - imageWH) * 0.5;
    
    // 画前进图
    [fgImage drawInRect:CGRectMake(imageX, imageY, imageWH, imageWH)];
    
    // 获得当前上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图像上下文
    UIGraphicsEndImageContext();
    
    // 返回
    return newImage;
}

@end
