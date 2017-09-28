//
//  ComplaintTableViewCell.h
//  guangda_student
//
//  Created by Dino on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintTableViewCell : UITableViewCell

// 投诉状态 0.未解决 1.已解决 2.已取消
@property (assign, nonatomic) int state;
// 教练头像
@property (copy, nonatomic) NSString *coachPortraitUrl;
// 教练姓名
@property (copy, nonatomic) NSString *coachNameStr;
// 任务开始时间
@property (copy, nonatomic) NSString *startTimeStr;
// 任务结束时间
@property (copy, nonatomic) NSString *endTimeStr;
// 投诉内容
@property (strong, nonatomic) NSArray *complainContentArray;
// 投诉内容文字高度
@property (strong, nonatomic) NSArray *complainStrHeightArray;

@property (strong, nonatomic) IBOutlet UIImageView *coachPortraitImageView; // 头像
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;             // 名称
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;                // 状态
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;                  // 时间
@property (strong, nonatomic) IBOutlet UIButton *btnCancelOutlet;           // 取消投诉
@property (strong, nonatomic) IBOutlet UIButton *btnAddOutlet;              // 追加投诉
@property (strong, nonatomic) IBOutlet UIView *complainContentView;         // 投诉内容

// 约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;   // 顶部view的高度约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *complainContentViewHeightCon;


- (void)loadData:(id)data;

@end
