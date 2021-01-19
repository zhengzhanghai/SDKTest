//
//  ParticipaterListViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ParticipaterListViewController.h"
#import "ParticipaterDetailViewController.h"
#import "ParticipaterCell.h"
#import "MyParticipatorModel.h"
#import "ChooseButton.h"
#import "NSString+CustomString.h"
#import "TagView.h"

/** m每页加载的数量 */
#define LoadSize 20

@interface ParticipaterListViewController ()<UITableViewDelegate,UITableViewDataSource,TagViewDelegate>
{
    UIView *headerView;
    UITextField *address;
    UITextField *jobAge;
    UITextField *joinNum;
    int price;//升序 降序
    int rateType;//成单率
    UIButton *upBtn;
    UIButton *downBtn;
    int selectedTag;//选中的成单率
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
/** 加载页数 */
@property (assign, nonatomic) NSInteger loadPage;

@property(nonatomic)BOOL isClick;//头视图是否点击
@end

@implementation ParticipaterListViewController
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loadPage = 1;
    self.title = @"报名者列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self configureRefresh];
    selectedTag = nil;
}
- (void)configureRefresh {
    
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
        //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadMore)];
    
//    self.tableView.mj_footer.automaticallyHidden = NO;
}

- (void)pullRefresh {
    self.loadPage = 1;
    [self loadAllServiceListRequest];
}

- (void)pullLoadMore {
    
    self.loadPage = self.loadPage+1;
    [self loadAllServiceListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)makeUI {
    
    
    _isClick = NO;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    
    ChooseButton *titleBtn = [[ChooseButton alloc]init];
    titleBtn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(clickTitleBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.top.mas_equalTo(headerView.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    UIView *choiceView = [[UIView alloc]init];
    choiceView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:choiceView];
    [choiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.top.mas_equalTo(titleBtn.mas_bottom);
        make.right.mas_equalTo(headerView.mas_right);
    }];
    
    NSString *str = @"工作年限：";
    CGFloat width = [str getWidthWithContent:str height:18 font:14];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"按地区：";
    label5.textColor = UIColorFromRGB(0x333333);
    label5.font = [UIFont boldSystemFontOfSize:14];
    [choiceView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(choiceView.mas_top).with.offset(10);
        make.left.mas_equalTo(choiceView.mas_left).with.offset(10);
        make.width.mas_equalTo(width);
    }];
    
    address = [[UITextField alloc]init];
    address.placeholder = @"请输入...";
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.keyboardType = UIKeyboardTypeEmailAddress;
    address.textColor = [UIColor darkGrayColor];
    address.font = [UIFont systemFontOfSize:14];
    [choiceView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label5.mas_right);
        make.centerY.mas_equalTo(label5.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-width-20, 30));
    }];
    
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"工作年限：";
    label6.textColor = UIColorFromRGB(0x333333);
    label6.font = [UIFont boldSystemFontOfSize:14];
    [choiceView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(address.mas_bottom).with.offset(18);
        make.left.mas_equalTo(label5.mas_left);
    }];
    
    jobAge = [[UITextField alloc]init];
    jobAge.placeholder = @"查询大于等于输入年限";
    jobAge.borderStyle = UITextBorderStyleRoundedRect;
    jobAge.keyboardType = UIKeyboardTypeNumberPad;
    jobAge.textColor = [UIColor darkGrayColor];
    jobAge.font = [UIFont systemFontOfSize:14];
    [choiceView addSubview:jobAge];
    [jobAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label6.mas_right);
        make.centerY.mas_equalTo(label6.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-width-20, 30));
    }];
    
    
