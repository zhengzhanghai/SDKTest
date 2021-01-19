//
//  FileDownloadingCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/1.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFFileModel.h"
#import "ZFHttpRequest.h"

@interface FileDownloadingCell : UITableViewCell

@property (strong, nonatomic) ZFHttpRequest *downingRequest;
@property (strong, nonatomic) ZFFileModel *fileInfo;
@property (copy, nonatomic)   void(^clickDownloadBtnBlock)();

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
