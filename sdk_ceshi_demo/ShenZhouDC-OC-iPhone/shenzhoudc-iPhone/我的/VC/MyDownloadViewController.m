//
//  MyDownloadViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyDownloadViewController.h"
#import "MyDownloadCell.h"
#import "MyAudioViewController.h"
#import "ZXVideo.h"

@interface MyDownloadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allVideosArray;
@end

@implementation MyDownloadViewController
- (NSMutableArray *)allVideosArray {
    if (!_allVideosArray) {
        _allVideosArray = [NSMutableArray array];
    }
    return _allVideosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的下载";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDownloadCell" bundle:nil] forCellReuseIdentifier:@"MyDownloadCell"];
    [self.view addSubview:self.tableView];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = @"http://flv2.bn.netease.com/videolib3/1701/19/uqpDz1203/HD/uqpDz1203-mobile.mp4";
    NSURL *videoURL = [NSURL URLWithString:url];
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = videoURL.absoluteString;
    video.title = @"Test";
    
    MyAudioViewController *vc = [[MyAudioViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {

//        [self.allVideosArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
@end
