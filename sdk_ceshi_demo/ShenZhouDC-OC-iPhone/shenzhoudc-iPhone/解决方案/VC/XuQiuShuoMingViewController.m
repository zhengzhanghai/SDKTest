//
//  XuQiuShuoMingViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "XuQiuShuoMingViewController.h"
#import "RequirementDetailCollectionViewCell.h"
#import "XiuQiuFuJianViewController.h"
#import "CustomScrollView.h"
#import "JieJueModel.h"
#import "RequireFileModel.h"
#import "BidUserModel.h"
#import "SkillIntelligentViewController.h"

#define BASE_TAG 9404
#define BottomHeight 51

@interface XuQiuShuoMingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *despLabel;
/** 附件背景视图 */
@property (strong, nonatomic) UIView *attachmentView;
/** 已投标视图 */
@property (strong, nonatomic) UILabel *toubiaoLabel;
@property (strong, nonatomic) UIButton *castBtn;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) JieJueModel *model;
/** 是否已经获得用户应标信息 */
@property (assign, nonatomic) BOOL isGetBidMessage;
/** 是否已经应标 */
@property (assign, nonatomic) BOOL isBid;
@property (strong, nonatomic) NSMutableArray *fileArray;
@property (strong, nonatomic) NSMutableArray *bidUserArray;
/** 点击立即应标的弹窗 */
@property (strong, nonatomic) UIView *alpheView;
@end

@implementation XuQiuShuoMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUi];
    [self isBid];
    [self loadRequireDetails];
    [self loadFile];
    [self loadBidUser];
}

// 添加附件视图
- (void)addFileSubView {
    for (UIView *view in [self.attachmentView subviews]) {
        [view removeFromSuperview];
    }
    UILabel *tmpLabel = [[UILabel alloc] init];
    [self.attachmentView addSubview:tmpLabel];
    for (int i = 0; i < _fileArray.count; i++) {
        UILabel *title = [[UILabel alloc] init];
        [self.attachmentView addSubview:title];
        title.textColor = UIColorFromRGB(0xD91E30);
        title.font = [UIFont systemFontOfSize:14];
        title.text = [NSString stringWithFormat:@"附件%d:", i];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(28);
            make.top.equalTo(tmpLabel.mas_bottom).offset(10);
        }];
        
        UILabel *content = [[UILabel alloc] init];
        [self.attachmentView addSubview:content];
        content.textColor = UIColorFromRGB(0x999999 );
        content.font = [UIFont systemFontOfSize:14];
        RequireFileModel *model = self.fileArray[i];
        content.text = model.downUrl;
        content.numberOfLines = 0;
        content.userInteractionEnabled = YES;
        content.tag = BASE_TAG + i;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFujian:)];
        [content addGestureRecognizer:tapGes];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(5);
            make.top.equalTo(title.mas_top);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-100);
            if (i == _fileArray.count-1) {
                make.bottom.mas_equalTo(0);
            }
        }];
        tmpLabel = content;
    }
}

- (void)clickFujian:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - BASE_TAG;
    XiuQiuFuJianViewController *vc = [[XiuQiuFuJianViewController alloc] init];
    vc.id = [NSString stringWithFormat:@"%zd", index];
    RequireFileModel *model = self.fileArray[index];
    vc.url = model.downUrl;
    [self pushControllerHiddenTabbar:vc];
}

- (void)isRespondBid {
    if ([UserBaseInfoModel isLogin]) {
        UserBaseInfoModel *userModel = [UserBaseInfoModel readFromLocal];
        NSString *URL = [NSString stringWithFormat:@"%@?id=%@&userId=%@", API_GET_DEMAND_ISBID, self.id, userModel.id];
        [[AINetworkEngine sharedClient] getWithApi:URL parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
            if (result) {
                if ([result getCode] == 1000) {
                    NSDictionary *dict = [result getDataObj];
                    NSNumber *status = dict[@"status"];
                    if (status.integerValue == 0) {
                        self.isBid = NO;
                    } else {
                        self.isBid = YES;
                    }
                }
            } else {
                NSLog(@"------请求失败-------");
            }
        }];
    }
}

- (void)loadRequireDetails {
    NSString *url = [NSString stringWithFormat:@"%@%@", API_GET_DEMAND_DETAILS, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSDictionary *data = [result getDataObj];
                self.model = [JieJueModel modelWithDictionary:data];
                self.titleLabel.text = self.model.name;
                self.despLabel.text = self.model.desp;
            }
        } else {
            NSLog(@"—————————请求失败—————————");
        }
        
    }];
}

// 获取需求附件
- (void)loadFile {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@", API_GET_DEMAND_FILE, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    RequireFileModel *model = [RequireFileModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.fileArray = list;
                [self addFileSubView];
            }
        } else {
            NSLog(@"________需求附件，请求失败________");
        }
    }];
}

