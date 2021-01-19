//
//  MenuCell.m
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy,   nonatomic) NSString *norImage;
@property (copy,   nonatomic) NSString *selectImage;

@end

@implementation MenuCell

+ (instancetype)menuCell:(UITableView *)tableView
               indexPath:(NSIndexPath *)indexPath {
    NSString *reString = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reString bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reString];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reString];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)config:(NSString *)title icon:(NSString *)icon {
    self.title.text = title;
    self.icon.image = [UIImage imageNamed:icon];
}

- (void)setNorlal:(NSString *)icon {
    self.icon.image = [UIImage imageNamed:icon];
    self.bgView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.title.textColor = UIColorFromRGB(0x9B9B9B);
}

- (void)setSelect:(NSString *)icon {
    self.icon.image = [UIImage imageNamed:icon];
    self.bgView.backgroundColor = UIColorFromRGB(0xD71629);
    self.title.textColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
