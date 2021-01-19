//
//  MeTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MeTableViewCell.h"


@interface MeTableViewCell ()

@property (nonatomic, strong) NSIndexPath* indexPath;

@end


@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (MeTableViewCell*) makeMeTableViewCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier =  NSStringFromClass([MeTableViewCell class]);
    [tableView registerClass:[MeTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeCell];
    }
 
    return self;
    
}
-(void)makeCell {
    
    self.icon = [[UIImageView alloc]init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = UIColorFromRGB(0x3D4245);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).with.offset(14);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIImageView *enterIcon = [[UIImageView alloc]init];
    enterIcon.image = [UIImage imageNamed:@"icon_right"];
    [self addSubview:enterIcon];
    [enterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    
    self.accessLabel = [[UILabel alloc]init];
    self.accessLabel.font = [UIFont systemFontOfSize:12];
    self.accessLabel.textColor = UIColorFromRGB(0xB5B5B5);
    [self addSubview:self.accessLabel];
    [self.accessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(enterIcon.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
