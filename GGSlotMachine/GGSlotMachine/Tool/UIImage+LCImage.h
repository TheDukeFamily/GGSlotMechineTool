//
//  UIImage+LCImage.h
//  LCLuckyCoffee
//
//  Created by Mac on 2016/10/26.
//  Copyright © 2016年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LCImage)
// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

/**
 *  根据颜色生成一张图片
 *  color->提供的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 生成文字图片 **/
+ (UIImage *)imageWithTitle:(NSString *)title;
@end
