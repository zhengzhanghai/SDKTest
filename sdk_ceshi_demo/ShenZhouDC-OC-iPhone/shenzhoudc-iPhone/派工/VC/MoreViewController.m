//
//  MoreViewController.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MoreViewController.h"
#import "PaiTableViewCell.h"
#import <ZYSideSlipFilter/ZYSideSlipFilterController.h>
#import <ZYSideSlipFilter/ZYSideSlipFilterRegionModel.h>
#import "CommonItemModel.h"
#import "SideSlipCommonTableViewCell.h"
#import "MoreCollectionViewCell.h"
#import "CommonMacro.h"
#import "MoreCollectionReusableView.h"
#import "TwoMoreCollectionReusableView.h"
#import "ThreeHootViewController.h"
#import "AINetworkEngine.h"
#import "PaiModel.h"
#import "DetailPaiViewControllerView.h"
#import "DetailPaiCollectionViewControllerView.h"
#import "DetailAssessViewController.h"
#define BOUND_Width [UIScreen mainScreen].bounds.size.width
#define BOUND_Height [UIScreen mainScreen].bounds.size.height
CGFloat const gestureMinimumTranslation = 40.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;
@interface MoreViewController ()<UITableViewDelegate
,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    CameraMoveDirection direction;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) ZYSideSlipFilterController *filterController;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSMutableArray *dataSourse;
@property (nonatomic,strong) NSArray *tempDataSourse;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic,assign) BOOL isAllTwo;
@property (nonatomic,assign) BOOL isAllThree;
@property (nonatomic,strong) NSArray *data1;
@property (nonatomic,strong) NSArray *data2;
@property (nonatomic,strong) NSArray *data3;
@property (nonatomic,strong) NSMutableArray *saveData;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) MBProgressHUD *showError;
//分类ID
@property (nonatomic,strong) NSString* categoryId;
//地区ID
@property (nonatomic,strong) NSString* provinceId;
/** 筛选中大标题 */
@property (strong, nonatomic) NSArray<NSString *> *headTitles;
/** 筛选中行业分类小标题 */
@property (strong, nonatomic) NSArray<CommonItemModel *> *categorys;
/** 筛选中实施地区小标题 */
@property (strong, nonatomic) NSArray<CommonItemModel *> *Corners;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多方案";
    _page = 1;
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(creatSiftView)];
//         _data1 = [NSArray array];
//         _data2 = [NSArray array];
//         _data3 = [NSArray array];
//        _saveData = [NSMutableArray array];
//        _tempDataSourse = @[@[@{@"names":@"存储设备",@"isSelected":@"NO"},@{@"names":@"X86服务器",@"isSelected":@"NO"},@{@"names":@"中间件",@"isSelected":@"NO"},@{@"names":@"交换机",@"isSelected":@"NO"},@{@"names":@"主机",@"isSelected":@"NO"},@{@"names":@"支架",@"isSelected":@"NO"}],@[@{@"names":@"北京",@"isSelected":@"NO"},@{@"names":@"上海",@"isSelected":@"NO"},@{@"names":@"天津",@"isSelected":@"NO"},@{@"names":@"石家庄",@"isSelected":@"NO"},@{@"names":@"大连",@"isSelected":@"NO"},@{@"names":@"深圳",@"isSelected":@"NO"},@{@"names":@"西藏",@"isSelected":@"NO"}],@[@{@"names":@"不限",@"isSelected":@"NO"},@{@"names":@"未认证",@"isSelected":@"NO"},@{@"names":@"已认证",@"isSelected":@"NO"}]];
//        for (NSInteger i = 0; i<3; ++i) {
//          NSArray *arr = _tempDataSourse[i];
//            NSMutableArray *arrM = [NSMutableArray array];
//            for (NSInteger i = 0; i<arr.count; ++i) {
//                [arrM addObject:[PaiModel modelWithDictionary:arr[i]]];
//            }
//            if (i == 0) {
//                _data1 = arrM;
//                [_saveData addObject:_data1];
//            }else if(i == 1){
//                _data2 = arrM;
//                [_saveData addObject:_data2];
//            }else{
//                _data3 = arrM;
//                [_saveData addObject:_data3];
//            }
//    
//        }
    [self setUpUi];
    [self loadCategory];
    [self loadCorner];
    [self loadDataIsScreen:NO];
//    [self makeZYSide];
//    _showError =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         _page = 1;
        [self loadDataIsScreen:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadDataIsScreen:NO];
        
    }];
}


