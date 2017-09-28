//
//  MessageTableViewCell.h
//  guangda_student
//
//  Created by Dino on 15/4/1.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *redPoint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftJuli;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightCon;

@end
