//
//  FileListViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/3/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//高90

#import "FileListViewController.h"
#import "FileDetailViewController.h"
#import "FileListCell.h"
#import "VideoModel.h"


@interface FileListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

@end

@implementation FileListViewController
-(NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self getAllVideoInfoRequest];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}
//MARK: 重写父类的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *model = self.dataSourse[indexPath.row];
    FileDetailViewController *vc = [[FileDetailViewController alloc]init];
    vc.url = model.dataUrl;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListCell *cell =[FileListCell FileListCell:tableView indexPath:indexPath];
    VideoModel *model = self.dataSourse[indexPath.row];
    [cell refreshFileListCellWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//网络请求=======
- (void)getAllVideoInfoRequest {
    NSString *url = [NSString stringWithFormat:@"%@%@%d", DOMAIN_NAME,API_GETFILETYPE, 1];
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
                self.dataSourse = list;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
    
}

@end
