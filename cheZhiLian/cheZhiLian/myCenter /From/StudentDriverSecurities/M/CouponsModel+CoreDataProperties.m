//
//  CouponsModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/12.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "CouponsModel+CoreDataProperties.h"

@implementation CouponsModel (CoreDataProperties)

+ (NSFetchRequest<CouponsModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CouponsModel"];
}

@dynamic couponPic;
@dynamic couponIock;
@dynamic couponLimit;
@dynamic startTimeStr;
@dynamic couponId;
@dynamic couponClassId;
@dynamic identity;
@dynamic couponDesc;
@dynamic startTime;
@dynamic storeName;
@dynamic createTimeStr;
@dynamic couponstorage;
@dynamic createTime;
@dynamic couponIsUsed;
@dynamic couponPrice;
@dynamic couponusage;
@dynamic couponAllowState;
@dynamic endTimeStr;
@dynamic couponGoodsClassId;
@dynamic timeLimit;
@dynamic couponState;
@dynamic storeId;
@dynamic couponMemberId;
@dynamic couponPrintStyle;
@dynamic endTime;
@dynamic couponTitle;
@dynamic couponDuration;

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"startTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.startTime = detaildate;
    }else    if ([key isEqualToString:@"createTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.createTime = detaildate;
    }else    if ([key isEqualToString:@"endTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.endTime = detaildate;
    }else if([key isEqualToString:@"couponState"]){
        self.couponState = [NSString stringWithFormat:@"%@", value];
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
    
}
@end
