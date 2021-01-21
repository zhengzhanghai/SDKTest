//
//  DetailHeaderView.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "DetailHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface DetailHeaderView ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *textsLabel;
@property (strong, nonatomic) UILabel *monryLabel;
@property (strong, nonatomic) UILabel *taoLabel;
@property (strong, nonatomic) UILabel *divisionLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *allTitleLabel;
@property (strong, nonatomic) UILabel *bottomTitleLabel;
@property (strong, nonatomic) NSString *content;
@end

@implementation DetailHeaderView

+ (instancetype)customHeaaderFooterViewWith:(UITableView*)tableView {
    
    NSString *reString = NSStringFromClass([self class]);
//    UINib *nib = [UINib nibWithNibName:@"DetailHeaderView" bundle:nil];
//    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:reString];
    [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:reString];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:reString];
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        _content =@"<img rseat=\"jj-headImage-img-0923\" src=\"http://pic9.qiyipic.com/common/lego/20150714/ce038b2d449e4f538b8b7d8b684e9ba2.jpg\" /><title>哆啦A梦-动漫动画-全集高清在线观看-爱奇艺</title>日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦A...日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦A...src=\"http://pic9.qiyipic.com/common/lego/20150714/ce038b2d449e4f538b8b7d8b684e9ba2.jpg\"<img rseat=\"jj-headImage-img-0923\" src=\"http://pic9.qiyipic.com/common/lego/20150714/ce038b2d449e4f538b8b7d8b684e9ba2.jpg\" /><title>哆啦A梦-动漫动画-全集高清在线观看-爱奇艺</title>日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦A...日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦A...src=\"http://pic9.qiyipic.com/common/lego/20150714/ce038b2d449e4f538b8b7d8b684e9ba2.jpg\"<img rseat=\"jj-headImage-img-0923\" src=\"http://pic9.qiyipic.com/common/lego/20150714/ce038b2d449e4f538b8b7d8b684e9ba2.jpg\" />";
//        _content = [_content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</br>"];
//        _content = [_content stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
        _content = @"哆啦A梦-动漫动画-全集高清在线观看-爱奇艺</title>日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦A...日本动漫《哆啦A梦》于1991-01-01上映，共0集；爱奇艺为你提供哆啦A梦全集在线观看；哆啦A梦剧情简介：哆啦A梦是一只来自未来世界的猫型机器人，用自己神奇的百宝袋和各种奇妙的道具帮助大雄解决各种困难。哆啦AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA..";
        [self setUpUi];
    }
    return  self;
}

- (void)setModel:(PaiModel *)model{
    if(model.icon != nil){
     _cycleScrollView.imageURLStringsGroup = @[model.icon];
    }
    _titleLabel.text = model.name;
    _monryLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    _textsLabel.text = model.desp;
    CGFloat textsLabelHeight = [GlobleFunction getViewHeight:_textsLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} width:SCREEN_WIDTH - 32];
    CGFloat titleLabelHeight = [GlobleFunction getViewHeight:_titleLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} width:SCREEN_WIDTH - 32];
    CGFloat monryLabelHeight = [GlobleFunction getViewHeight:_monryLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} width:SCREEN_WIDTH - 32];
    CGFloat allLabelHeight = [GlobleFunction getViewHeight:_allTitleLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:26]} width:SCREEN_WIDTH - 32];
    _selfHight = 234 + textsLabelHeight + titleLabelHeight + monryLabelHeight + allLabelHeight + 128;
}
- (void)setUpUi{
    
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 234) delegate:self placeholderImage:[UIImage imageNamed:@"方案ico"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [self addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"软件自定义网络 (SDN) SDN技术应用于数据中心网络";
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines = 2;
    [backView addSubview:_titleLabel];
    __weak typeof(self)weakSelf = self;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(16);
        make.right.equalTo(weakSelf).offset(-16);
        make.top.equalTo(cycleScrollView.mas_bottom).offset(9);
    }];
    
    _monryLabel = [[UILabel alloc]init];
    _monryLabel.text = @"￥9999.00";
    _monryLabel.textColor = [UIColor colorWithRed:214.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1];
    _monryLabel.font = [UIFont systemFontOfSize:20];
    [backView addSubview:_monryLabel];
    [_monryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(11);
    }];
    _taoLabel = [[UILabel alloc]init];
    _taoLabel.text = @"/套";
    _taoLabel.textColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1];
    _taoLabel.font = [UIFont systemFontOfSize:20];
    [backView addSubview:_taoLabel];
    [_taoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_monryLabel.mas_right);
        make.centerY.equalTo(_monryLabel);
    }];
    
    _divisionLabel = [[UILabel alloc]init];
    _divisionLabel.text = @"华为科技";
    _divisionLabel.textColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1];
    _divisionLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_divisionLabel];
    [_divisionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-16);
        make.centerY.equalTo(_monryLabel);
    }];
    _lineView = [[UILabel alloc]init];
    _lineView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:235.0/255.0 alpha:1];
    [backView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(weakSelf);
        make.top.equalTo(_monryLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(9);
    }];
    _allTitleLabel = [[UILabel alloc]init];
    _allTitleLabel.text = @"产品特性与价值";
    _allTitleLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    _allTitleLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:_allTitleLabel];
    [_allTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_lineView.mas_bottom).offset(15);
    }];
//    转换html文本
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    _textsLabel = [[UILabel alloc]init];
    _textsLabel.attributedText = attrStr;
    _textsLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    _textsLabel.numberOfLines = 0;
    _textsLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textsLabel];
    [_textsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_allTitleLabel.mas_bottom).offset(22);
        make.right.left.equalTo(_titleLabel);
    }];
    _bottomTitleLabel = [[UILabel alloc]init];
    _bottomTitleLabel.text = @"优秀技术达人";
    _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    _bottomTitleLabel.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    _bottomTitleLabel.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1];
    _bottomTitleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_bottomTitleLabel];
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_textsLabel.mas_bottom).offset(19);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 42));
    }];

//   CGFloat textsLabelHeight = [GlobleFunction getViewHeight:_content attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} width:SCREEN_WIDTH - 32];
//    CGFloat titleLabelHeight = [GlobleFunction getViewHeight:_titleLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} width:SCREEN_WIDTH - 32];
//    CGFloat monryLabelHeight = [GlobleFunction getViewHeight:_monryLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} width:SCREEN_WIDTH - 32];
//    CGFloat allLabelHeight = [GlobleFunction getViewHeight:_allTitleLabel.text attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:26]} width:SCREEN_WIDTH - 32];
//    _selfHight = 234 + textsLabelHeight + titleLabelHeight + monryLabelHeight + allLabelHeight + 128;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf);
        make.bottom.equalTo(_bottomTitleLabel.mas_bottom);
    }];
 
}


@end
