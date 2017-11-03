//
//  GoodsOrderDetailsModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "GoodsOrderDetailsModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GoodsOrderDetailsModel (CoreDataProperties)

+ (NSFetchRequest<GoodsOrderDetailsModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *addTime;
@property (nullable, nonatomic, copy) NSString *orderId;
@property (nullable, nonatomic, copy) NSString *orderSn;
@property (nonatomic) float goodsAmount;
@property (nullable, nonatomic, copy) NSString *buyerId;
@property (nonatomic) int16_t orderState;
@property (nonatomic) int16_t paymentState;
@property (nonatomic) float orderAmount;
@property (nullable, nonatomic, copy) NSString *storeName;

-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
