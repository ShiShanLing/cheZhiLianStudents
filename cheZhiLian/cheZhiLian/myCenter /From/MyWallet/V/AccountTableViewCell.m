//
//  AccountTableViewCell.m
//  guangda_student
//
//  Created by Dino on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)loadData:(TradingRecordsModel *)data {
    int amount =data.balanceChange;
    NSString *title = @"测试";
    UIColor *textColor = nil;
    NSString *symbol = nil;
    if (data.accountType == 0) {
        textColor = [UIColor greenColor];
        symbol = @"+";
    } else {
        textColor = [UIColor redColor];
        symbol = @"-";
    }
 //   [self configTitle:title color:textColor symbol:symbol amount:amount];
    self.inOrOut.text = title;
    self.moneyNum.textColor = textColor;
    self.moneyNum.text = [NSString stringWithFormat:@"%@%d", symbol, amount];
    self.dateTimeLabel.text = [CommonUtil getStringForDate:data.createTime];
}

//- (void)configTitle:(NSString *)title color:(UIColor *)color symbol:(NSString *)symbol amount:(NSString *)amount
//{
//    self.inOrOut.text = title;
//    self.moneyNum.textColor = color;
//    self.moneyNum.text = [NSString stringWithFormat:@"%@%@", symbol, amount];
//}

@end