- (void)loadDataIsScreen:(BOOL)isScreen{
    
   [self loadingAddCountToView:self.view];
     NSString *url = @"";
    if (isScreen) {
        if (_categoryId != nil) {
            url = [NSString stringWithFormat:@"%@?screen=0&page=%zd&size=20&categoryId=%@",API_GET_ASSIGN,_page,_categoryId];
        }
        if (_provinceId != nil) {
            url = [NSString stringWithFormat:@"%@?screen=0&page=%zd&size=20&provinceId=%@",API_GET_ASSIGN,_page,_provinceId];

        }
        if (_categoryId != nil && _provinceId != nil) {
            url = [NSString stringWithFormat:@"%@?screen=0&page=%zd&size=20&categoryId=%@&provinceId=%@",API_GET_ASSIGN,_page,_categoryId,_provinceId];
        }
       }else{
    url = [NSString stringWithFormat:@"%@?screen=0&page=%zd&size=20",API_GET_ASSIGN,_page];
    }
    
    NSLog(@"URL=%@",url);
    AINetworkEngine * manger = [AINetworkEngine sharedClient];
    [manger getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    PaiModel *model = [PaiModel modelWithDictionary:array[i]];
                    [list addObject:model];
                }
                
                if (_page == 1) {
                   self.dataSourse = list;
                    NSLog(@"下拉刷新出%zd条数据",list.count);
                }else{
                    NSLog(@"上拉加载更多%zd条数据",list.count);
                    for (PaiModel *model in list) {
                        [self.dataSourse addObject:model];
                    }
                }
                
                [self.tableView reloadData];
                
            }else{
                NSLog(@"code=204%@",[result getMessage]);
                NoAutorotateAlertController *alertVc = [NoAutorotateAlertController alertControllerWithTitle:@"" message:[result getMessage] preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVc animated:YES completion:^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                }];

            }
            
        } else {
            NSLog(@"请求失败");
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self loadingSubtractCount];
    }];
    
}

- (void)setUpUi{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,BOUND_Width , BOUND_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//        UIView *backView = [[UIView alloc]init];
//        backView.backgroundColor = [UIColor blackColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickEvent)];
//        [backView addGestureRecognizer:tap];
//        backView.frame = CGRectMake(0, 0, BOUND_Width, BOUND_Height);
//        backView.alpha = 0;
//        backView.hidden = YES;
//        [[UIApplication sharedApplication].keyWindow addSubview:backView];
//        _backView = backView;
//    
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.minimumLineSpacing = 15;
//        flowLayout.minimumInteritemSpacing = 10;
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(BOUND_Width, 0, BOUND_Width-40, BOUND_Height) collectionViewLayout:flowLayout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
//        [_collectionView addGestureRecognizer:pan];
//        [[UIApplication sharedApplication].keyWindow addSubview:_collectionView];
//    
}

- (void)tapClickEvent{
    [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{

        _collectionView.frame = CGRectMake(BOUND_Width, 0, BOUND_Width - 40, BOUND_Height);
        _backView.alpha = 0;

    } completion:^(BOOL finished) {
        _backView.hidden = YES;
    }];
}

- (void)creatSiftView{
//        [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
//            _collectionView.frame = CGRectMake(40, 0, BOUND_Width - 40, BOUND_Height);
//            _backView.hidden = NO;
//            _backView.alpha = 0.6;
//        } completion:^(BOOL finished) {
//    
//        }];
    
    [_filterController show];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaiTableViewCell *cell = [PaiTableViewCell customCellWithTableView:tableView andIndexPath:indexPath];
    cell.model = _dataSourse[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DetailPaiViewControllerView *vc = [[DetailPaiViewControllerView alloc]init];
//    DetailPaiCollectionViewControllerView *vc = [[DetailPaiCollectionViewControllerView alloc]init];
    DetailAssessViewController *vc = [[DetailAssessViewController alloc]init];
    vc.DetailAssessRefreshBlcok = ^(){
        _page = 1;
        [self loadDataIsScreen:NO];
    };

    PaiModel *model = _dataSourse[indexPath.row];
    vc.ID = [model.id intValue];
//    vc.refreshBlcok = ^(){
//        _page = 1;
//        [self loadData];
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

//=================================================================================
// MARK:获取筛选中行业分类
- (void)loadCategory {
    NSString *url = [NSString stringWithFormat:@"%@?type=4", API_GET_CATEGORY];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    CommonItemModel *model = [CommonItemModel createModel:array[i] andKeyWord:@"行业分类"];
                    [list addObject:model];
                }
                self.categorys = list;
                    [self makeZYSide];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}

// MARK:获取筛选实施地区
- (void)loadCorner {
    NSString *url = [NSString stringWithFormat:@"%@", API_GET_DICT_PROVINCE];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result != nil) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *array = [result getDataObj];
                for (int i = 0; i < array.count; i++) {
                    CommonItemModel *model = [CommonItemModel createModel:array[i] andKeyWord:@"行业分类"];
                    [list addObject:model];
                }
                self.Corners = list;
                [self makeZYSide];
            }
        } else {
            NSLog(@"请求失败");
        }
    }];
}


