//
//  StarScoreView.m
//  StarRatingTest
//
//  Created by 冯彦 on 15/11/12.
//  Copyright © 2015年 冯彦. All rights reserved.
//

#import "StarScoreView.h"

#define GAP_BETWEEN_STAR 2
@interface StarScoreView ()
@property (strong, nonatomic) UIView *starBackgroundView;
@property (strong, nonatomic) UIView *starForegroundView;
@end

@implementation StarScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:5];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(int)number {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        
    }
    return self;
}

- (UIView *)buildStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    
    CGFloat width = floor((CGRectGetWidth(frame) - GAP_BETWEEN_STAR * (_numberOfStar - 1)) / _numberOfStar);
    for (int i = 0; i < _numberOfStar; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return view;
}

@end
