//
//  JieJueDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueDetailsViewController.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "JieJueDetailShuoMingViewController.h"
#import "JieJueDetailsPingJiaViewController.h"
#import "CommentViewController.h"
#import "JieJueSolutionDetailsWEBController.h"
#import "SolutionEvaluateViewController.h"

@interface JieJueDetailsViewController ()<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

@end

@implementation JieJueDetailsViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self maekDLTabed];
    if (_isShowEvaluate) {
        [self makePingJiaBtn];
    }
}

-(void)maekDLTabed{
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT) andTabbarHeight:NAVBARHEIGHT];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.tabItemNormalColor = UIColorFromRGB(0x1E1E1E);//
    self.tabedSlideView.tabItemSelectedColor = MainColor;
    self.tabedSlideView.tabbarTrackColor = MainColor;
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@""];
    self.tabedSlideView.tabbarBackgroundColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"方案简介" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"方案详情" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"全部评价" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    self.tabedSlideView.tabbarItems = @[item1, item2, item3];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
    
    
    //测试用
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, NAVBARHEIGHT, NAVBARHEIGHT);
    [back setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.tabedSlideView addSubview:back];
    
}

- (void)makePingJiaBtn {
    UIButton *pingJiaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:pingJiaBtn];
    pingJiaBtn.frame = CGRectMake(SCREEN_WIDTH-40, 32, 30, 20);
    pingJiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pingJiaBtn setTitle:@"评价" forState:UIControlStateNormal];
    [pingJiaBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateNormal];
    [pingJiaBtn addTarget:self action:@selector(pingJia) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark  点击评价
- (void)pingJia {
    if (![UserModel isLogin]) {
        [self showError:self.view message:@"请先登录" afterHidden:1.5];
        return;
    }
    SolutionEvaluateViewController *vc = [[SolutionEvaluateViewController alloc] init];
    vc.solutionId = _id;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)back{
     [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            JieJueDetailShuoMingViewController *vc1 = [[JieJueDetailShuoMingViewController alloc] init];
            vc1.id = self.id;
            vc1.price = _price;
            return vc1;
        }
        case 1:
        {
            JieJueSolutionDetailsWEBController *vc2 = [[JieJueSolutionDetailsWEBController alloc] init];
            vc2.id = self.id;
            return vc2;
        }
        case 2:
        {
            JieJueDetailsPingJiaViewController *vc3 = [[JieJueDetailsPingJiaViewController alloc] init];
            vc3.id = self.id;
            return vc3;
        }
            
        default:
            return nil;
    }
}

- (void)dealloc {
    NSLog(@"____dealloc____");
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
