//
//  PublicDispatchCell.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PublicDispatchCell.h"

@interface PublicDispatchCell ()<UITextViewDelegate>

@property (nonatomic, strong) NSIndexPath* indexPath;


@end
@implementation PublicDispatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (PublicDispatchCell*) makePublickDispatchCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier =  NSStringFromClass([PublicDispatchCell class]);
    [tableView registerClass:[PublicDispatchCell class] forCellReuseIdentifier:reuseIdentifier];
    PublicDispatchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
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
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = UIColorFromRGB(0x3D4245);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(LandscapeNumber(16));
        make.top.mas_equalTo(self.mas_top).with.offset(LandscapeNumber(16));
        make.height.mas_equalTo(LandscapeNumber(17));
    }];
    
    self.detailView = [[UITextView alloc]init];
    self.detailView.textContainer.lineBreakMode = NSLineBreakByTruncatingHead;
    self.detailView.font = [UIFont systemFontOfSize:16];
    self.detailView.textColor = UIColorFromRGB(0x666666);
    self.detailView.delegate = self;
    self.detailView.scrollEnabled = NO;
    [self addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH-LandscapeNumber(32));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(48);
    }];
    
    self.placeHolderLabel = [[UILabel alloc]init];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:16];
    self.placeHolderLabel.textColor = UIColorFromRGB(0x666666);
    [self.detailView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailView.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.detailView.mas_centerY).with.offset(-3);
        make.width.mas_equalTo(SCREEN_WIDTH-LandscapeNumber(32));
    }];
    
}
-(void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@",textView.text);
    
    if (textView.text.length != 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
    if(_nameBlock){
        _nameBlock(textView.text);
    }
    
    UITableView *tableV = [self tableView];
    [tableV beginUpdates];
    [tableV endUpdates];
    
}


-(UITableView *)tableView {
    
    UIView *tabview = self.superview;
    
    if (![tabview isKindOfClass:[UITableView class]] && tabview) {
        tabview = tabview.superview;
    }
    return (UITableView *)tabview;
}
@end
