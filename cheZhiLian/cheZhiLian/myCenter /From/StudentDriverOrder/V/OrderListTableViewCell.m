//
//  OrderListTableViewCell.m
//  guangda_student
//
//  Created by 冯彦 on 15/8/19.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "OrderListTableViewCell.h"


#define CUSTOM_GREY MColor(60, 60, 60)
#define BORDER_WIDTH 0.7
// 颜色
#define CUSTOM_RED MColor(247,100,92)
#define CUSTOM_BLUE MColor(110,197,217)
#define CUSTOM_GREEN MColor(80, 203, 140)
@interface OrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        // 时间
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;        // 日期
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;      // 订单状态
@property (weak, nonatomic) IBOutlet UILabel *coachLabel;       // 教练
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;        // 地址
@property (weak, nonatomic) IBOutlet UILabel *costLabel;        // 金额
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;        // 右边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;         // 左边按钮

@property (weak, nonatomic) IBOutlet UILabel *cancelOrderBannerLabel; // 等待教练取消订单

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadData {
  }
// 订单状态文字配置
- (void)orderStateTextConfig{
    // 未完成订单
}
#pragma mark - 按钮样式
- (void)btnConfig:(UIButton *)btn
  withBorderWidth:(CGFloat)borderWidth
      borderColor:(CGColorRef)borderColor
     cornerRadius:(CGFloat)cornerRadius
  backgroundColor:(UIColor *)backgroundColor
            title:(NSString *)title
       titleColor:(UIColor *)titleColor
           action:(SEL)action
{
    btn.layer.borderWidth = borderWidth;
    btn.layer.borderColor = borderColor;
    btn.layer.cornerRadius = cornerRadius;
    btn.backgroundColor = backgroundColor;
    btn.hidden = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

// 取消订单按钮
- (void)cancelOrderBtnConfig:(UIButton *)btn {
    [self btnConfig:btn withBorderWidth:BORDER_WIDTH
        borderColor:[CUSTOM_GREY CGColor]
       cornerRadius:4
    backgroundColor:[UIColor whiteColor]
              title:@"取消订单"
         titleColor:CUSTOM_GREY
             action:@selector(cancelOrderClick)];
}

// 确认上车按钮
- (void)confirmOnBtnConfig:(UIButton *)btn
{
    [self btnConfig:btn withBorderWidth:0
        borderColor:[[UIColor clearColor] CGColor]
       cornerRadius:4
    backgroundColor:CUSTOM_GREEN
              title:@"确认上车"
         titleColor:[UIColor whiteColor]
             action:@selector(confirmOnClick)];
}

// 确认下车按钮
- (void)confirmDownBtnConfig:(UIButton *)btn
{
    [self btnConfig:btn withBorderWidth:0
        borderColor:[[UIColor clearColor] CGColor]
       cornerRadius:4
    backgroundColor:CUSTOM_GREEN
              title:@"确认下车"
         titleColor:[UIColor whiteColor]
             action:@selector(confirmDownClick)];
}

// 投诉按钮
- (void)complainBtnConfig:(UIButton *)btn
{
    [self btnConfig:btn withBorderWidth:BORDER_WIDTH
        borderColor:[CUSTOM_GREY CGColor]
       cornerRadius:4
    backgroundColor:[UIColor whiteColor]
              title:@"投诉"
         titleColor:CUSTOM_GREY
             action:@selector(complainClick)];
}

// 取消投诉按钮
- (void)cancelComplainBtnConfig:(UIButton *)btn
{
    [self btnConfig:btn withBorderWidth:BORDER_WIDTH
        borderColor:[CUSTOM_GREEN CGColor]
       cornerRadius:4
    backgroundColor:[UIColor whiteColor]
              title:@"取消投诉"
         titleColor:CUSTOM_GREEN
             action:@selector(cancelComplainClick)];
}
// 评价按钮
- (void)eveluateBtnConfig:(UIButton *)btn  {
    [self btnConfig:btn withBorderWidth:0
        borderColor:[[UIColor clearColor] CGColor]
       cornerRadius:4
    backgroundColor:CUSTOM_GREEN
              title:@"立即评价"
         titleColor:[UIColor whiteColor]
             action:@selector(eveluateClick)];
}
// 继续预约按钮
- (void)bookMoreBtnConfig:(UIButton *)btn
{
    [self btnConfig:btn withBorderWidth:BORDER_WIDTH
        borderColor:[CUSTOM_GREEN CGColor]
       cornerRadius:4
    backgroundColor:[UIColor whiteColor]
              title:@"继续预约"
         titleColor:CUSTOM_GREEN
             action:@selector(bookMoreClick)];
}

#pragma mark - 点击事件
// 取消订单
- (void)cancelOrderClick
{
    if ([self.delegate respondsToSelector:@selector(cancelOrder:)]) {
        [self.delegate cancelOrder:_model];
    }
}

// 确认上车
- (void)confirmOnClick
{
    if ([self.delegate respondsToSelector:@selector(confirmOn:)]) {
        [self.delegate confirmOn:_model];
    }
}

// 确认下车
- (void)confirmDownClick
{
    if ([self.delegate respondsToSelector:@selector(confirmDown:)]) {
        [self.delegate confirmDown:_model];
    }
}

// 投诉
- (void)complainClick
{
    if ([self.delegate respondsToSelector:@selector(complain:)]) {
        [self.delegate complain:_model];
    }
}

// 取消投诉
- (void)cancelComplainClick
{
    if ([self.delegate respondsToSelector:@selector(cancelComplain:)]) {
        [self.delegate cancelComplain:_model];
    }
}

// 评价
- (void)eveluateClick {
    if ([self.delegate respondsToSelector:@selector(eveluate:)]) {
        [self.delegate eveluate:_model];
    }
}

// 继续预约
- (void)bookMoreClick {

}

- (void)setModel:(OrderTimeModel *)model {
    _model = model;

    
    NSString *startTime = [CommonUtil getStringForDate:model.startTime format:@"HH:mm"];
    NSString * endTime = [CommonUtil getStringForDate:model.endTime format:@"HH:mm"];
    NSString *time = [CommonUtil getStringForDate:model.startTime format:@"yyyy-MM-dd"];
    self.dateLabel.text = time;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    //self.statusLabel.text = [NSString stringWithFormat:@"离学车还有XX%@",[CommonUtil getTimeDiff:model.startTime]];
    // 教练
    NSString *coachText = nil;
    NSString *nameStr = [NSString stringWithFormat:@"教练: %@ %@", model.coachName ,model.subType==0?@"科目二":@"科目三"];
    NSString *carStr = nil;
    coachText =  nameStr;
    NSMutableAttributedString *coachAttText = [[NSMutableAttributedString alloc] initWithString:coachText];
    [coachAttText addAttribute:NSForegroundColorAttributeName value:MColor(170, 170, 170) range:NSMakeRange(nameStr.length, carStr.length)];
    self.coachLabel.attributedText = coachAttText;
    // 地址
    self.addrLabel.text = [NSString stringWithFormat:@"地址: %@", @"杭州市上城区.婺江路"];
    // 金额 科目类型
    NSString *costText = nil;
   // NSLog(@"model%@ ", model);
    NSString *costStr = [NSString stringWithFormat:@"价格: %@", model.price];
    
    costText = costStr;
    NSMutableAttributedString *costAttText = [[NSMutableAttributedString alloc] initWithString:costText];
    self.costLabel.attributedText = costAttText;
    
    switch (model.trainState) {
        case 0:
            [self complainBtnConfig:self.leftBtn];
            [self eveluateBtnConfig:self.rightBtn];
            if (model.state == 3) {
                self.statusLabel.text = @"订单申请取消中.等待教练确认!";
            }else {
                self.statusLabel.text = @"订单未开始";
            }
            break;
        case 1:
            [self complainBtnConfig:self.leftBtn];
            [self cancelOrderBtnConfig:self.rightBtn];
            self.statusLabel.text = @"学员已上车!";
            break;
        case 2:
            if (model.commentState == 0) {
                self.statusLabel.text = @"订单已经结束,等待您的评论!";
                [self complainBtnConfig:self.leftBtn];
                [self eveluateBtnConfig:self.rightBtn];
            }else {
                [self complainBtnConfig:self.leftBtn];
                self.statusLabel.text = @"已评论!";
            }
            
            break;
        default:
            break;
    }
    //按钮配置
    
    
    self.cancelOrderBannerLabel.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;


}

@end
