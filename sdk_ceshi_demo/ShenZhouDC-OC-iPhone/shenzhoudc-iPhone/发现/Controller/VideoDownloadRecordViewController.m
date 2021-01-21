//
//  VideoDownloadRecordViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "VideoDownloadRecordViewController.h"
//#import "VideoPlayViewController.h"
#import "ZFDownloadManager.h"
#import "MeChooseMenuView.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"
#import "FileDownloadedCell.h"
#import "FileDownloadingCell.h"

@interface VideoDownloadRecordViewController ()<ZFDownloadDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView    *tableView;
@property (copy, nonatomic)   NSArray *downloadedArray;
@property (copy, nonatomic)   NSArray *downloadingArray;


/**
 展示类型 0已下载  1下载中
 */
@property (nonatomic, assign) NSInteger showType;

@end

@implementation VideoDownloadRecordViewController

- (void)updateDownloadData
{
    [ZF_MANAGER startLoad];
    _downloadedArray = ZF_MANAGER.finishedlist;
    _downloadingArray = ZF_MANAGER.downinglist;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的下载";
    _showType = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    ZF_MANAGER.downloadDelegate = self;
    [self makeUI];
    [self updateDownloadData];
}

- (void)makeUI {
    MeChooseMenuView *menuView = [[MeChooseMenuView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, 414, 45) titles:@[@"下载完成", @"下载中"]];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOPBARHEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(IS_IPAD ? 55 : 45);
        
    }];
    menuView.clickItemBlock = ^(NSUInteger index) {
        _showType = index;
        [_tableView reloadData];
    };
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[ZFDownloadingCell class] forCellReuseIdentifier:[ZFDownloadingCell reuseIdentifier]];
    [self.tableView registerClass:[ZFDownloadedCell class] forCellReuseIdentifier:[ZFDownloadedCell reuseIdentifier]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(menuView.mas_bottom);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showType == 0) {
        return _downloadedArray.count;
    }
    return _downloadingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_showType == 0) {
        FileDownloadedCell *downedCell = [FileDownloadedCell createCell:tableView indexPath:indexPath];
        ZFFileModel *fileInfo = _downloadedArray[indexPath.row];
        downedCell.fileInfo = fileInfo;
        cell = downedCell;
    } else {
        FileDownloadingCell *downingCell = [FileDownloadingCell createCell:tableView indexPath:indexPath];
        ZFHttpRequest *request = _downloadingArray[indexPath.row];
        downingCell.downingRequest = request;
        __weak typeof(self) weakSelf = self;
        downingCell.clickDownloadBtnBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf updateDownloadData];
        };
        cell = downingCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_showType == 0) {
//        VideoPlayViewController *vc = [[VideoPlayViewController alloc]init];
//        ZFFileModel *fileModel = _downloadedArray[indexPath.row];
//        vc.videoURL = [NSURL fileURLWithPath:FILE_PATH(fileModel.fileSeekName)];
//        vc.titleTxt = fileModel.fileName;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = _downloadedArray[indexPath.row];
        [ZF_MANAGER deleteFinishFile:fileInfo];
    } else if (indexPath.section == 1) {
        ZFHttpRequest *request = _downloadingArray[indexPath.row];
        [ZF_MANAGER deleteRequest:request];
    }
    [self updateDownloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ZFDownloadDelegate

// 开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self updateDownloadData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    if (_showType == 1) {
        NSArray *cellArr = [self.tableView visibleCells];
        for (id obj in cellArr) {
            if([obj isKindOfClass:[FileDownloadingCell class]]) {
                FileDownloadingCell *cell = (FileDownloadingCell *)obj;
                if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                    cell.fileInfo = fileInfo;
                }
            }
        }
    }
}

@end
