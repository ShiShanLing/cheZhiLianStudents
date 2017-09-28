//
//  CouponTableViewCell.h
//  guangda_student
//
//  Created by guok on 15/6/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *couponImage;
@property (strong, nonatomic) IBOutlet UILabel *couponTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponPublishLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponEndTime;

@property (strong, nonatomic) IBOutlet UIView *couponTipView;
@property (strong, nonatomic) IBOutlet UILabel *couponStateLabel;

@property (strong, nonatomic) IBOutlet UILabel *labeltitle2;

@end
