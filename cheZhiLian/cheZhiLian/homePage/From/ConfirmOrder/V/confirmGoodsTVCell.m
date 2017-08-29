//
//  confirmGoodsTVCell.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "confirmGoodsTVCell.h"


@interface confirmGoodsTVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end

@implementation confirmGoodsTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CourseDetailModel *)model {
    self.goodsName.text = model.goodsName;
    self.goodsIntroduce.text = model.goodsDescription;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥:%.2f", model.goodsStorePrice];
}
@end