//    UILabel *label8 = [[UILabel alloc]init];
//    label8.text = @"报名次数：";
//    label8.textColor = UIColorFromRGB(0x333333);
//    label8.font = [UIFont boldSystemFontOfSize:14];
//    [choiceView addSubview:label8];
//    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(jobAge.mas_bottom).with.offset(18);
//        make.left.mas_equalTo(label5.mas_left);
//    }];
//    
//    joinNum = [[UITextField alloc]init];
//    joinNum.placeholder = @"查询大于等于输入次数";
//    joinNum.borderStyle = UITextBorderStyleRoundedRect;
//    joinNum.keyboardType = UIKeyboardTypeNumberPad;
//    joinNum.textColor = [UIColor darkGrayColor];
//    joinNum.font = [UIFont systemFontOfSize:14];
//    [choiceView addSubview:joinNum];
//    [joinNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label8.mas_right);
//        make.centerY.mas_equalTo(label8.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-width-20, 30));
//    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"成单率：";
    label7.textColor = UIColorFromRGB(0x333333);
    label7.font = [UIFont boldSystemFontOfSize:14];
    [choiceView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jobAge.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label5.mas_left);
    }];
    
    NSArray *arr = @[@"80%~100%",@"70%~80%",@"60%~70%",@"50%~60%",@"50%以下"];
    TagView *tagV = [[TagView alloc]initWithArray:arr];
    tagV.delegate = self;
    [choiceView addSubview:tagV];
    [tagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label7.mas_top);
        make.left.mas_equalTo(jobAge.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
    }];
    
    UILabel *label9 = [[UILabel alloc]init];
    label9.text = @"价格：";
    label9.textColor = UIColorFromRGB(0x333333);
    label9.font = [UIFont boldSystemFontOfSize:14];
    [choiceView addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagV.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label5.mas_left);
        make.width.mas_equalTo(width);
    }];
    
    upBtn = [self makeChoiceButtonWithTitle:@"升序"];
    upBtn.tag = 111;
    [choiceView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label9.mas_right);
        make.centerY.mas_equalTo(label9.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    downBtn = [self makeChoiceButtonWithTitle:@"降序"];
    downBtn.tag = 222;
    [choiceView addSubview:downBtn];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(upBtn.mas_right).with.offset(15);
        make.centerY.mas_equalTo(label9.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(makeSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = MainColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [choiceView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label5.mas_left);
        make.top.mas_equalTo(downBtn.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
        make.bottom.mas_equalTo(choiceView.mas_bottom).with.offset(-10);
    }];
    
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = UIColorFromRGB(0xECECEC);
//    [headerView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(headerView.mas_left);
//        make.bottom.mas_equalTo(headerView.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
//    }];


    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ParticipaterCell" bundle:nil] forCellReuseIdentifier:@"ParticipaterCell"];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
}



#pragma mark tagViewDelegate -- 
- (void)getLabelTag:(NSInteger)tag AndIsSelected:(BOOL)isSelected {
    
    NSLog(@"标签的tag -- %ld,,是否选中 --- %d",(long)tag,isSelected);
    selectedTag = (int)tag;
//    NSMutableArray *arr = [NSMutableArray array];
//    
//    if (isSelected == 1) {
//        [arr addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
//    }else if (isSelected == 0) {
//        [arr removeObject:[NSString stringWithFormat:@"%ld",(long)tag]];
//        
//    }
//    _labelsArray = arr;
//    NSLog(@"最终的字符串是******  %@",arr);
    
}
//开始筛选
- (void)makeSureBtn{
    
    [self.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;
    params[@"address"] = address.text;
    params[@"price"] = [NSString stringWithFormat:@"%d",price];
    params[@"rateType"] = [NSString stringWithFormat:@"%d",selectedTag];
    params[@"workingLife"] = jobAge.text;
    
    
    
    
//    NSString *api = [NSString stringWithFormat:@"%@v1/details/searchordertakers?workingLife=%@&address=%@&rateType=%d&registrationNumber=%@&price=%d",DOMAIN_NAME,jobAge.text,address.text,selectedTag,joinNum.text,price];
    NSString *api = [NSString stringWithFormat:@"%@v1/details/pushOrderDetails",DOMAIN_NAME];
    
    
    
    NSLog(@"参数------ &&&&&  %@",params);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                
//                NSMutableArray *list = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    MyParticipatorModel *model = [MyParticipatorModel modelWithDictionary:ads[i]];
                    [self.dataArray addObject:model];
                    
                }
                
               
                [self.tableView reloadData];
                
                
                
                
                [self clickTitleBtn];
               
            }
        } else {
            NSLog(@"请求失败");
            [self showError:self.view message:@"网络错误" afterHidden:3];
        }
        
    }];
    
    
    
}
//收起展开选择页面
- (void)clickTitleBtn {
    
    _isClick = !_isClick;
    if (_isClick) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect frame = headerView.frame;
            frame.size.height =320;
            headerView.frame = frame;
            
        } completion:^(BOOL finished) {
            [self.tableView setFrame:CGRectMake(0, 320+NAVIGATION_BAR_HEIGHT +STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 320)];
        }];
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{

             [headerView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, 40)];
            
        } completion:^(BOOL finished) {
            [self.tableView setFrame:CGRectMake(0, 50+NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
        }];
    }
   
}

