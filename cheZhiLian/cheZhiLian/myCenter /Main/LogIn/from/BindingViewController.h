//
//  BindingViewController.h
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/31.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface BindingViewController : GreyTopViewController

@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *type;    // 类型：1.QQ登录 2.微信登录  3.微博登录

@end
