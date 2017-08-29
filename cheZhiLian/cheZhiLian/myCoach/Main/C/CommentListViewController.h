//
//  CommentListViewController.h
//  guangda_student
//
//  Created by guok on 15/5/28.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreyTopViewController.h"
/**
 *评论列表
 */
@interface CommentListViewController : GreyTopViewController<UITabBarDelegate,UITableViewDataSource>

/* input */
@property (strong, nonatomic) NSString *coachid;
@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *studentName;
@property (assign, nonatomic) int type; // 1.所有评论 2.单个学员的评论

@end
