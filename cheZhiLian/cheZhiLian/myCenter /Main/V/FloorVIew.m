//
//  FloorVIew.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/11/29.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "FloorVIew.h"
#define kHeadPortrait_top 40 //头像上间距

#define kSpacing 5 //控件上下间距
@implementation FloorVIew

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       // self.backgroundColor = [UIColor whiteColor];
        self.TextImage = [UIImageView new];
        _TextImage.tag = 311;
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOne)];
        [_TextImage addGestureRecognizer:tapOne];
        _TextImage.image = [UIImage imageNamed:@"zly"];
        _TextImage.layer.cornerRadius = kFit(37.5);
        _TextImage.layer.masksToBounds = YES;
        _TextImage.layer.borderWidth = 2.0;
        _TextImage.userInteractionEnabled = YES;
        _TextImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self addSubview:_TextImage];
        _TextImage.sd_layout.centerXEqualToView(self).heightIs(kFit(75)).widthIs(kFit(75)).topSpaceToView(self, kHeadPortrait_top);
        
        self.nameLabel = [UILabel new];
        _nameLabel.text = @"未登录";
        _nameLabel.tag = 312;
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOne)];
        [_nameLabel addGestureRecognizer:tapTwo];
        _nameLabel.textAlignment = 1;
        _nameLabel.font = MFont(kFit(15));
       // _nameLabel.backgroundColor = [UIColor orangeColor];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        _nameLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.TextImage, 0).heightIs(kFit(25)).widthIs(kFit(175));
        
    }
    return self;
}

- (void)handleTapOne {

    NSLog(@"311");
    if ([_delegate respondsToSelector:@selector(DataOrIntegral:)]) {
        [_delegate DataOrIntegral:311];
    }
    
}

- (void)handleTapThree {
    
    NSLog(@"313");
    if ([_delegate respondsToSelector:@selector(DataOrIntegral:)]) {
        [_delegate DataOrIntegral:313];
    }
}
@end
