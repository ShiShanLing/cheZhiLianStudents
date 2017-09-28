//
//  ComplaintTableViewCell.m
//  guangda_student
//
//  Created by Dino on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "ComplaintTableViewCell.h"
#import "UIImageView+WebCache.h"

#define CUSTOM_GREEN RGB(80, 203, 140)

@implementation ComplaintTableViewCell

- (void)awakeFromNib {
    self.btnCancelOutlet.layer.borderWidth = 0.7;
    self.btnCancelOutlet.layer.borderColor =  [MColor(80, 203, 240) CGColor];
    self.btnCancelOutlet.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(id)data {
    // 获取数据
    NSDictionary *dic = (NSDictionary *)data;
    _coachPortraitUrl = @""; // 教练头像
    _coachNameStr = @"石山岭"; // 教练姓名
    _startTimeStr = @"2017-08-21 08:00"; // 任务开始时间
    _endTimeStr = @"2017-08-21 09:00"; // 任务结束时间
    self.coachNameLabel.text = [NSString stringWithFormat:@"%@ 教练", _coachNameStr];
    
    if(![CommonUtil isEmpty:_coachPortraitUrl]){
        [_coachPortraitImageView sd_setImageWithURL:[NSURL URLWithString:_coachPortraitUrl] placeholderImage:[UIImage imageNamed:@"login_icon"]];
        
    }
    // 任务时间
    NSArray *startTimeArray = [_startTimeStr componentsSeparatedByString:@" "];
    NSString *startDateStr = startTimeArray[0];
    NSString *startTimeStr = [startTimeArray[1] substringToIndex:5];
    NSArray *endTimeArray = [_endTimeStr componentsSeparatedByString:@" "];
    NSString *endTimeStr = [endTimeArray[1] substringToIndex:5];
    if ([endTimeStr isEqualToString:@"00:00"]) {
        endTimeStr = @"24:00";
    }
    self.timeLabel.text = [NSString stringWithFormat:@"任务时间 %@ %@~%@", startDateStr, startTimeStr, endTimeStr];
    _state = 0;
    if (_state == 0) { // 未解决
        _topViewHeight.constant = 110;
        self.btnCancelOutlet.hidden = NO;
        self.btnAddOutlet.hidden = NO;
        self.statusLabel.text = @"正在处理中";
        self.statusLabel.textColor = MColor(246, 102, 93);
    }
    else { // 已解决
        _topViewHeight.constant = 70;
        self.btnCancelOutlet.hidden = YES;
        self.btnAddOutlet.hidden = YES;
        self.statusLabel.text = @"已解决";
        self.statusLabel.textColor = MColor(81, 203, 142);
    }
    
    while (self.complainContentView.subviews.count) {
        UIView* child = self.complainContentView.subviews.lastObject;
        [child removeFromSuperview];
    }
    
    // 投诉内容列表显示
    int y = 0;
    if (_state == 0) { // 有投诉未解决
            NSString *text =  @"这个教练太帅了影响我练车";
            CGFloat textHeight = [CommonUtil sizeWithString:text fontSize:15 sizewidth:kScreen_widht - 20 sizeheight:MAXFLOAT].height;
            UILabel *complainLabel = [[UILabel alloc] init];
            CGFloat complainLabelX = 10;
            CGFloat complainLabelY = y;
            CGFloat complainLabelW = kScreen_widht - 20;
            CGFloat complainLabelH = textHeight;
            complainLabel.frame = CGRectMake(complainLabelX, complainLabelY, complainLabelW, complainLabelH);
            complainLabel.font = [UIFont systemFontOfSize:15];
            complainLabel.numberOfLines = 0;
            complainLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:MColor(81, 203, 142) range:NSMakeRange(0, text.length)];
          
            complainLabel.attributedText = str;
            [self.complainContentView addSubview:complainLabel];
            y = CGRectGetMaxY(complainLabel.frame) + 15;
        
        
    } else { // 已解决
        for (int i = 0; i < _complainContentArray.count; i++) {
            NSDictionary *oneComDict = _complainContentArray[i];            NSString *complainReason = oneComDict[@"reason"];
            NSString *complainStr = oneComDict[@"content"];
            NSString *text = [NSString stringWithFormat:@"#%@#%@", complainReason, complainStr];
            CGFloat textHeight = [CommonUtil sizeWithString:text fontSize:15 sizewidth:kScreen_widht - 20 sizeheight:MAXFLOAT].height;
            UILabel *complainLabel = [[UILabel alloc] init];
            CGFloat complainLabelX = 10;
            CGFloat complainLabelY = y;
            CGFloat complainLabelW = kScreen_widht - 20;
            CGFloat complainLabelH = textHeight;
            complainLabel.frame = CGRectMake(complainLabelX, complainLabelY, complainLabelW, complainLabelH);
            complainLabel.font = [UIFont systemFontOfSize:15];
            complainLabel.numberOfLines = 0;
            complainLabel.lineBreakMode = NSLineBreakByWordWrapping;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:MColor(115, 119, 128) range:NSMakeRange(0, complainReason.length + 2)];
            complainLabel.attributedText = str;
            [self.complainContentView addSubview:complainLabel];
            y = CGRectGetMaxY(complainLabel.frame) + 15;
        }
    }
    
    
    self.complainContentViewHeightCon.constant = y - 15;
}

@end
