//
//  AppointCoachViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/23.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"
#import "SwipeView.h"

@interface AppointCoachViewController : GreyTopViewController

/* input */
@property (copy, nonatomic) NSString *carModelID; // 17:c1 18:c2 19:陪驾
@property (strong, nonatomic) NSDictionary *coachInfoDic;
@property (strong, nonatomic) NSString *coachId;



@end
