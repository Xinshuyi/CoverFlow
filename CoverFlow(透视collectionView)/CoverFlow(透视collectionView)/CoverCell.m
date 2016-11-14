//
//  CoverCell.m
//  CoverFlow(透视collectionView)
//
//  Created by xin on 2016/11/12.
//  Copyright © 2016年 DogeEggEgg. All rights reserved.
//

#import "CoverCell.h"
@interface CoverCell()
@property (nonatomic ,strong) UIImageView *iconView;
@end
@implementation CoverCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 新建图片view
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
    }
    return self;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _iconView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.iconView.image = image;
}
@end
