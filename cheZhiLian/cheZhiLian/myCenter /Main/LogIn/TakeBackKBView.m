
//
//  TakeBackKBView.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/19.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "TakeBackKBView.h"

@implementation TakeBackKBView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.backgroundColor =MColor(134, 134, 134);
        [self addSubview:label];
        label.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(0.5);
        
        self.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton new];
        [btn setTitleColor:MColor(255, 66, 84) forState:(UIControlStateNormal)];
        [btn setTitle:@"完成" forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        btn.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(kFit(56));
        
    }
    return self;
}
- (void)handleBtn:(UIButton *)sender {

    if ([_delegate respondsToSelector:@selector(CancelKeyboard)]) {
        [_delegate CancelKeyboard];
    }

}

@end
