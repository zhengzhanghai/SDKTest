//
//  ReleaseDispatchingViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ReleaseDispatchingViewController.h"
#import "PublicDispatchCell.h"
#import "NSString+CustomString.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectedImagesViewController.h"

@interface ReleaseDispatchingViewController ()<UITableViewDelegate,UITableViewDataSource,SelectedImagesViewControllerDelegate>
{
    UIView *photoView;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic , copy) NSString *dispatchName;//派工名称
@property(nonatomic , copy) NSString *dispatchPrice;//派工价格
@property(nonatomic , copy) NSString *dispatchCharacteristics;//产品特征/描述

@property(nonatomic, strong) SelectedImagesViewController *photoVC;

@end

@implementation ReleaseDispatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布派工";
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    
    UIButton *publicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-LandscapeNumber(50), SCREEN_WIDTH, LandscapeNumber(50))];
    publicBtn.backgroundColor = UIColorFromRGB(0xD71629);
    [publicBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publicBtn addTarget:self action:@selector(clickPublickBtn) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:publicBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-LandscapeNumber(50)-NAVBARHEIGHT-STATUSBARHEIGHT)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    self.tableView.tableFooterView = [self makeFootView];
    [self.view addSubview:self.tableView];
   
}
- (UIView *)makeFootView {
    
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10+((self.photoVC.photos.count+1)/3+1)*90)];
    
    UILabel *titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH-32, 17)];
    titleLabel3.text = @"上传照片";
    titleLabel3.font = [UIFont systemFontOfSize:16];
    titleLabel3.textColor = UIColorFromRGB(0x3D4245);
    [footV addSubview:titleLabel3];
    
    //照片选择
    photoView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(titleLabel3.frame), SCREEN_WIDTH-32, 20+((self.photoVC.photos.count+1)/3+1)*80)];
    [footV addSubview:photoView];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 4;
    photoView.backgroundColor = [UIColor clearColor];
    photoView.backgroundColor = [UIColor yellowColor];
    self.photoVC = [[SelectedImagesViewController alloc] init];
    self.photoVC.delegate = self;
    self.photoVC.photoCount = 9;
    [self addChildViewController:self.photoVC];
    [photoView addSubview:self.photoVC.view];
    [self.photoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_top);
        make.left.mas_equalTo(photoView.mas_left);
        make.right.mas_equalTo(photoView.mas_right);
        make.bottom.mas_equalTo(photoView.mas_bottom);
    }];
    
    
    if (self.publickType == 1 || self.publickType == 2) {
        
        UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(photoView.frame), SCREEN_WIDTH-32, 16)];
        laber.text = @"上传附件";
        laber.textColor = UIColorFromRGB(0xD71629);
        laber.font = [UIFont systemFontOfSize:16];
        [footV addSubview:laber];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(laber.frame), CGRectGetWidth(laber.frame), 1)];
        lineV.backgroundColor = UIColorFromRGB(0xD71629);
        [footV addSubview:lineV];
        
        
        UIButton *pubBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(photoView.frame), CGRectGetWidth(laber.frame), CGRectGetHeight(laber.frame)+3)];
        [pubBtn addTarget:self action:@selector(clickPub) forControlEvents:UIControlEventTouchUpInside];
        pubBtn.backgroundColor = [UIColor clearColor];
        [footV addSubview:pubBtn];
        
        
    }

    return footV;
}
- (void)clickPub {
    
    
    NSLog(@"********");
    
}
-(void)reloadUI{
    
    photoView.frame = CGRectMake(0, 160, SCREEN_WIDTH, 10+((self.photoVC.photos.count+1)/3+1)*90);
}
//点击 发布按钮
-(void)clickPublickBtn {
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicDispatchCell *cell = [PublicDispatchCell makePublickDispatchCell:tableView WithIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"派工名称";
        cell.placeHolderLabel.text = @"请输入";
        cell.nameBlock = ^(NSString *name) {
            self.dispatchName = name;
            NSLog(@"🌸🌸🌸-->> %@",self.dispatchName);
            
        };
    }else if(indexPath.row == 1){
        cell.titleLabel.text = @"派工价格";
        cell.placeHolderLabel.text = @"¥ 请输入";
        cell.nameBlock = ^(NSString *name) {
            self.dispatchPrice = name;
            NSLog(@"🌸🌸🌸-->> %@",self.dispatchName);
       
        };
    }else if(indexPath.row == 2){
        cell.titleLabel.text = @"产品特性与价格描述";
        cell.placeHolderLabel.text = @"请输入";
        cell.nameBlock = ^(NSString *name) {
            self.dispatchCharacteristics = name;
            NSLog(@"🌸🌸🌸-->> %@",self.dispatchName);
        };
    }
    
    
    return cell;
}


@end
