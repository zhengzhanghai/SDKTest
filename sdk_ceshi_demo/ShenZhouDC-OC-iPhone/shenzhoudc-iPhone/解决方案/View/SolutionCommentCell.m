//
//  SolutionCommentCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/23.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SolutionCommentCell.h"

@interface SolutionCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation SolutionCommentCell

+ (instancetype)cell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    SolutionCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)setModel:(SolutionCommentModel *)model {
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"userphoto"]];
    _userNameLabel.text = model.userName;
    _contentLabel.text = model.content;
    _timeLabel.text = model.assessTime;
    _commentLabel.text = [NSString stringWithFormat:@"实用性:%d分  创新性:%d分  适用性:%d分  准确性:%d分", model.practicability.intValue, model.novelty.intValue, model.usability.intValue, model.veractiy.intValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _icon.clipsToBounds = true;
    _icon.layer.cornerRadius = 17.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
