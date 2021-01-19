//
//  DealRecordCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DealRecordCell.h"
@interface DealRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1;

@end

@implementation DealRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
