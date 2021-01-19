//
//  FavoriteTextTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 2017/9/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "FavoriteTextTableViewCell.h"

@interface FavoriteTextTableViewCell()
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *type;
@property (strong, nonatomic) UIView *sepline;
@end
@implementation FavoriteTextTableViewCell

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
    
    _title.text = model.goodsName;
    _type.text = [NSString stringWithFormat:@"  %@  ", [model goodsTypeName]];
    
}

- (void)makeUI {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.type];
    [self.contentView addSubview:self.sepline];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_title.mas_left);
        make.top.mas_equalTo(_title.mas_bottom).offset(10);
    }];
    [_sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_type.mas_bottom).offset(14);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = UIColorFromRGB(0x1e1e1e);
        _title.numberOfLines = 0;
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

- (UIView *)sepline {
    if (!_sepline) {
        _sepline = [[UIView alloc] init];
        _sepline.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _sepline;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
