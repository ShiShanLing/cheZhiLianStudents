//
//  ParsingOrderDataModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "ParsingOrderDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ParsingOrderDataModel (CoreDataProperties)

+ (NSFetchRequest<ParsingOrderDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *coachId;
@property (nullable, nonatomic, copy) NSString *orderId;
@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSString *commentState;
@property (nullable, nonatomic, copy) NSString *studentId;
@property (nonatomic) int16_t state;
@property (nonatomic) int16_t payState;
@property (nonatomic) int16_t trainState;

-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
