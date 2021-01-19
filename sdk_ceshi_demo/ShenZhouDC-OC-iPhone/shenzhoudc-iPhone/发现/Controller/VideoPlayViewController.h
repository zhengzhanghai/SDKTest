//
//  VideoPlayViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController.h"
#import "VideoModel.h"

@interface VideoPlayViewController : BaseViewController
@property(nonatomic,strong)     NSString *titleTxt;//标题
@property (nonatomic,copy)      NSURL *videoURL;
@property (copy, nonatomic)     NSString *downloadUrlStr;
@property (copy, nonatomic)     NSString *downloadIcon; // 下载时要用到的小图标
@end
