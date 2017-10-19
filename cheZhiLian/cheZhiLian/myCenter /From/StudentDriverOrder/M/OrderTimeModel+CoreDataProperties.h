//
//  OrderTimeModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/19.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "OrderTimeModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OrderTimeModel (CoreDataProperties)

+ (NSFetchRequest<OrderTimeModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *coachId;
@property (nullable, nonatomic, copy) NSString *coachName;
@property (nullable, nonatomic, copy) NSString *commentState;
@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSString *orderId;
@property (nonatomic) int16_t payState;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, copy) NSString *studentId;
@property (nonatomic) int16_t subType;
@property (nonatomic) int16_t trainState;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
