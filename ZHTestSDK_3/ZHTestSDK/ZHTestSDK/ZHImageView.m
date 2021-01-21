//
//  ZHImageView.m
//  ZHTestSDK
//
//  Created by 郑章海 on 2020/5/22.
//  Copyright © 2020 zzh. All rights reserved.
//

#import "ZHImageView.h"
#import "ZHHelper.h"
@import SDWebImage;

@implementation ZHImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

/// 设置本地图片(从bundle取图片)
- (void)setLocalImage {
//    NSString *path = ResourcePath(@"123@2x.png", @"");
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    self.image = image;
    self.image = [[ZHHelper shared] imageWithName:@"123"];
}

@end
