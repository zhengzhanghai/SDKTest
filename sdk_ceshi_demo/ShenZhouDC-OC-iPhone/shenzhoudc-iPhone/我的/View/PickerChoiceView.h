//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPickerDelegate <NSObject>

@optional;
- (void)PickerSelectorIndixString:(NSString *)str AndIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    GenderArray,
    HeightArray,
    weightArray,
    DeteArray,
    ProvinceArray,
    CityArray,
    RegionArray
    
};

@interface PickerChoiceView : UIView

@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic, strong) NSArray *customArr;
@property(nonatomic,strong)NSArray *province;
@property(nonatomic,strong)NSArray *city;
@property(nonatomic,strong)NSArray *region;


@property (nonatomic,strong)UILabel *selectLb;

@property (nonatomic,assign)id<TFPickerDelegate>delegate;
+ (instancetype) shareInstanceIntiWithFrame:(CGRect)frame ;
@end
