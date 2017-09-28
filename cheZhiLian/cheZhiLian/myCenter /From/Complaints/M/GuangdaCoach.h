//
//  GuangdaCoach.h
//  guangda_student
//
//  Created by duanjycc on 15/5/20.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuangdaCoach : NSObject

@property (copy, nonatomic) NSString *realName; // 教练姓名
@property (copy, nonatomic) NSString *tel;      // 教练电话
@property (copy, nonatomic) NSString *phone;    // 教练手机
@property (copy, nonatomic) NSString *price;    // 教练单价
@property (assign, nonatomic) float score;  // 教练评分
@property (strong, nonatomic) NSString *coachid;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)coachWithDict:(NSDictionary *)dict;
+ (UIView *)createFreeCourseIcon;

@end
