//
//  ParticipaterCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ParticipaterCell.h"
#import "MyParticipatorModel.h"

@interface ParticipaterCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;

@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ParticipaterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)makeParticipaterCellWithModel:(MyParticipatorModel *)model {
    self.nameLabel.text = model.connectName;
    self.cellNumLabel.text =  @"暂无联系方式";
//    if (self.cellNumLabel.text.length != 0) {
//        //字符串的截取
//        NSString *string = [self.cellNumLabel.text substringWithRange:NSMakeRange(3,5)];
//        //字符串的替换
//        self.cellNumLabel.text = [self.cellNumLabel.text stringByReplacingOccurrencesOfString:string withString:@"****"];
//    }else{
//        self.cellNumLabel.text = @"暂无联系方式";
//    }
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.price];
    NSLog(@"mmmmmm---->%@",model.workingLife);
    if ([model.workingLife isEqualToString:@"null"]) {
        
        self.workLifeLabel.text = @"暂无";
    }else{
        self.workLifeLabel.text = [NSString stringWithFormat:@"%.1f分",[model.global floatValue]];
    }
    
    self.dealLabel.text = [NSString stringWithFormat:@"%@%%",model.ratetype];
    self.recieveLabel.text = [NSString stringWithFormat:@"%@",model.connectNumer];
    
}
@end
