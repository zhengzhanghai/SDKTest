//
//  ProductPictureCollectionCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/9/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductPictureCollectionCell.h"

@implementation ProductPictureCollectionCell

+ (instancetype)create:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [collection registerClass:[self class] forCellWithReuseIdentifier:identifier];
    return [collection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _photoView = [[ProductPhotoView alloc] init];
        _photoView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_photoView];
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
    }
    return self;
}

@end
