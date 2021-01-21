//
//  ZHHelper.h
//  ZHTestSDK
//
//  Created by 郑章海 on 2020/5/25.
//  Copyright © 2020 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 获取资源路径
#define ResourcePath(name, type) [[ZHHelper shared] resourcePathWithName:name ofType:type]

NS_ASSUME_NONNULL_BEGIN

@interface ZHHelper : NSObject

/// 单例
+ (instancetype)shared;

/// 通过资源名获取资源路径
/// @param name 资源名称
/// @param type 资源类型
- (NSString *)resourcePathWithName:(NSString *)name ofType:(NSString *)type;

- (UIImage *)imageWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
