//
//  FileDownloadedCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/1.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFFileModel.h"

@interface FileDownloadedCell : UITableViewCell

@property (strong, nonatomic) ZFFileModel *fileInfo;

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
