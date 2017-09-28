//
//  TypeinNumberViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface TypeinNumberViewController : GreyTopViewController

/* input */
@property (strong, nonatomic) NSString *status; // 状态 1:充值 2:提现
@property (copy, nonatomic) NSString *balance;  // 账户余额

@end
