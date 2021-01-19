//
//  FileDetailViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "FileListModel.h"

@interface FileDetailViewController : BaseViewController

@property(nonatomic,strong) FileListModel *model; //将文件模型传送过来，获取url和文件名
@property(nonatomic,copy) NSString *url;

@end
