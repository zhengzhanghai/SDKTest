//
//  FilterBaseCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "FilterBaseCollectionViewCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation FilterBaseCollectionViewCell
#pragma clang diagnostic pop

+ (NSString *)cellReuseIdentifier {
    NSAssert(NO, @"\nERROR: Must realize this function in subClass %s", __func__);
    return @"";
}
@end
