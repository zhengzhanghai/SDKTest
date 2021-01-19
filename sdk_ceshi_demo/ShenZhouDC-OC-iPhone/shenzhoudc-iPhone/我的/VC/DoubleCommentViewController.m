//
//  DoubleCommentViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DoubleCommentViewController.h"
#import "DoubleCommentCell.h"
#import "DoubleCommentModel.h"
#import "DealDetailViewController.h"

@interface DoubleCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *commentArray;
@property(nonatomic,strong)DoubleCommentModel *model1;
@property(nonatomic,strong)DoubleCommentModel *model2;

@property(nonatomic,assign) int observer; // 1接单人 2发单人
@end

@implementation DoubleCommentViewController
- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"双方评价列表";
    [self makeUI];
    [self loadPingLunList];
    
    
    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightItem)];
    
    
     UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"订单详情" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightItem)];
    rightButtonItem.title = @"订单详情";
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

-(void)clickRightItem{
    NSLog(@"订单详情");
    
    DealDetailViewController *vc = [[DealDetailViewController alloc]init];
    vc.orderSn = self.orderSn;
    vc.showBtn = YES;
    vc.canShensu = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (void)makeUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DoubleCommentCell" bundle:nil] forCellReuseIdentifier:@"DoubleCommentCell"];
    [self.view addSubview:_tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoubleCommentCell *cell = [DoubleCommentCell DoubleCommentCell:tableView indexPath:indexPath];
    DoubleCommentModel *model = self.commentArray[indexPath.row];
    if ([model.observer intValue] == 1) {
        [cell createDoubleCommentCellWith:_model1];
    }else if([model.observer intValue] == 2) {
        [cell createDoubleCommentCellWith:_model2];
    }
    
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (void)loadPingLunList {
    NSString *url = @"";
//    if (self.type == 1) {
//        url = [NSString stringWithFormat:@"%@v1/details/getOrderDetail?orderSn=%@", DOMAIN_NAME, self.orderSn];
//    }else if (self.type == 0) {
//         url = [NSString stringWithFormat:@"%@?orderSn=%@", API_GET_DOUBLECOMMENT, self.orderSn];
//    }
    
    url = [NSString stringWithFormat:@"%@v1/details/getOrderDetail?orderSn=%@", DOMAIN_NAME, self.orderSn];
   
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
       
        if (result != nil) {
            if ([result isSucceed]) {
                
               
                NSMutableArray *list = [NSMutableArray array];
//                NSMutableArray *list1 = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *dic = array[i];
                    if ([dic[@"observer"] intValue]==1) {
                        _observer = 1;
                        _model1 = [DoubleCommentModel modelWithDictionary:dic];
                        [list addObject:_model1];
                    }else if ([dic[@"observer"] intValue]==2){
                        _observer = 2;
                        _model2 = [DoubleCommentModel modelWithDictionary:dic];
                        [list addObject:_model2];
                    }
 
                }
                
                
                self.commentArray = list;
                NSLog(@"评论解表数据 ---- %@",self.commentArray);
                [self.tableView reloadData];
            }
        } else {
            
            NSLog(@"请求失败");
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
