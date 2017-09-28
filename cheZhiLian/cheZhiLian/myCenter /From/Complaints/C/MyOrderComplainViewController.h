//
//  MyOrderComplainViewController.h
//  guangda_student
//
//  Created by duanjycc on 15/4/1.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface MyOrderComplainViewController : GreyTopViewController

/* input:订单ID */
@property (copy, nonatomic) NSString *orderid;

// orderInfo
@property (strong, nonatomic) IBOutlet UILabel *orderCreateDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderAddrLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *orderAddrLabelHeightCon;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

// 投诉
@property (copy, nonatomic) NSString *complainReasonId;
@property (copy, nonatomic) NSString *complainContentStr;

@end
