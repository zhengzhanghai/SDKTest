//
//  PopMenuViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PopMenuViewCell.h"

@interface PopMenuViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation PopMenuViewCell

+ (instancetype)createCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}

- (void)configWIthTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
