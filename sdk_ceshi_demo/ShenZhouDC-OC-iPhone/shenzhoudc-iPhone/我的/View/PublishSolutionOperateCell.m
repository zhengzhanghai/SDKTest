//
//  PublishSolutionOperateCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PublishSolutionOperateCell.h"

@interface PublishSolutionOperateCell ()
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *categoryLabel;
@property (strong, nonatomic)  UILabel *statusLabel;
@property (strong, nonatomic)  UILabel *industryLabel;
@property (strong, nonatomic)  UIButton *operateBtn;
@end

@implementation PublishSolutionOperateCell

+ (instancetype)createWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifer = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifer];
    PublishSolutionOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
    [_operateBtn setTitle:@"确认付款" forState:UIControlStateNormal];
}

- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.industryLabel];
    [self.contentView addSubview:self.operateBtn];
    
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
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.bottom.mas_equalTo(_icon.mas_bottom);
    }];
    [_industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
    }];
    [_operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}

- (void)clickOperateBtn {
    if (_clickBtnBlock) {
        _clickBtnBlock(_publishModel);
    }
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
        _titleLabel.font = [UIFont systemFontOfSize:14];
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
        _industryLabel.font = [UIFont systemFontOfSize:13];
        _industryLabel.textColor = [UIColor darkGrayColor];
    }
    return _industryLabel;
}

- (UIButton *)operateBtn {
    if (!_operateBtn) {
        _operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _operateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _operateBtn.layer.cornerRadius = 3;
        _operateBtn.layer.borderWidth = 0.5;
        _operateBtn.layer.borderColor = MainColor.CGColor;
        [_operateBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [_operateBtn addTarget:self action:@selector(clickOperateBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operateBtn;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
