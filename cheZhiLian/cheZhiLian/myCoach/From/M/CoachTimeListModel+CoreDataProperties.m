//
//  CoachTimeListModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/11.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CoachTimeListModel+CoreDataProperties.h"

@implementation CoachTimeListModel (CoreDataProperties)

+ (NSFetchRequest<CoachTimeListModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CoachTimeListModel"];
}

@dynamic studentId;
@dynamic startTime;
@dynamic endTime;
@dynamic id;
@dynamic payState;
@dynamic state;
@dynamic coachId;
@dynamic timeStr;
@dynamic unitPrice;
@dynamic periodStr;
@dynamic openCourse;
-(void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"startTime"]) {
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.startTime = detaildate;
        self.timeStr = @"0";
    }else if ([key isEqualToString:@"endTime"]) {
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.endTime = detaildate;
    }else {
       [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {


}

@end
