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

@property (nullable, nonatomic, copy) NSString * studentId;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSString *id;
@property (nonatomic) int16_t payState;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, copy) NSString * coachId;
@property (nonatomic) float_t unitPrice;
@property (nullable, nonatomic, copy) NSString *timeStr;
@property (nullable, nonatomic, copy) NSString *periodStr;
@property (nonatomic) int16_t openCourse;
-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
