//
//  XBWebViewController.h
//  guangda_student
//
//  Created by 冯彦 on 15/11/13.
//  Copyright © 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface XBWebViewController : GreyTopViewController
/* input */
@property (copy, nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *mainUrl;
@property (assign, nonatomic) BOOL closeBtnHidden;
@end
