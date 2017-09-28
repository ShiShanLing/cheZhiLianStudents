//
//  MessageDetailsViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/1.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface MessageDetailsViewController : GreyTopViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) NSString *titleStr;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (copy, nonatomic) NSString *dateStr;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightCon;
@property (copy, nonatomic) NSString *contentStr;

@property (copy, nonatomic) NSString *noticeId;
@property (assign, nonatomic) int readState;

@end
