//
//  MoreCollectionViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MoreCollectionViewCell.h"
#import "CommonMacro.h"
#import "Masonry.h"
#import "PaiModel.h"
@interface MoreCollectionViewCell ()
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation MoreCollectionViewCell

+ (MoreCollectionViewCell*)customCellWithTableView:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath{
    
    NSString *reString = NSStringFromClass([MoreCollectionViewCell class]);
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:reString];
   MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reString forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUi];
    }
    return self;
}

- (void)setModel:(PaiModel*)model{
     _model = model;
    NSLog(@"%zd组%zd=%@",_indexPath.section,_indexPath.row,model.isSelected);
    [_btn setTitle:model.names forState:UIControlStateNormal];
    if ([model.isSelected isEqualToString:@"YES"]) {
        _btn.selected = YES;
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.layer.borderWidth = 1;
        _btn.layer.borderColor = UIColorFromRGB(0xD71629).CGColor;
    }else{
        _btn.selected = NO;
        _btn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        _btn.layer.borderWidth = 0;
    }
}

- (void)setUpUi{
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    [btn setTitle:@"存储设备" forState:UIControlStateNormal];
    [btn setTitleColor: UIColorFromRGB(0xD71629) forState:UIControlStateSelected];
    [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    _btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)clickBtnEvent:(UIButton*)sender{
    NSLog(@"点击cell.tag = %zd  section = %zd",sender.tag,self.indexPath.section);
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = UIColorFromRGB(0xD71629).CGColor;
        if (_sendTagBlock) {
            _sendTagBlock(_indexPath.section,sender.tag,YES);
        }
    }else{
        sender.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        sender.layer.borderWidth = 0;
        if (_sendTagBlock) {
            _sendTagBlock(_indexPath.section,sender.tag,NO);
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
