//
//  CouponListViewController.h
//  guangda_student
//
//  Created by guok on 15/6/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"



@interface CouponListViewController : GreyTopViewController
//
@property (nonatomic, strong)NSString *type;

@property (nonatomic,copy) void(^obtainCoupons)(NSString *couponsID,NSInteger amount ,NSString *couponsType);

@end
