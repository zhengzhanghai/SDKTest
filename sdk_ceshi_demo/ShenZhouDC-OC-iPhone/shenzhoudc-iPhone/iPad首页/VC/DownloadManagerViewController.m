//
//  DownloadManagerViewController.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DownloadManagerViewController.h"
//#import "VideoPlayViewController.h"
#import "ZFDownloadManager.h"
#import "FileDownloadedCell.h"
#import "FileDownloadingCell.h"

@interface DownloadManagerViewController ()<ZFDownloadDelegate,UITableViewDataSource,UITableViewDelegate>
@property (copy, nonatomic)   NSArray *downloadedArray;
@property (copy, nonatomic)   NSArray *downloadingArray;
@property (strong, nonatomic) UITableView    *tableView;

@end

@implementation DownloadManagerViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateDownloadData
{
    [ZF_MANAGER startLoad];
    _downloadedArray = ZF_MANAGER.finishedlist;
    _downloadingArray = ZF_MANAGER.downinglist;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的下载";
    self.view.backgroundColor = [UIColor whiteColor];
    ZF_MANAGER.downloadDelegate = self;
    [self initTable];
    [self updateDownloadData];
}
-(void)initTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _downloadedArray.count;
    } else if (section == 1) {
        return _downloadingArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        FileDownloadedCell *downedCell = [FileDownloadedCell createCell:tableView indexPath:indexPath];
        ZFFileModel *fileInfo = _downloadedArray[indexPath.row];
        downedCell.fileInfo = fileInfo;
        cell = downedCell;
    }else if (indexPath.section == 1) {
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
    if (indexPath.section == 0) {
//        VideoPlayViewController *vc = [[VideoPlayViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        ZFFileModel *fileModel = _downloadedArray[indexPath.row];
//        vc.videoURL = fileModel.fileURL;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"下载完成",@"下载中"][section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.f;
    }
    return 80.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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



@end
