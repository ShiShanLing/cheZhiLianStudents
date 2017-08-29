//
//  timeStateCVCell.m
//  timeChoose
//
//  Created by 石山岭 on 2017/8/3.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "timeStateCVCell.h"
#define MColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
#define  kScreen_heigth [UIScreen mainScreen].bounds.size.height//屏幕高度
#define  kScreen_widht  [UIScreen mainScreen].bounds.size.width//屏幕高度
@implementation timeStateCVCell

-(instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backgroundImage.userInteractionEnabled = NO;
        UIImage *image2 = [UIImage imageNamed:@"time_point_bg_green"];   // 不可用
        _backgroundImage.image= image2;
        _backgroundImage.layer.cornerRadius = 5;
        _backgroundImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_backgroundImage];
        
        // 时间点标识
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 15)];
        _timeLabel.text = [NSString stringWithFormat:@"%d:00", 6];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = 1;
        _timeLabel.font = [UIFont systemFontOfSize:20];
        _timeLabel.tag = 1;
        [self.contentView addSubview:_timeLabel];
        // 科目标识
        self.SubjectName = [[UILabel alloc] initWithFrame:CGRectMake(0, kFit(35), frame.size.width, kFit(13))];
        _SubjectName.text = @"科目三";
        _SubjectName.textColor = [UIColor colorWithRed:52 green:136 blue:153 alpha:1.0];
        _SubjectName.textAlignment = 1;
        _SubjectName.font = [UIFont systemFontOfSize:kFit(12)];
        _SubjectName.tag = 2;
        [self.contentView addSubview:_SubjectName];
        // 价格状态
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kFit(54), frame.size.width, kFit(13))];
        _priceLabel.text = @"120.0元";
        _priceLabel.textColor = MColor(52, 136, 153);
        _priceLabel.textAlignment = 1;
        _priceLabel.font = [UIFont systemFontOfSize:kFit(12)];
        _priceLabel.tag = 3;
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}
- (void)ModifyState:(CoachTimeListModel *)model indexPath:(NSIndexPath *)indexPath section:(NSInteger)section{

    _priceLabel.textColor = MColor(52, 136, 153);
    _priceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.unitPrice];
    _priceLabel.frame = CGRectMake(0, kFit(54), self.frame.size.width, kFit(13));
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = [NSString stringWithFormat:@"%@", model.timeStr];
    int state = [UserDataSingleton mainSingleton].subState.intValue;
    switch (state) {
        case 1:
            _SubjectName.text = @"科目二";
            break;
        case 2:
            _SubjectName.text = @"科目三";
            break;
        default:
            break;
    }
    
    _SubjectName.hidden = NO;
    _priceLabel.hidden = NO;
    int  a = model.state;
    switch (a) {
        case 0:
            self.backgroundImage.image = [UIImage imageNamed:@"time_point_bg_blue"];
            break;
        case 1:
           self.backgroundImage.image = [UIImage imageNamed:@"time_point_bg_grey"];
            _timeLabel.textColor = MColor(179, 179, 179);
            _SubjectName.text = nil;
            _priceLabel.text = @"教练已被\n预约";
            _priceLabel.frame = CGRectMake(0, kFit(35), self.frame.size.width, kFit(30));
            _priceLabel.textColor = MColor(179, 179, 179);
            _priceLabel.numberOfLines = 0;
            break;
        case 2:
            self.backgroundImage.image = [UIImage imageNamed:@"time_point_bg_grey"];
            _timeLabel.textColor = MColor(179, 179, 179);
            _SubjectName.text = nil;
            _priceLabel.text = @"您已预约\n这个教练";
            _priceLabel.frame = CGRectMake(0, kFit(35), self.frame.size.width, kFit(30));
            _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _priceLabel.textColor = [UIColor redColor];
            _priceLabel.numberOfLines = 0;
            break;
        case 3:
           self.backgroundImage.image = [UIImage imageNamed:@"time_point_bg_grey"];
            _timeLabel.textColor = MColor(179, 179, 179);
            _SubjectName.text = nil;
            _priceLabel.text = @"您已预约\n其他教练";
            _priceLabel.frame = CGRectMake(0, kFit(35), self.frame.size.width, kFit(30));
            _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _priceLabel.textColor = [UIColor redColor];
            _priceLabel.numberOfLines = 0;
            break;
        case 4:
            self.backgroundImage.image = [UIImage imageNamed:@"time_point_bg_green"];
            _SubjectName.hidden = YES;
            _priceLabel.hidden = YES;
            break;
        default:
            break;
    }
    
    
}
@end
