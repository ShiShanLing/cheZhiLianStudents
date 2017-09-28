//
//  MyDate.h
//  guangda_student
//
//  Created by 冯彦 on 15/4/5.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDate : NSObject

@property (strong, nonatomic) NSMutableArray *year;
@property (strong, nonatomic) NSMutableArray *month;
@property (strong, nonatomic) NSMutableArray *day;

- (instancetype)initWithEndYear:(NSString *)year;
- (instancetype)initWithNowYear;
- (instancetype)initWithMaxDayFromNow:(NSInteger)days;

@end
