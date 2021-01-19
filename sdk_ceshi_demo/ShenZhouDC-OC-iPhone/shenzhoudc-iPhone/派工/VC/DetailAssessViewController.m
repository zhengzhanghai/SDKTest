//
//  DetailAssessViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DetailAssessViewController.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"
#import "DetailPaiCollectionViewControllerView.h"
#import "DetailPingJiaViewController.h"
#import "CommentViewController.h"
@interface DetailAssessViewController ()<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

@end

@implementation DetailAssessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self maekDLTabed];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
-(void)maekDLTabed{
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT) andTabbarHeight:NAVBARHEIGHT];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.tabItemNormalColor = UIColorFromRGB(0x2A2A2A);//
    self.tabedSlideView.tabItemSelectedColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarTrackColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@""];
    self.tabedSlideView.tabbarBackgroundColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"派工详情" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"全部评价" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
   
    self.tabedSlideView.tabbarItems = @[item1, item2];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
    
    //测试用
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, NAVBARHEIGHT, NAVBARHEIGHT);
    [back setImage:[UIImage imageNamed:@"返回深色"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.tabedSlideView addSubview:back];
    
    UIButton *assessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [assessButton setTitle:@"评价" forState:UIControlStateNormal];
    [assessButton setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateNormal];
    assessButton.titleLabel.font = [UIFont systemFontOfSize:14];
    assessButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [assessButton addTarget:self action:@selector(assessClickEvent) forControlEvents:UIControlEventTouchUpInside];
//    [assessButton sizeToFit];
    [self.tabedSlideView addSubview:assessButton];
    [assessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(back);
        make.right.equalTo(self.tabedSlideView);
        make.size.mas_equalTo(CGSizeMake(48, 40));
    }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//  评价
- (void)assessClickEvent{
    NSLog(@"评价");
    CommentViewController *vc = [[CommentViewController alloc]init];
    vc.commentId = 4;
    vc.resourceId = [NSString stringWithFormat:@"%d",_ID];
    vc.orderId = @"78837347";
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 2;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            DetailPaiCollectionViewControllerView *vc1 = [[DetailPaiCollectionViewControllerView alloc] init];
            vc1.ID = self.ID;
            vc1.refreshBlcok = ^(){
                if (_DetailAssessRefreshBlcok) {
                    _DetailAssessRefreshBlcok();
                }
            };
            return vc1;
        }
        case 1:
        {
            DetailPingJiaViewController *vc2 = [[DetailPingJiaViewController alloc] init];
            vc2.ID = self.ID;
            return vc2;
        }
            
        default:
            return nil;
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
