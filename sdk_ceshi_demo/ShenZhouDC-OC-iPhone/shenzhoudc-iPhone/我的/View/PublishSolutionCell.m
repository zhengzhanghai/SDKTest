//
//  PublishSolutionCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PublishSolutionCell.h"

@interface PublishSolutionCell()
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *categoryLabel;
@property (strong, nonatomic)  UILabel *statusLabel;
@property (strong, nonatomic)  UILabel *industryLabel;

@end
@implementation PublishSolutionCell

+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifer = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifer];
    PublishSolutionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)setPublishModel:(SolutionPublishModel *)publishModel {
    _publishModel = publishModel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:publishModel.coverImg] placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = publishModel.name;
    _categoryLabel.text = @"  ";
    NSMutableString *muString = [NSMutableString stringWithFormat:@"行业分类:"];
    if (publishModel.industryName && publishModel.industryName.count > 0) {
        for (NSUInteger i = 0; i < publishModel.industryName.count; i++) {
            [muString appendFormat:@"%@%@", publishModel.industryName[i], (i == publishModel.industryName.count-1) ? @"" : @","];
        }
    }
    _statusLabel.text = publishModel.checkStatusStr;
    _industryLabel.text = muString;
}

- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.industryLabel];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(103);
        make.height.mas_equalTo(78);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.mas_equalTo(_icon.mas_top);
        make.right.mas_equalTo(-15);
    }];
//    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_icon.mas_right).offset(10);
//        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
//        make.right.mas_equalTo(-15);
//    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_icon.mas_bottom);
//        make.centerY.mas_equalTo(_categoryLabel.mas_centerY);
    }];
    [_industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
    }];
}


- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = [UIFont systemFontOfSize:14];
        _categoryLabel.textColor = [UIColor darkGrayColor];
    }
    return _categoryLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textColor = MainColor;
    }
    return _statusLabel;
}

- (UILabel *)industryLabel {
    if (!_industryLabel) {
        _industryLabel = [[UILabel alloc] init];
        _industryLabel.font = [UIFont systemFontOfSize:14];
        _industryLabel.textColor = [UIColor darkGrayColor];
    }
    return _industryLabel;
}


@end
