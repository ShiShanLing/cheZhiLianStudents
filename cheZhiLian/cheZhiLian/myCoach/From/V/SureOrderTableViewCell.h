//
//  SureOrderTableViewCell.h
//  guangda_student
//
//  Created by Dino on 15/4/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SureOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLength;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLength;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressDetailLabel;

/**
 *
 */
@property (nonatomic, strong)CoachTimeListModel * model;

@end
