//
//  KeyProjectSurePassPictureCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KeyProjectSurePassPictureCellImageDownloadFinishBlock)(NSIndexPath *indexPath, CGSize imageSize);

@interface KeyProjectSurePassPictureCollectionViewCell : UICollectionViewCell

+ (instancetype)createCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath imageDownloadFinish:(KeyProjectSurePassPictureCellImageDownloadFinishBlock)imageDownloadFinishBlock;

- (void)configWithImage:(NSString *)imageStr;
@end
