//
//  TradingRecordsModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/12.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "TradingRecordsModel+CoreDataProperties.h"

@implementation TradingRecordsModel (CoreDataProperties)

+ (NSFetchRequest<TradingRecordsModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TradingRecordsModel"];
}

@dynamic createTime;
@dynamic accountType;
@dynamic balanceChange;
@dynamic logId;
@dynamic userType;
@dynamic userId;
@dynamic descriptionStr;
@dynamic couponMemberId;
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"createTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.createTime = detaildate;
    }else  if([key isEqualToString:@"description"]){
        self.descriptionStr = [NSString stringWithFormat:@"%@", value];
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
    
}
@end
