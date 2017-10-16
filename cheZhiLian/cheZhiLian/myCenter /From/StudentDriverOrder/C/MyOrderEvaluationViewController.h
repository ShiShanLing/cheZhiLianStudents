//
//  MyOrderEvaluationViewController.h
//  guangda_student
//
//  Created by duanjycc on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface MyOrderEvaluationViewController : GreyTopViewController

/* input:订单ID */
@property (copy, nonatomic) NSString *orderid;

// 打分
@property (strong, nonatomic) IBOutlet UIView *teachMannerView;
@property (strong, nonatomic) IBOutlet UILabel *teachMannerScoreLabel;
@property (copy, nonatomic) NSString *teachMannerScoreStr; // 教学态度

@property (strong, nonatomic) IBOutlet UIView *teachQualityView;
@property (strong, nonatomic) IBOutlet UILabel *teachQualityScoreLabel;
@property (copy, nonatomic) NSString *teachQualityScoreStr; // 教学质量

@property (strong, nonatomic) IBOutlet UIView *carQualityView;
@property (strong, nonatomic) IBOutlet UILabel *carQualityScoreLabel;
@property (copy, nonatomic) NSString *carQualityScoreStr; // 车容车貌

// orderInfo
@property (strong, nonatomic) IBOutlet UILabel *orderCreateDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderAddrLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *orderAddrLabelHeightCon;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@end
