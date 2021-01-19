//
//  KeyProjectSurePassPictureCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "KeyProjectSurePassPictureCollectionViewCell.h"

@interface KeyProjectSurePassPictureCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (copy, nonatomic)   KeyProjectSurePassPictureCellImageDownloadFinishBlock imageDownloadFinishBlock;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation KeyProjectSurePassPictureCollectionViewCell

+ (instancetype)createCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath imageDownloadFinish:(KeyProjectSurePassPictureCellImageDownloadFinishBlock)imageDownloadFinishBlock {
    NSString *identifer = NSStringFromClass([self class]);
    [collectionView registerNib:[UINib nibWithNibName:identifer bundle:nil] forCellWithReuseIdentifier:identifer];
    KeyProjectSurePassPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    cell.imageDownloadFinishBlock = imageDownloadFinishBlock;
    cell.indexPath = indexPath;
    return cell;
}

- (void)configWithImage:(NSString *)imageStr {
    __weak typeof(self) weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.imageDownloadFinishBlock) {
            strongSelf.imageDownloadFinishBlock(strongSelf.indexPath, CGSizeMake(image.size.width, image.size.height));
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
