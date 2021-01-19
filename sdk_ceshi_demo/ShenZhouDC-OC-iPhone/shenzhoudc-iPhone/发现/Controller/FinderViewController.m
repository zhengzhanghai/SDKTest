//
//  FinderViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2017/2/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FinderViewController.h"
#import "NewChanPinViewController.h"
#import "FileListViewController.h"
#import "ChanPinMoreViewController.h"
#import "VideoListViewController.h"

@interface FinderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation FinderViewController


-(void)demo{
//GCD
    dispatch_queue_t main_q = dispatch_get_main_queue();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
    
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeUI];
    
}

-(void)makeUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}
//MARK: UITableViewDelegate -----------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"视频中心";
        cell.imageView.image = [UIImage imageNamed:@"视频"];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"资料库";
        cell.imageView.image = [UIImage imageNamed:@"产品"];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"产品中心";
        cell.imageView.image = [UIImage imageNamed:@"产品"];
    }
    
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"跳转到视频中心");
        VideoListViewController *vc = [[VideoListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return ;
    }
    if (indexPath.row == 1) {
        NSLog(@"跳转到资料库");
        FileListViewController *vc = [[FileListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 2) {
        NSLog(@"跳转到产品列表");
        ChanPinMoreViewController *vc = [[ChanPinMoreViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
