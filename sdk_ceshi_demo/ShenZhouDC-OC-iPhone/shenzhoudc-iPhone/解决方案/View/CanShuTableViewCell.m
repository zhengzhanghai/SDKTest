//
//  CanShuTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "CanShuTableViewCell.h"

@interface CanShuTableViewCell()

@property (nonatomic, strong) UILabel         *title;
@property (nonatomic, strong) UILabel         *content;

@end

@implementation CanShuTableViewCell

+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
//    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
//    [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    CanShuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)refreshCell:(NSString *)title content:(NSString *)content {
    self.title.text = title;
    self.content.text = content;
}

- (void)initUI {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.title);
        make.bottom.mas_equalTo(-15);
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = UIColorFromRGB(0x9B9B9B);
        _title.font = [UIFont systemFontOfSize:14];
        _title.numberOfLines = 0;
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = UIColorFromRGB(0x161616);
        _content.font = [UIFont systemFontOfSize:14];
        _content.numberOfLines = 0;
    }
    return _content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
