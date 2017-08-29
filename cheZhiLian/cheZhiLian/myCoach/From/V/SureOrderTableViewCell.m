//
//  SureOrderTableViewCell.m
//  guangda_student
//
//  Created by Dino on 15/4/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "SureOrderTableViewCell.h"
#import <CoreText/CoreText.h>

@implementation SureOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CoachTimeListModel *)model {
    self.timeLabel.text = [NSString stringWithFormat:@"%@(开始后的一个小时)", model.timeStr];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元", model.unitPrice];
}

@end
