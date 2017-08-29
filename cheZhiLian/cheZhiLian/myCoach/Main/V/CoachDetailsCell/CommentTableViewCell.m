//
//  CommentTableViewCell.m
//  guangda_student
//
//  Created by guok on 15/5/28.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TQStarRatingView.h"

@interface CommentTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) TQStarRatingView *starView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeftSpaceCon;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    //     教练信息 星级View
    self.starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 68, 12)];
    self.starView.right = kScreen_widht - 41;
    self.starView.centerY = self.scoreLabel.centerY;
    [self.contentView addSubview:_starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
