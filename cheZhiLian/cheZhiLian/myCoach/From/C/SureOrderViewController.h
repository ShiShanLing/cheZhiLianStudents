//
//  SureOrderViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface SureOrderViewController : GreyTopViewController

/* input */
@property (copy, nonatomic) NSString *carModelID;

@property (strong, nonatomic) NSArray *dateTimeSelectedList;
@property (strong, nonatomic) NSString *coachId;
@property (strong, nonatomic) NSString *priceSum;
@property (assign, nonatomic) BOOL needCar; // 是否使用教练车
@property (assign, nonatomic) int rentalFeePerHour; // 教练车租赁费(每小时)

@property (assign, nonatomic) CGFloat payMoney;
@end
