//
//  JieJueMainViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueMainViewController.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "JieJueViewController.h"
#import "ChanPinViewController.h"
#import "XuQiuViewController.h"
#import "SearchViewController.h"
#import "ITServiceViewController.h"


@interface JieJueMainViewController ()<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

@end

@implementation JieJueMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeSearchBtn];
    [self maekDLTabed];
    
    
    
}

/** 导航栏搜索按钮 */
- (void)makeSearchBtn {
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)search {
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self pushControllerHiddenTabbar:vc];
}

-(void)maekDLTabed{
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT) andTabbarHeight:33];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor whiteColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarTrackColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@""];
    self.tabedSlideView.tabbarBackgroundColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"解决方案" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"产品" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"IT服务" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    self.tabedSlideView.tabbarItems = @[item1,item2, item3];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;


}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            JieJueViewController *vc1 = [[JieJueViewController alloc] init];
            return vc1;
        }
        case 1:
        {
            ChanPinViewController *vc2 = [[ChanPinViewController alloc] init];
            return vc2;
        }
        case 2:
        {
//            XuQiuViewController *vc3 = [[XuQiuViewController alloc] init];
            ITServiceViewController *vc3 = [[ITServiceViewController alloc]init];
            return vc3;
        }
            
        default:
            return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
