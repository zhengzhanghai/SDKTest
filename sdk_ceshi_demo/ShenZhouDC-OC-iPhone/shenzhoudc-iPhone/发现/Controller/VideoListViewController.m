//
//  VideoListViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoPlayViewController.h"
#import "VideoCell.h"
#import "VideoModel.h"
#import "ChanPinDetailsWEBController.h"

@interface VideoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *videoList;//所有视频模型数组
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation VideoListViewController
-(NSMutableArray *)videoList {
    if (!_videoList) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频中心";
    self.view.backgroundColor = [UIColor  whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self getAllVideoInfoRequest];
  
    self.dataSource = [NSMutableArray array];
    NSArray *arr = @[@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                        @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                        @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                        @"http://baobab.wdjcdn.com/14525705791193.mp4",
                        @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                        @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                        @"http://baobab.wdjcdn.com/14564977406580.mp4",
                        @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                        @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                        @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                        @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                        @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                        @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                        @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                        @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    self.dataSource = [NSMutableArray arrayWithArray:arr];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [VideoCell VideoCell:tableView indexPath:indexPath];

    [cell refreshFileListCellWithModel:self.videoList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *model = self.videoList[indexPath.row];
    VideoPlayViewController *vc = [[VideoPlayViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.videoURL = model.dataUrl;
    vc.titleTxt = model.dataTitle;
    [self.navigationController pushViewController:vc animated:YES];
    
//    ChanPinDetailsWEBController *vc = [[ChanPinDetailsWEBController alloc]init];
//    VideoModel *model = self.videoList[indexPath.row];
//    vc.loadURLString = model.dataUrl;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


//网络请求=======
- (void)getAllVideoInfoRequest {
    NSString *url = [NSString stringWithFormat:@"%@%@%d", DOMAIN_NAME,API_GETFILETYPE, 2];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSDictionary *dict = [result getDataObj];
                NSArray *array = dict[@"data"];
                for (int i = 0; i < array.count; i++) {
                    VideoModel *model = [VideoModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.videoList = list;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
    
}



@end
