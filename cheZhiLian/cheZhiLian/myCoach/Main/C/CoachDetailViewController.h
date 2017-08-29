//
//  CoachDetailViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/24.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"
/**
 *教练详情
 */
@interface CoachDetailViewController : GreyTopViewController<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSString *coachId;
@property (copy, nonatomic) NSString *carModelID;

@end
