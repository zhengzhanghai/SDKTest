//
//  B_SelectedImagesViewController.m
//  Esalse
//
//  Created by 张丹丹 on 16/4/28.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "SelectedImagesViewController.h"
#import "PhotoSelecterCell.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>



@interface SelectedImagesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PhotoSelecterCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DNImagePickerControllerDelegate, UIAlertViewDelegate,UITextViewDelegate,  UIImagePickerControllerDelegate,UIActionSheetDelegate>


@property(nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation SelectedImagesViewController
//将存放照片的数组初始化
- (NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self preparedUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImg:) name:@"deleteImg" object:nil];
    
    //发布商品成功后，继续添加，进入新增商品页面，通知本页面去掉图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePic) name:@"hidePic" object:nil];
  
}

-(void)deleteImg:(NSNotification *)no {
    self.photos = no.userInfo[@"newImgArr"];
    
    [self.collectionView reloadData];
    
}

-(void)hidePic {
    
    [self.photos removeAllObjects];
    [self.collectionView reloadData];
}


//生成collectionView
- (void)preparedUI{
   
    //照片墙 collectionView 的布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2+80);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionV;
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    collectionV.dataSource = self;
    collectionV.delegate = self;
    collectionV.backgroundColor = [UIColor clearColor];
    [collectionV registerClass:[PhotoSelecterCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma MARK:cellectionView的数据源方法

// MARK: -cellectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photos.count+1;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(80, 80);

}

//每个cell的样子
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    PhotoSelecterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//最后一个
    if (indexPath.row == self.photos.count) {
        if (self.photos.count <= self.photoCount) {
            
            cell.image = [UIImage imageNamed:@"addPicture"];
            cell.removeBtn.hidden = YES;
        }
        
   }else{

        
        id image = self.photos[indexPath.row];
        if ([image isKindOfClass:[UIImage class]]) {
            cell.image = image;
        }
        if ([image isKindOfClass:[NSString class]]) {
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"all_placeholder"]];
            
                [cell.imageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"all_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];

        }
       
        cell.removeBtn.hidden = NO;
    }
    cell.delegate = self;
    
    if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
        [self.delegate reloadUI];
    }
    
    return cell;
}


#pragma mark - collectionview的代理方法
//点击cell的响应事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyBoard" object:nil];
    
    //点击 最后一张图
    if (indexPath.row == self.photos.count) {
        
        if (self.photos.count < self.photoCount) {
            NSLog(@"可以打开了");
            
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择文件来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本地相簿",nil];
            [actionSheet showInView:self.view];
  
        } else {
            NSLog(@"上传图片个数已满9张-- %ld",(long)self.photoCount);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"上传图片个数已满%ld张",(long)self.photoCount] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击  %ld", buttonIndex);

    switch (buttonIndex) {
        case 0://照相机
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                return ;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://本地相簿
        {
            DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
            imagePicker.filterType = DNImagePickerFilterTypePhotos;
            imagePicker.imagePickerDelegate = self;
            imagePicker.maxSelected = self.photoCount - self.photos.count;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    self.assetsArray = [NSMutableArray arrayWithArray:imageAssets];
    for (DNAsset *dnasset in self.assetsArray) {
        
        ALAssetsLibrary *lib = [ALAssetsLibrary new];
        __weak typeof(self) weakSelf = self;
        [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (asset) {
                
                [strongSelf makeImageArrayWith:asset];
        } else {
            
                [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     [group enumerateAssetsWithOptions:NSEnumerationReverse
                                            usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url]){
            [strongSelf makeImageArrayWith:result];
               *stop = YES;
         }
   }];
     }failureBlock:^(NSError *error)
                 {
                    
                 }];
            }
            
        } failureBlock:^(NSError *error){
           
        }];
        
    }
}

-(void)makeImageArrayWith:(ALAsset *)asset{
    
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    [self.photos addObject:image];
    [self.collectionView reloadData];

   
}


- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.photos.count == self.photoCount) return;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([image isKindOfClass:[UIImage class]]) {
        
        [self.photos addObject:image];
      
    }
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - cell的代理方法

-(void)removeButtonClicked:(PhotoSelecterCell *)cell{
    NSLog(@"删除");
    NSIndexPath *indexP = [self.collectionView indexPathForCell:cell];
    [self.photos removeObjectAtIndex:indexP.row];
    [self.collectionView reloadData];
 
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
   
}


@end