// 获取应标用户
- (void)loadBidUser {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@", API_GET_DEMAND_USER, self.id];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    BidUserModel *model = [BidUserModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                self.bidUserArray = list;
                [self.collectionView reloadData];
            }
        } else {
            NSLog(@"________获取应标用户，请求失败________");
        }
        
    }];
}

- (void)setUpUi{
    [self.view addSubview:self.castBtn];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.despLabel];
    [self.scrollView addSubview:self.attachmentView];
    [self.scrollView addSubview:self.toubiaoLabel];
    [self.scrollView addSubview:self.collectionView];
    
    [self.castBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(BottomHeight);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(_castBtn.mas_top);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(11);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];
    [self.despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];
    [self.attachmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_despLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.toubiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_attachmentView.mas_bottom).offset(20);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_toubiaoLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(240);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x484848);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)despLabel {
    if (!_despLabel) {
        _despLabel = [[UILabel alloc] init];
        _despLabel.textColor = UIColorFromRGB(0x4A4A4A);
        _despLabel.font = [UIFont systemFontOfSize:12];
        _despLabel.numberOfLines = 0;
    }
    return _despLabel;
}

- (UILabel *)toubiaoLabel {
    if (!_toubiaoLabel) {
        _toubiaoLabel = [[UILabel alloc] init];
        _toubiaoLabel.textColor = UIColorFromRGB(0x333333);
        _toubiaoLabel.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _toubiaoLabel.font = [UIFont systemFontOfSize:14];
        _toubiaoLabel.textAlignment = NSTextAlignmentCenter;
        _toubiaoLabel.text = @"已投标企业";
    }
    return _toubiaoLabel;
}

- (UIView *)attachmentView {
    if (!_attachmentView) {
        _attachmentView = [[UIView alloc] init];
    }
    return _attachmentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(130, 204);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 206) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)castBtn {
    if (!_castBtn) {
        _castBtn = [[UIButton alloc]init];
        [_castBtn setTitle:@"立即应标" forState:UIControlStateNormal];
        _castBtn.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:22.0/255.0 blue:41.0/255.0 alpha:1];
        _castBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_castBtn addTarget:self action:@selector(cast) forControlEvents:UIControlEventTouchUpInside];
    }
    return _castBtn;
}

#pragma mark ____ 立即应标点击
- (void)cast {
    [[UIApplication sharedApplication].keyWindow addSubview:self.alpheView];
}

- (UIView *)alpheView {
    if (!_alpheView) {
        _alpheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _alpheView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIWindow *windows = [UIApplication sharedApplication].keyWindow;
        [windows addSubview:_alpheView];
        
        UIView *whiteV = [[UIView alloc]init];
        whiteV.backgroundColor = [UIColor whiteColor];
        [_alpheView addSubview:whiteV];
        [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_alpheView.mas_centerX);
            make.centerY.mas_equalTo(_alpheView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(LandscapeNumber(280), LandscapeNumber(161)));
        }];
        
        UILabel *titleL = [[UILabel alloc]init];
        titleL.text = @"提示";
        titleL.textColor = UIColorFromRGB(0x0F0F0F);
        titleL.font = [UIFont systemFontOfSize:16];
        [whiteV addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteV.mas_centerX);
            make.top.mas_equalTo(whiteV.mas_top).with.offset(LandscapeNumber(16));
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xECECEC);
        [whiteV addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(titleL.mas_bottom).with.offset(LandscapeNumber(16));
            make.height.mas_equalTo(1);
        }];
        
        UILabel *msgLabel = [[UILabel alloc]init];
        msgLabel.text = @"请到PC端操作";
        msgLabel.textColor = UIColorFromRGB(0x3D3D3D);
        msgLabel.font = [UIFont systemFontOfSize:16];
        [whiteV addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteV.mas_centerX);
            make.top.mas_equalTo(lineView.mas_bottom).with.offset(LandscapeNumber(20));
        }];
        
        
        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(clickReadBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"知道了" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromRGB(0xD71629);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [whiteV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(whiteV.mas_centerX);
            make.top.mas_equalTo(msgLabel.mas_bottom).with.offset(LandscapeNumber(20));
            make.bottom.mas_equalTo(-LandscapeNumber(16));
            make.width.mas_equalTo(LandscapeNumber(120));
        }];

    }
    return _alpheView;
}

- (void)clickReadBtn {
    [_alpheView removeFromSuperview];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bidUserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RequirementDetailCollectionViewCell *cell = [RequirementDetailCollectionViewCell customCollectionViewCellWithCollectionView:collectionView andIndexPath:indexPath];
    BidUserModel *model = self.bidUserArray[indexPath.row];
    [cell refreshCell:model.portrait title:model.nickName];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SkillIntelligentViewController *vc = [[SkillIntelligentViewController alloc] init];
    BidUserModel *model = self.bidUserArray[indexPath.row];
    vc.ID = model.id.intValue;
    vc.resourceId = (int)(self.id);
    [self pushControllerHiddenTabbar:vc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
