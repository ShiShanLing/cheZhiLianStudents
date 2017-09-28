//
//  CoinListTableViewCell.m
//  guangda_student
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CoinListTableViewCell.h"

@implementation CoinListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadData {
    // 时间
    self.timeLabel.text = @"2017-09-02";
    
    // 数目
    NSString *coinNumStr = nil;
    int a = arc4random()%2 +1;
    if (a == 1) { // 接收者
        coinNumStr = [NSString stringWithFormat:@"+%d",200];
        self.moneyLabel.textColor = [UIColor greenColor];
    } else {
        coinNumStr = [NSString stringWithFormat:@"-%d", 200];
        self.moneyLabel.textColor = [UIColor redColor];
    }
    self.moneyLabel.text = coinNumStr;
    
    // 描述
    NSString *describeStr = nil;
    
    if (a == 1) { // 接收者

        describeStr = [NSString stringWithFormat:@"收入"];
    } else {
        describeStr = [NSString stringWithFormat:@"预约学车支出"];
    }
    self.orderTitle.text = describeStr;
}

@end
