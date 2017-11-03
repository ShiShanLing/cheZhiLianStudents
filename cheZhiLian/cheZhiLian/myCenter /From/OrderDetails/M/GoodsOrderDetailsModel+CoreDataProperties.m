//
//  GoodsOrderDetailsModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "GoodsOrderDetailsModel+CoreDataProperties.h"

@implementation GoodsOrderDetailsModel (CoreDataProperties)

+ (NSFetchRequest<GoodsOrderDetailsModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GoodsOrderDetailsModel"];
}

@dynamic addTime;
@dynamic orderId;
@dynamic orderSn;
@dynamic goodsAmount;
@dynamic buyerId;
@dynamic orderState;
@dynamic orderAmount;
@dynamic storeName;
@dynamic paymentState;

-(void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"addTime"]) {
       // int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.addTime = detaildate;
    }else {
    
        [super setValue:value forKey:key];
    }

}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}

@end
