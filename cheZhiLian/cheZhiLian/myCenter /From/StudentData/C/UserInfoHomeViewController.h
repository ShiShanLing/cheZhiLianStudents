//
//  UserInfoHomeViewController.h
//  guangda
//
//  Created by duanjycc on 15/3/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface UserInfoHomeViewController : GreyTopViewController

@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (copy, nonatomic) NSString *avatar; // 头像的url
@property (strong, nonatomic) IBOutlet UIView *userView;

@property (strong, nonatomic) IBOutlet UILabel *nameField;
@property (copy, nonatomic) NSString *realname;
@property (assign, nonatomic)CGFloat score;

@end