- (UIButton *)makeChoiceButtonWithTitle:(NSString *)str {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(clickChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
//选择价格的升序和降序
- (void)clickChoose:(UIButton *)sender {
    
    if (sender.tag == 111) {
        if (sender.selected == NO) {
            sender.selected = YES;
            sender.layer.borderColor = MainColor.CGColor;
            [sender setTitleColor:MainColor forState:UIControlStateNormal];
            downBtn.selected = NO;
            downBtn.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
            [downBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            price = 0;
        }

    }else if (sender.tag == 222) {
        if (sender.selected == NO) {
            sender.selected = YES;
            sender.layer.borderColor = MainColor.CGColor;
            [sender setTitleColor:MainColor forState:UIControlStateNormal];
            upBtn.selected = NO;
            upBtn.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
            [upBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            price = 1;
        }

    }
    NSLog(@"%d",price);
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParticipaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParticipaterCell" forIndexPath:indexPath];
    
     MyParticipatorModel *model = self.dataArray[indexPath.row];
     [cell makeParticipaterCellWithModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyParticipatorModel *model = self.dataArray[indexPath.row];
//    [self chooseParticipator:model.connectid AndOrdersn:model.orderSn AndPrice:[NSString stringWithFormat:@"%@",model.price]];//限定只能查看3个报名人的接口
    
    ParticipaterDetailViewController *vc = [[ParticipaterDetailViewController alloc]init];
    
    vc.connectidID = [NSString stringWithFormat:@"%@",model.connectid];
    vc.price = [NSString stringWithFormat:@"%@",model.price];
    vc.orderSn = model.orderSn;
    NSLog(@"传入的订单号 ===  %@",model.orderSn);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//- (void)chooseParticipator:(NSNumber *)connectid AndOrdersn:(NSString *)orderSn AndPrice:(NSString *)price{
//    NSString *api = [NSString stringWithFormat:@"%@v1/details/getConnect",DOMAIN_NAME];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"connectid"] = connectid;
//    params[@"orderSn"] = orderSn;
//    NSLog(@"参数------ &&&&&  %@,,,%@",params,api);
//   
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"✅✔️%@",responseObject);
//        NSLog(@"验证成功，可以查看");
//        int code = [[responseObject objectForKey:@"code"] intValue];
//        if (code == 1000) {
//            ParticipaterDetailViewController *vc = [[ParticipaterDetailViewController alloc]init];
//            
//            vc.connectidID = [NSString stringWithFormat:@"%@",connectid];
//            vc.price = price;
//            vc.orderSn = orderSn;
//            NSLog(@"传入的订单号 ===  %@",orderSn);
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//        
//    
//        [self showError:self.view message:@"只能查看3个报名人信息" afterHidden:2];
//        }
//        NSString *msg = [responseObject objectForKey:@"message"];
//        [self showSuccess:self.view message:msg afterHidden:2];
//    
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"❎❎%@",error);
//    }];
//    
//}
//加载所有报名者的列表数据
- (void)loadAllServiceListRequest {
   
    
    [self.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.orderSn;

   
    NSString *api = [NSString stringWithFormat:@"%@v1/details/pushOrderDetails",DOMAIN_NAME];
    
    
    NSLog(@"参数------ &&&&&  %@",params);
    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result != nil) {
            if ([result isSucceed]) {
                
                                NSArray *ads = [result getDataObj];
                                for (int i = 0; i < ads.count; i++) {
                                    MyParticipatorModel *model = [MyParticipatorModel modelWithDictionary:ads[i]];
                                    [self.dataArray addObject:model];
                
                                }
                
                //                self.dataArray = list;
                               [self.tableView reloadData];
                                
                
                
            }
        } else {
            NSLog(@"请求失败");
            [self showError:self.view message:@"网络错误" afterHidden:3];
        }
        
    }];
    
    
    
    
//    NSLog(@"-----我是分隔符----- %ld",(long)self.loadPage);
//    NSString *url = [NSString stringWithFormat:@"%@?orderSn=%@&pageNumber=%ld&pageSize=20", API_GETTHISDEALPLIST,self.orderSn,(long)self.loadPage];
//    
//    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        if (result) {
//            if ([result isSucceed]) {
//                NSMutableArray *list = [NSMutableArray array];
//                NSArray *ads = [result getDataObj];
//                for (int i = 0; i < ads.count; i++) {
//                    MyParticipatorModel *model = [MyParticipatorModel modelWithDictionary:ads[i]];
//                    [self.dataArray addObject:model];
//                    
//                }
//                
////                self.dataArray = list;
//               [self.tableView reloadData];
//                
//                
//                
//            } else {
//                
//            }
//        } else {
//            [self showError:self.view message:@"请求失败" afterHidden:1.5];
//        }
//    }];
    
}




@end