-(void)makeZYSide{
    self.filterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self
                                                                     resetBlock:^(NSArray *dataList) {
                                                                         //重置
                                                                         for (ZYSideSlipFilterRegionModel *model in dataList) {
                                                                             //selectedStatus
                                                                             for (CommonItemModel *itemModel in model.itemList) {
                                                                                 [itemModel setSelected:NO];
                                                                             }
                                                                             //selectedItem
                                                                             model.selectedItemList = nil;
                                                                         }
                                                                         
                                                                     }                                                               commitBlock:^(NSArray *dataList) {
                                                                    //提交
                                                                         for (ZYSideSlipFilterRegionModel *model in dataList) {
                                                                             NSLog(@"%@",model.regionTitle);
                                                                             for (CommonItemModel *itemModel in model.selectedItemList) {
                                                                                 //获取选中Item
                                                                                 NSLog(@"选中%@的ID=%@",itemModel.itemName,itemModel.itemId);
                                                                                 if ([model.regionTitle isEqualToString:@"项目类别"]) {
                                                                                     _categoryId = itemModel.itemId;
                                                                                     
                                                                                 }
                                                                                 if ([model.regionTitle isEqualToString:@"实施地区"]) {
                                                                _provinceId = itemModel.itemId;
                                                                                 }
                                                                                 
                                                                                 
                                                                             }
                                                                             
    
                                                                         }
                                                                        
                                                               [self loadDataIsScreen:YES];                 [_filterController dismiss];
                                                                     }];
    _filterController.animationDuration = .3f;
    _filterController.sideSlipLeading = 0.15*[UIScreen mainScreen].bounds.size.width;
    _filterController.dataList = [self packageDataList];
    //need navigationBar?
    [_filterController.navigationController setNavigationBarHidden:NO];
    [_filterController setTitle:@"筛选"];
}

#pragma mark - 模拟数据源
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"项目类别" selectionType:BrandTableViewCellSelectionTypeSingle]];//单选
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"实施地区" selectionType:BrandTableViewCellSelectionTypeSingle]];//单选
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"是否认证" selectionType:BrandTableViewCellSelectionTypeSingle]];//单选
    
    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    if ([keyword isEqualToString:@"项目类别"]) {
        model.itemList = self.categorys;
    }
    if ([keyword isEqualToString:@"实施地区"]) {
        model.itemList = self.Corners;
    }
    if ([keyword isEqualToString:@"是否认证"]) {
        model.itemList =  @[[self createItemModelWithTitle:@"不限" itemId:@"0000" selected:NO],
                            [self createItemModelWithTitle:@"未认证" itemId:@"0001" selected:NO],
                            [self createItemModelWithTitle:@"已认证" itemId:@"0002" selected:NO]];
    }
     return model;
}

- (CommonItemModel *)createItemModelWithTitle:(NSString *)itemTitle
                                       itemId:(NSString *)itemId
                                     selected:(BOOL)selected {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    model.itemId = itemId;
    model.itemName = itemTitle;
    model.selected = selected;
    return model;
}


//======================================================================


