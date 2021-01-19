//
//  NSString+CustomString.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (CustomString)

//// MARK: - 获取字符串宽
//-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//// MARK: - 获取字符串高
//-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;


//// MARK: - 获取字符串高
- (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
//// MARK: - 获取字符串宽
- (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;
@end
