//
//  MyDispatchViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MyDispatchViewController.h"
#import "PaiTableViewCell.h"
#import "DetailPaiViewControllerView.h"
#import "PaiModel.h"

@interface MyDispatchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic , assign) int dispatchType;//派工类型 0.我发布的 1.我参与的
@property (nonatomic, strong) NSMutableArray *myDispatchArray;

@end

@implementation MyDispatchViewController
-(NSMutableArray *)dispatchArray {
    if (!_myDispatchArray) {
        _myDispatchArray = [NSMutableArray array];
    }
    return _myDispatchArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的派工";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    self.dispatchType = 1;//默认为1
    if (leftBtn) {
        leftBtn.selected = YES;
    }
        [self loadData];
    [self loadingAddCountToView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)makeHeadView {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(65))];
    headView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, LandscapeNumber(30)));
    }];
    
    leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"已参与" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    

    rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"已发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(headView.mas_bottom);
    }];
    
    
    
    return headView;
}
//点击 我的参与
-(void)clickLeftBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        rightBtn.selected = NO;
        self.dispatchType = 1;
            [self loadData];
    }
    NSLog(@"%d",self.dispatchType);
}
//点击 我的发布
-(void)clickRightBtn :(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        leftBtn.selected = NO;
         self.dispatchType = 0;
            [self loadData];
    }
     NSLog(@"%d",self.dispatchType);

}
-(void)makeUI {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.tableView.backgroundColor = UIColorFromRGB(0xEAEAEA);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 117;
        [self.view addSubview:self.tableView];
    if (self.type == 1){
        self.tableView.tableHeaderView = [self makeHeadView];
    }
        
}
    //MARK: UITableViewDelegate ----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
    }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.myDispatchArray.count;
    }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//        MyRequirementCell *cell = [MyRequirementCell makeMyRequirementCell:tableView WithIndexPath:indexPath];
//    PaiModel *model = self.myDispatchArray[indexPath.row];
//        [cell makeMyRequirementCellWithModel:model];
    
    PaiTableViewCell *cell = [PaiTableViewCell customCellWithTableView:tableView andIndexPath:indexPath];
    cell.model = self.myDispatchArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaiModel *model = self.myDispatchArray[indexPath.row];
    DetailPaiViewControllerView *vc = [[DetailPaiViewControllerView alloc]init];
    vc.ID = [model.id intValue];
    [self.navigationController pushViewController:vc animated:YES];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}
    
- (void)loadData{
    NSString *url;
    if (self.dispatchType == 1) {
        //我参与的
        url = [NSString stringWithFormat:@"%@?userId=%@",API_GET_MYDISPATCH_PARTIPATE,[UserBaseInfoModel sharedModel].id];
    }else if (self.dispatchType == 0) {
        //我发布的
        url = [NSString stringWithFormat:@"%@?userId=%@",API_GET_MY_DISPATCH,[UserBaseInfoModel sharedModel].id];
    }
    
    NSLog(@"URL=%@",url);
    
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self loadingSubtractCount];
        
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                NSLog(@"返回的数组:%@",array);
                for (int i = 0; i < array.count; i++) {
                    PaiModel *model = [PaiModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.myDispatchArray = list;
            }
            
            [self.tableView reloadData];
        } else {

            
            NSLog(@"请求失败");
        }
        
    }];
    
}

@end
