//
//  StudentDriverOrderModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/19.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "StudentDriverOrderModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StudentDriverOrderModel (CoreDataProperties)

+ (NSFetchRequest<StudentDriverOrderModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *orderTimes;
@property (nonatomic) float orderAmount;
@property (nonatomic) int16_t commentState;
@property (nullable, nonatomic, copy) NSString *coachId;
@property (nonatomic) int16_t payState;
@property (nullable, nonatomic, copy) NSString *orderSn;
@property (nullable, nonatomic, copy) NSString *orderId;
@property (nullable, nonatomic, copy) NSString *couponMemberId;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSString * schoolId;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, copy) NSString *schoolName;
- (void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
