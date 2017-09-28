//
//  MyDate.m
//  guangda_student
//
//  Created by 冯彦 on 15/4/5.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "MyDate.h"

@implementation MyDate

- (instancetype)initWithEndYear:(NSString *)year {
    if (self = [super init]) {
        self.year = [[NSMutableArray alloc] init];
        self.month = [[NSMutableArray alloc] init];
        self.day = [[NSMutableArray alloc] init];
        
        int countOfYears = [year intValue] + 1 - 1925;
        for (int i = 0; i < countOfYears; i++) {
            [self.year addObject:[NSString stringWithFormat:@"%d", 1925 + i]];
        }
        
        for (int i = 0; i < 12; i++) {
            [self.month addObject:[NSString stringWithFormat:@"%02d", i+1]];
        }
        
        for (int i = 0; i < 31; i++) {
            [self.day addObject:[NSString stringWithFormat:@"%02d", i+1]];
        }
    }
    return self;
}

- (instancetype)initWithNowYear
{
    if (self = [super init]) {
        self.year = [[NSMutableArray alloc] init];
        self.month = [[NSMutableArray alloc] init];
        self.day = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 10; i++) {
            [self.year addObject:[NSString stringWithFormat:@"%d", 2015 + i]];
        }
        
        for (int i = 0; i < 12; i++) {
            [self.month addObject:[NSString stringWithFormat:@"%02d", i+1]];
        }
        
        for (int i = 0; i < 31; i++) {
            [self.day addObject:[NSString stringWithFormat:@"%02d", i+1]];
        }
    }
    return self;
}

- (instancetype)initWithMaxDayFromNow:(NSInteger)days{
    
    if (self = [super init]) {
        self.year = [[NSMutableArray alloc] init];
        self.month = [[NSMutableArray alloc] init];
        self.day = [[NSMutableArray alloc] init];
        NSDate *now = [NSDate date];
        NSDate *end = [CommonUtil addDate2:now year:0 month:0 day:days];
        NSInteger year = [CommonUtil getYearOfDate:now];
        NSInteger yearEnd = [CommonUtil getYearOfDate:end];
        for (NSInteger i = year; i <= yearEnd; i++) {
            [self.year addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        
        NSInteger month = [CommonUtil getMonthOfDate:now];
        NSInteger monthEnd = [CommonUtil getMonthOfDate:end];
        if(year == yearEnd){
            for (NSInteger i = month; i <= monthEnd; i++) {
                [self.month addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
            }
        }else{
            for (int i = 0; i < 12; i++) {
                [self.month addObject:[NSString stringWithFormat:@"%02d", i+1]];
            }
        }
        
        NSInteger day = [CommonUtil getMonthOfDate:now];
        NSInteger dayEnd = [CommonUtil getMonthOfDate:end];
        
        if(year == yearEnd && month == monthEnd){
            for (NSInteger i = day; i <= dayEnd; i++) {
                [self.month addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
            }
        }else{
            for (int i = 0; i < 31; i++) {
                [self.day addObject:[NSString stringWithFormat:@"%02d", i+1]];
            }
        }
        
        
    }
    return self;
}

@end
