//
//  SolutionCollectionCycleCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SolutionCollectionCycleCell : UICollectionViewCell

@property (strong, nonatomic) NSArray *adsArray;

+ (instancetype)create:(UICollectionView *)coll indexPath:(NSIndexPath *)indexPath;



@end




