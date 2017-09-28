//
//  MessageDetailsViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/1.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    if (_readState == 0) {
        [self postReadNotice];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(0, self.contentView.frame.size.height);
}

#pragma mark - 页面设置
- (void)settingView {
    self.titleLabel.text = _titleStr;
    self.dateLabel.text = _dateStr;
    self.contentLabel.text = _contentStr;
    
    // 计算contentLabel高度
    CGSize contentSize = [CommonUtil sizeWithString:_contentStr fontSize:15 sizewidth:kScreen_widht - 30 sizeheight:MAXFLOAT];
    _contentLabelHeightCon.constant = contentSize.height;
    
    self.contentView.frame = CGRectMake(0, 0, kScreen_widht, 114 - 36 + contentSize.height);
    [self.scrollView addSubview:self.contentView];
}

#pragma mark - 网络请求
// 设置消息为已读
- (void)postReadNotice {
   }

@end
