//
//  UIImage+Round.m
//  制作图片---分类
//
//  Created by 王亮龙1 on 16/3/29.
//  Copyright © 2016年 lianglong. All rights reserved.
//

#import "UIImage+Round.h"

@implementation UIImage (Round)

+ (UIImage *)getRoundImageWithName:(NSString *)name {
    
    //获取图片
    UIImage *oldImage = [UIImage imageNamed:name];
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(oldImage.size, NO, 0);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制路径
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, oldImage.size.width, oldImage.size.height));
    //裁切
    CGContextClip(ctx);
    //绘制图片
    [oldImage drawAtPoint:CGPointMake(0, 0)];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();

    
    return newImage;
}



////   MARK: 制作圆形图片类方法
//extension UIImage{
//class func getRoundImageWithName(name:String ) -> UIImage{
//    //获取图片
//    let oldImage:UIImage = UIImage.init(named: name)!
//    //开启上下文
//    UIGraphicsBeginImageContextWithOptions(oldImage.size, false, 0);
//    //获取上下文
//    let ctx:CGContextRef = UIGraphicsGetCurrentContext()!;
//    //绘制路径
//    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, oldImage.size.width, oldImage.size.height));
//    //裁切
//    CGContextClip(ctx);
//    //绘制图片
//    oldImage.drawAtPoint(CGPointMake(0, 0))
//    //获取图片
//    let newImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭上下文
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}
//}
@end
