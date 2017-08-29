//
//  CoachTimeListModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/11.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CoachTimeListModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoachTimeListModel (CoreDataProperties)

+ (NSFetchRequest<CoachTimeListModel *> *)fetchRequest;

@property (nonatomic) int16_t studentId;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nonatomic) int16_t id;
@property (nonatomic) int16_t payState;
@property (nonatomic) int16_t state;
@property (nonatomic) int16_t coachId;
@property (nonatomic) float_t unitPrice;
@property (nullable, nonatomic, copy) NSString *timeStr;
@property (nullable, nonatomic, copy) NSString *periodStr;
-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
