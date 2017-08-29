//
//  MyOrderViewController.h
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"


@interface MyOrderViewController : GreyTopViewController

/* input */
@property (assign, nonatomic) int comeFrom; //0:地图主页 1:订单确认预定页面

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;


@end
