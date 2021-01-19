//
//  NSString+CustomString.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "NSString+CustomString.h"

@implementation NSString (CustomString)

////获取字符串的宽度
//-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
//{
//    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
//    return sizeToFit.width;
//}
////获得字符串的高度
//-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
//{
//    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
//    return sizeToFit.height;
//}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}


@end