//#pragma mark - UICollectionViewDataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 3;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *arr = _saveData[section];
//    if (section == 0) {
//      return  _isAll?arr.count:3;
//    }else if (section == 1) {
//      return  _isAllTwo?arr.count:3;
//    }else{
//      return  3;
//    }
//
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    MoreCollectionViewCell *cell = [MoreCollectionViewCell customCellWithTableView:collectionView andIndexPath:indexPath];
//    NSArray *arr = _saveData[indexPath.section];
//    cell.model = arr[indexPath.row];
//    cell.btn.tag = indexPath.row;
//    cell.sendTagBlock = ^(NSInteger section,NSInteger row,BOOL isSelect){
//        if (isSelect) {
//            NSArray *arr = _saveData[section];
//            PaiModel *model = arr[row];
//            model.isSelected = @"YES";
//            [_tableView reloadData];
//        }else{
//            NSArray *arr = _saveData[section];
//            PaiModel *model = arr[row];
//            model.isSelected = @"NO";
//            [_tableView reloadData];
//        }
//    };
//    return cell;
//
//}
//
//#pragma mark - UICollectionViewDelegate
////返回item的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((SCREEN_WIDTH - 84 )/ 3, 25);
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        MoreCollectionReusableView *reusableView = [MoreCollectionReusableView customReusableViewWithCollectionView:collectionView andIndexPath:indexPath];
//        reusableView.classBlock = ^(BOOL isAll){
//            _isAll = isAll;
//            [self.collectionView reloadData];
//        };
//        return reusableView;
//    }else if (indexPath.section == 1) {
//        TwoMoreCollectionReusableView *reusableView = [TwoMoreCollectionReusableView twoCustomReusableViewWithCollectionView:collectionView andIndexPath:indexPath];
//        reusableView.classBlock = ^(BOOL isAll){
//            _isAllTwo = isAll;
//            [self.collectionView reloadData];
//        };
//
//        return reusableView;
//    }else{
//        ThreeHootViewController *reusableView = [ThreeHootViewController threeCustomReusableViewWithCollectionView:collectionView andIndexPath:indexPath];
//        reusableView.classBlock = ^(BOOL isAll){
//            _isAllThree = isAll;
//            [self.collectionView reloadData];
//        };
//
//        return reusableView;
//    }
//
//
//
//}
////返回头部视图大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return CGSizeMake(BOUND_Width - 40, 106);
//
//    }else if (section == 1) {
//        return CGSizeMake(BOUND_Width - 40, 54);
//
//    }else{
//        return CGSizeMake(BOUND_Width - 40, 54);
//
//    }
//}
//
////返回插入组边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 12, 12, 12);
//}
//




CGFloat x = 40;
- ( void )handleSwipe:( UIPanGestureRecognizer *)gesture

{
    
    CGPoint translation = [gesture translationInView: self .view];
    
    if (gesture.state == UIGestureRecognizerStateBegan )
        
    {
        
        direction = kCameraMoveDirectionNone;
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
        
    {
        
        direction = [ self determineCameraDirectionIfNeeded:translation];
        if (direction == kCameraMoveDirectionRight) {
            NSLog(@"------------");
            [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
                
                _collectionView.frame = CGRectMake(BOUND_Width, 0, BOUND_Width - 40, BOUND_Height);
                _backView.alpha = 0;
                
            } completion:^(BOOL finished) {
                _backView.hidden = YES;
            }];
        }
        // ok, now initiate movement in the direction indicated by the user's gesture
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                
                NSLog (@ "Start moving down" );
                
                break ;
                
            case kCameraMoveDirectionUp:
                
                NSLog (@ "Start moving up" );
                
                break ;
                
            case kCameraMoveDirectionRight:
                
                NSLog (@ "--------Start moving right-------" );
                
                break ;
                
            case kCameraMoveDirectionLeft:
                
                NSLog (@ "Start moving left" );
                
                break ;
                
            default :
                
                break ;
                
        }
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded )
        
    {
        
        // now tell the camera to stop
        
        NSLog (@ "Stop" );
        
    }
    
    //    if (direction == kCameraMoveDirectionRight) {
    //        NSLog(@"------------");
    ////        [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
    //
    //        _collectionView.frame = CGRectMake(x+=5, 0, BOUND_Width - 40, BOUND_Height);
    ////            _backView.alpha = 0;
    //
    ////        } completion:^(BOOL finished) {
    ////            _backView.hidden = YES;
    ////        }];
    //    }else if (direction == kCameraMoveDirectionLeft) {
    //        NSLog(@"------------");
    //        //        [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
    //
    //        _collectionView.frame = CGRectMake(x-=5, 0, BOUND_Width - 40, BOUND_Height);
    //        //            _backView.alpha = 0;
    //
    //        //        } completion:^(BOOL finished) {
    //        //            _backView.hidden = YES;
    //        //        }];
    //    }
    
    
}

// This method will determine whether the direction of the user's swipe

- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation

{
    
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
            
        {
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
        
    }
    
    return direction;
    
}

- (NSMutableArray *)dataSourse{
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}

@end
