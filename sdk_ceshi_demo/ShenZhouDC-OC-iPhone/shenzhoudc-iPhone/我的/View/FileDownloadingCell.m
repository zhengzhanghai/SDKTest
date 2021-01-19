//
//  FileDownloadingCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/1.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FileDownloadingCell.h"
#import "ZFDownloadManager.h"

@interface FileDownloadingCell()
@property (weak, nonatomic) IBOutlet UIButton *pasuBtn;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downProgress;
@property (weak, nonatomic) IBOutlet UILabel *downProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation FileDownloadingCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *registerKey = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:registerKey bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:registerKey];
    return [tableView dequeueReusableCellWithIdentifier:registerKey];
}

- (IBAction)clickBtn:(UIButton *)sender {
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = [_downingRequest.userInfo objectForKey:@"File"];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        _pasuBtn.selected = YES;
        [ZF_MANAGER stopRequest:_downingRequest];
    } else {
        _pasuBtn.selected = NO;
        [ZF_MANAGER resumeRequest:_downingRequest];
    }
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (_clickDownloadBtnBlock) {
        _clickDownloadBtnBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setDowningRequest:(ZFHttpRequest *)downingRequest {
    _downingRequest = downingRequest;
    [self setFileInfo:[_downingRequest.userInfo objectForKey:@"File"]];
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    _fileNameLabel.text = _fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([_fileInfo.fileSize longLongValue] == 0 && !(_fileInfo.downloadState == ZFDownloading)) {
        _downProgressLabel.text = @"";
        if (_fileInfo.downloadState == ZFStopDownload) {
            _downProgressLabel.text = @"已暂停";
            _pasuBtn.selected = YES;
        } else if (_fileInfo.downloadState == ZFWillDownload) {
            _pasuBtn.selected = YES;
            _downProgressLabel.text = @"等待下载";
        }
        _downProgress.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:_fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:_fileInfo.fileSize];
    // 下载进度
    float progress = (float)[_fileInfo.fileReceivedSize longLongValue] / [_fileInfo.fileSize longLongValue];
    
    _speedLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    _downProgress.progress = progress;
    
    if (_fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@",_fileInfo.speed,_fileInfo.remainingTime];
        _downProgressLabel.text = speed;
    } else {
        _downProgressLabel.text = @"正在获取";
    }
    
    if (_fileInfo.downloadState == ZFDownloading) { //文件正在下载
        _pasuBtn.selected = NO;
    } else if (_fileInfo.downloadState == ZFStopDownload&&!_fileInfo.error) {
        _pasuBtn.selected = YES;
        _downProgressLabel.text = @"已暂停";
    }else if (_fileInfo.downloadState == ZFWillDownload&&!_fileInfo.error) {
        _pasuBtn.selected = YES;
        _downProgressLabel.text = @"等待下载";
    } else if (_fileInfo.error) {
        _pasuBtn.selected = YES;
        _downProgressLabel.text = @"错误";
    }
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
