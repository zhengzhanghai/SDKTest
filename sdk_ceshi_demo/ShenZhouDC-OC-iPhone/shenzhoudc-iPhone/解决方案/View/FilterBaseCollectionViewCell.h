//
//  FilterBaseCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonItemModel.h"

@interface FilterBaseCollectionViewCell : UICollectionViewCell
+ (NSString *)cellReuseIdentifier;
- (void)updateCellWithModel:(CommonItemModel *)model;
- (void)tap2SelectItem:(BOOL)selected;
@end
