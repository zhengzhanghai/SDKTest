//
//  FavoriteTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FavoriteTableViewCell.h"

@interface FavoriteTableViewCell ()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *type;
@end

@implementation FavoriteTableViewCell

+ (instancetype)create:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)setModel:(FavoriteModel *)model {
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _title.text = model.goodsName;
    _type.text = [NSString stringWithFormat:@"  %@  ", [model goodsTypeName]];
}

- (void)makeUI {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.type];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(103);
        make.height.mas_equalTo(78);
        make.bottom.mas_equalTo(0);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(10);
        make.top.mas_equalTo(_icon.mas_top);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
    [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_title.mas_left);
        make.bottom.mas_equalTo(_icon.mas_bottom).offset(-5);
        make.height.mas_equalTo(18);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 3;
        _icon.clipsToBounds = true;
        _icon.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = UIColorFromRGB(0x1e1e1e);
        _title.numberOfLines = 2;
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}

- (UILabel *)type {
    if (!_type) {
        _type = [[UILabel alloc] init];
        _type.textColor = UIColorFromRGB(0x1e1e1e);
        _type.font = [UIFont systemFontOfSize:12];
        _type.layer.cornerRadius = 2;
        _type.layer.borderWidth = 0.5;
        _type.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
        _type.clipsToBounds = true;
    }
    return _type;
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
