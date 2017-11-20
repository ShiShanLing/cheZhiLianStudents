//
//  TradingRecordsModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/10/12.
//  Copyright © 2017年 石山岭. All rights reserved.
//
//

#import "TradingRecordsModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TradingRecordsModel (CoreDataProperties)

+ (NSFetchRequest<TradingRecordsModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nonatomic) int16_t accountType;
@property (nonatomic) int64_t balanceChange;

@property (nullable, nonatomic, copy) NSString *logId;
@property (nullable, nonatomic, copy) NSString *descriptionStr;
@property (nonatomic) int16_t userType;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *couponMemberId;

- (void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
