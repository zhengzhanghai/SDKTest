//
//  FileDownloadedCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/1.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FileDownloadedCell.h"
#import "ZFCommonHelper.h"

@interface FileDownloadedCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end

@implementation FileDownloadedCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *registerKey = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:registerKey bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:registerKey];
    return [tableView dequeueReusableCellWithIdentifier:registerKey];
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    _icon.image = fileInfo.fileimage;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    _fileNameLabel.text = fileInfo.fileName;
    _fileSizeLabel.text = totalSize;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
