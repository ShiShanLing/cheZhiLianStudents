//
//  PayViewController.h
//  guangda_student
//
//  Created by 冯彦 on 15/9/28.
//  Copyright © 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface PayViewController : GreyTopViewController

/* input */
@property (copy, nonatomic) NSString *cashNum; // 金额
@property (assign, nonatomic) int purpose; // 0:充值 1:报名支付
@property (strong, nonatomic) NSMutableDictionary *payDict; // 报名支付的参数

@end
