//
//  LearnCarShowTVCell.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "LearnCarShowTVCell.h"

@interface LearnCarShowTVCell ()
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *这个使用的btn 不要介意 拉错了 label就能实现
 */
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;

@end

@implementation LearnCarShowTVCell

-(void)setModel:(CourseListModel *)model {
    
    self.titleLabel.text = model.goodsName;
    [self.priceBtn setTitle:[NSString stringWithFormat:@"¥:%.2f", model.goodsStorePrice] forState:(UIControlStateNormal)];
    
}



-(void)layoutSubviews {
    
    self.icon.userInteractionEnabled = NO;
    self.priceBtn.userInteractionEnabled = NO;
    self.priceBtn.layer.cornerRadius = 3;
    self.priceBtn.layer.masksToBounds = YES;
    self.directionBtn.userInteractionEnabled = NO;

}


@end
