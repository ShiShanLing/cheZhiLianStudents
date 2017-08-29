//
//  CommentTableViewCell.h
//  guangda_student
//
//  Created by guok on 15/5/28.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CommentCellType) {
    CommentCellTypeUniversal = 0,   // 用于所有评价
    CommentCellTypeNewest,          // 用于个人最新评价
    CommentCellTypePersonal,        // 用于个人所有评价
};

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nick;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (assign, nonatomic) CommentCellType type;

- (void)loadData;


@end
