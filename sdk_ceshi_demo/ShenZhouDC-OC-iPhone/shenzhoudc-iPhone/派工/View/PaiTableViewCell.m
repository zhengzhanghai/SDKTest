//
//  PaiTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PaiTableViewCell.h"
#import "PaiModel.h"
@interface PaiTableViewCell ()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *flagLabel;
@property (nonatomic,strong) UILabel *classLabel;
@property (nonatomic,strong) UILabel *corpLabel;
@end

@implementation PaiTableViewCell

+ (PaiTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath{
    
    NSString *reString = NSStringFromClass([PaiTableViewCell class]);
    [tableView registerClass:[PaiTableViewCell class] forCellReuseIdentifier:reString];
    return [tableView dequeueReusableCellWithIdentifier:reString forIndexPath:indexPath];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUi];
    }
    return  self;
}

- (void)setModel:(PaiModel *)model{
     _model = model;
    NSURL *url = [NSURL URLWithString:model.icon];
//    [_iconView sd_setImageWithURL:url];
    [_iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"列表默认图"] options:SDWebImageProgressiveDownload];
    _titleLabel.text = model.name;
    switch (model.assignStatus.integerValue) {
        case 1:
             _flagLabel.text = @"待抢订单";
            break;
        case 2:
            _flagLabel.text = @"已抢订单";
            break;
  
        default:
            _flagLabel.text = @"结束";
            break;
    }
    _classLabel.text = [NSString stringWithFormat:@"行业分类:%@",model.categoryName];
    _corpLabel.text = model.provinceName;
    
    
}

- (void)setUpUi{
    _iconView = [[UIImageView alloc]init];
    _iconView.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:_iconView];
    __weak typeof (self) weakSelf = self;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.top.equalTo(weakSelf.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"软件定义网络(SDN)SDN技术应用于数据中心网络";
    _titleLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(weakSelf.contentView).offset(11);
    }];
    _flagLabel = [[UILabel alloc]init];
    _flagLabel.text = @"投标中";
    _flagLabel.textColor = [UIColor whiteColor];
    _flagLabel.layer.cornerRadius = 2;
    _flagLabel.layer.masksToBounds = YES;
    _flagLabel.font = [UIFont systemFontOfSize:8];
    _flagLabel.textAlignment = NSTextAlignmentCenter;
    _flagLabel.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1];
    [self.contentView addSubview:_flagLabel];
    [_flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(weakSelf.contentView).offset(59);
        make.size.mas_equalTo(CGSizeMake(35, 13));
    }];
    _classLabel = [[UILabel alloc]init];
    _classLabel.text = @"行业分类:政务";
    _classLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    _classLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_classLabel];
    [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.bottom.equalTo(_iconView.mas_bottom);
    }];
    _corpLabel = [[UILabel alloc]init];
    _corpLabel.text = @"华为技术";
    _corpLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
    _corpLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_corpLabel];
    [_corpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(_classLabel);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
