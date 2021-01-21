//
//  SolutionCollectionCycleCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionCollectionCycleCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ADSModel.h"

@interface SolutionCollectionCycleCell()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *cycleView;
@end

@implementation SolutionCollectionCycleCell

+ (instancetype)create:(UICollectionView *)coll indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [coll registerClass:[self class] forCellWithReuseIdentifier:identifier];
    return [coll dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*117/375) delegate:self placeholderImage:[UIImage imageNamed:@"轮播默认图"]];
    _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.contentView addSubview:_cycleView];
}

- (void)setAdsArray:(NSArray *)adsArray {
    _adsArray = adsArray;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:adsArray.count];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:adsArray.count];
    for (NSUInteger i = 0; i < adsArray.count; i++) {
        ADSModel *model = adsArray[i];
        [titles addObject:model.title];
        [images addObject:model.image];
    }
//    _cycleView.titlesGroup = titles;
    _cycleView.imageURLStringsGroup = images;
}

@end
