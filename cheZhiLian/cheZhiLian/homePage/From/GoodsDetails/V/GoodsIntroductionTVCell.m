//
//  GoodsIntroductionTVCell.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "GoodsIntroductionTVCell.h"



@interface GoodsIntroductionTVCell ()

/**
 驾校logo 或者展示图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

/**
 驾校名字
 */
@property (weak, nonatomic) IBOutlet UILabel *DrivingLabel;
/**
 *商品价钱
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

/**
 *驾校或者 商品的介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end

@implementation GoodsIntroductionTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CourseDetailModel *)model {
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kURL_SHY, model.goodsImage]] placeholderImage:[UIImage imageNamed:@"logo.jpg"]];
    self.DrivingLabel.text = model.goodsName;
    self.goodsPrice.text  = [NSString stringWithFormat:@"¥:%.2f", model.goodsStorePrice];
}
@end
