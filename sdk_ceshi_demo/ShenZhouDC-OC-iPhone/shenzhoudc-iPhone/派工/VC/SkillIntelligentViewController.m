//
//  SkillIntelligentViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SkillIntelligentViewController.h"
#import "SkillIntelligentTableViewCell.h"
#import "PaiModel.h"
#import "PingJiaTableViewCell.h"
#import "CommentModel.h"
@interface SkillIntelligentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PaiModel *model;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) MBProgressHUD *showError;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation SkillIntelligentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细信息";
    self.page = 1;
    [self setUpUi];
    [self loadData];
    [self loadListData];
    //    _showError =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadListData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadListData];
        
    }];
}

- (void)loadData{
    [self loadingAddCountToView:self.view];
    NSString *url =[NSString stringWithFormat:@"%@?userId=%d",API_GET_USER_PROFILE,_ID];
    NSLog(@"达人信息%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSDictionary *dict = [result getDataObj];
                self.model = [PaiModel modelWithDictionary:dict];
            }else{
                //204
                NSLog(@"%@",[result getMessage]);
            }
        }else{
            NSLog(@"请求失败");
        }
        [self loadingSubtractCount];
    }];
    
}

- (void)loadListData{

    [self loadingAddCountToView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@?resourceId=%d&userId=%d&page=%zd&size=20",API_GET_COMMENT,_resourceId,_ID,_page];
    NSLog(@"派工评论列表....URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"%@",[result getMessage]);
                NSArray *arr = [result getDataObj];
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    [arrM addObject:[CommentModel modelWithDictionary:dict]];
                }
                if (_page == 1) {
                    self.dataArr = arrM;
                    NSLog(@"下拉刷新出%zd条数据",arrM.count);
                }else{
                    NSLog(@"上拉加载更多%zd条数据",arrM.count);
                    for (CommentModel *model in arrM) {
                        [self.dataArr addObject:model];
                    }
                }
                
                [self.tableView reloadData];
                
            }else{
                
                NSLog(@"%@",[result getMessage]);
                
            }
        }else{
            NSLog(@"请求失败");
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self loadingSubtractCount];
    }];
    
}

- (void)setModel:(PaiModel *)model{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    _nameLabel.text = model.nickName;
    
}
- (void)setUpUi{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT - 146) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self customHeaderView];
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 100;
    
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 让行高根据里面得内容来自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
}

- (UIView*)customHeaderView{
    
    //标签数组
    NSArray *array = @[@"阳光帅气大男孩",@"活泼搞怪很任性"
                       ,@"活泼"];
    float rows = array.count%3>0 ? (array.count/3+1):array.count/3;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT,SCREEN_WIDTH, LandscapeNumber(151)+LandscapeNumber(24)*rows)];
    headView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = LandscapeNumber(60)/2;
    headImg.userInteractionEnabled = YES;
    headImg.image = [UIImage imageNamed:@"user_icon"];
    [headView addSubview:headImg];
    _headImg = headImg;
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headView.mas_top).with.offset(LandscapeNumber(12));
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(60), LandscapeNumber(60)));
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x484848);
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"   ";
    [headView addSubview:nameLabel];
    _nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headImg.mas_bottom).with.offset(10);
    }];
    
    UIImageView *identifierIcon = [[UIImageView alloc]init];
    identifierIcon.image = [UIImage imageNamed:@"idenrifier_icon"];
    [headView addSubview:identifierIcon];
    [identifierIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(11, 12));
    }];
    
    
    UIView *middowView = [[UIView alloc]init];//WithFrame:CGRectMake(SCREEN_WIDTH/4, CGRectGetMaxY(nameLabel.frame)+ 10, SCREEN_WIDTH/3, LandscapeNumber(47)*rows)
    middowView.userInteractionEnabled = YES;
    middowView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:middowView];
    [middowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, LandscapeNumber(24)*rows));
    }];
    
    
    
    
    
    //    int width = 0;
    //    int height = 0;
    //    int number = 0;
    //    int han = 0;
    //
    //    float index_x = 10;
    //    float index_y = 10;
    //    //创建button
    //    for (int i = 0; i < array.count; i++) {
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        button.tag = 300 + i;
    //        CGSize titleSize = [self getSizeByString:array[i] AndFontSize:9];
    //        han = han +titleSize.width;
    //
    //        if (han > SCREEN_WIDTH/2 - (array.count+1) * 10) {
    //            han = 0;
    //            han = han + titleSize.width;
    //            height++;
    //            width = 0;
    //            width = width+titleSize.width;
    //            number = 0;
    //            button.frame = CGRectMake(index_x, index_y +24*height, titleSize.width, 20);
    //        }else{
    //            button.frame = CGRectMake(width+index_x+(number*10), index_y +24*height, titleSize.width, 20);
    //            width = width+titleSize.width;
    //        }
    //        number++;
    //        button.titleLabel.font = [UIFont systemFontOfSize:9];
    //        button.layer.masksToBounds = YES;
    //        button.layer.cornerRadius = 2;
    //        button.layer.borderColor = UIColorFromRGB(0x4990E2).CGColor;
    //        button.layer.borderWidth = 1;
    //        button.backgroundColor = [UIColor whiteColor];
    //        [button setTitleColor:UIColorFromRGB(0x4990E2) forState:UIControlStateNormal];
    //        [button setTitle:array[i] forState:UIControlStateNormal];
    //        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    //        [middowView addSubview:button];
    //    }
    
    
    
    
    
    
    float b_x = 10;
    float b_y = 10;
    
    //    float width = LandscapeNumber(42);
    float height = LandscapeNumber(14);
    
    for (int i = 0; i < array.count; i++) {
        if (i % 3 == 0 && i != 0) {
            b_x = 10;
            b_y += height+10;
        }
        CGSize titleSize = [self getSizeByString:array[i] AndFontSize:9];
        float width = titleSize.width;
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x4990E2).CGColor;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x4990E2) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.tag = i;
        [middowView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(middowView.mas_left).with.offset(b_x);
            make.top.mas_equalTo(middowView.mas_top).with.offset(b_y);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        b_x = b_x + width + 10;
    }
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"北京 | 成交10笔 ";
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(middowView.mas_bottom).with.offset(10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.top.equalTo(label.mas_bottom).offset(12);
        make.height.mas_equalTo(8);
    }];
    
    return headView;
}


- (void)handleButton:(UIButton*)sender{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PingJiaTableViewCell *cell = [PingJiaTableViewCell pingJiaCell:tableView indexPath:indexPath];
    [cell refreshCell];
    //    cell.model = self.dataSourse[indexPath.row];
    //    cell.block = ^(){
    //        NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:1 inSection:0];
    //        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
    //    };
    CommentModel *model = _dataArr[indexPath.row];
    [cell refreshCell:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 46;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
