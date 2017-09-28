//
//  GuangdaCoach.m
//  guangda_student
//
//  Created by duanjycc on 15/5/20.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GuangdaCoach.h"

@implementation GuangdaCoach

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _realName = [CommonUtil isEmpty:dict[@"realname"]] ? @"暂无" : dict[@"realname"];
        _tel = [CommonUtil isEmpty:dict[@"tel"]] ? @"暂无" : dict[@"tel"];
        _phone = [CommonUtil isEmpty:dict[@"phone"]] ? @"暂无" : dict[@"phone"];
        _price = [CommonUtil isEmpty:[dict[@"price"] description]] ? @"暂无" : [dict[@"price"] description];
        _score = [dict[@"score"] floatValue];
        _coachid = [dict[@"id"] description];
    }
    return self;
}

+ (instancetype)coachWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (UIView *)createFreeCourseIcon
{
    // 背景
    UIView *iconView = [[UIView alloc] init];
    iconView.width = 13;
    iconView.height = 13;
    iconView.backgroundColor = CUSTOM_RED;
//    iconView.layer.borderWidth = 1;
//    iconView.layer.borderColor = RGB(234, 0, 26).CGColor;
    iconView.layer.cornerRadius = 2;
    iconView.layer.masksToBounds = YES;
    
    // 文字“免”
    UILabel *label = [[UILabel alloc] init];
    [iconView addSubview:label];
    label.frame = iconView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"免";
    
    return iconView;
}

@end
