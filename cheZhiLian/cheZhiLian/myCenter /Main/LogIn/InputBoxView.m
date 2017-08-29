


//
//  InputBoxView.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/20.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "InputBoxView.h"

@implementation InputBoxView

-(instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
     
        self.nameBtn = [UIButton new];//用户名图标 因为UI给的图片宽度不一样 所以用UIButton图片居中的特性 来显示图标
        UIImage *nameImage = [UIImage imageNamed:@"sj"];
        nameImage = [nameImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [_nameBtn setImage:nameImage forState:(UIControlStateNormal)];
        [self addSubview:_nameBtn];
        _nameBtn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(46.5);
        self.NameTF = [UITextField new];
        UIColor *color = MColor(210, 210, 210);
        _NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
        _NameTF.textColor = MColor(255, 255, 255);
        _NameTF.font = MFont(kFit(15));
        [self addSubview:_NameTF];
        _NameTF.sd_layout.leftSpaceToView(_nameBtn, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, kFit(12));
        UILabel *segmentationLabel = [UILabel new];
        segmentationLabel.backgroundColor = MColor(134, 134, 134);
        [self addSubview:segmentationLabel];
        segmentationLabel.sd_layout.leftSpaceToView(self, kFit(12)).bottomSpaceToView(self, 0.5).rightSpaceToView(self, kFit(12)).heightIs(0.5);
    }
    return self;
}

@end
