//
//  StudentDriverOrderModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/19.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "StudentDriverOrderModel+CoreDataProperties.h"

@implementation StudentDriverOrderModel (CoreDataProperties)

+ (NSFetchRequest<StudentDriverOrderModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StudentDriverOrderModel"];
}

@dynamic orderTimes;
@dynamic orderAmount;
@dynamic commentState;
@dynamic coachId;
@dynamic payState;
@dynamic orderSn;
@dynamic orderId;
@dynamic couponMemberId;
@dynamic createTime;
@dynamic schoolId;
@dynamic state;
@dynamic schoolName;
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"createTime"]) {
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.createTime = detaildate;
    }else {
        [super setValue:value forKey:key];
    }
    
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
