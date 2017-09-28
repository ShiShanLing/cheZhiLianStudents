//
//  UserDataModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/9/4.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "UserDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *coachId;
@property (nullable, nonatomic, copy) NSString *stuId;
@property (nonatomic) int16_t subState;
@property (nonatomic) int16_t enrollState;
@property (nonatomic) int64_t points;
@property (nullable, nonatomic, copy) NSString *stuCard;
@property (nullable, nonatomic, copy) NSString *idCard;
@property (nullable, nonatomic, copy) NSDate *birthday;
@property (nonatomic) int16_t subTwoTime;
@property (nonatomic) int32_t balance;
@property (nullable, nonatomic, copy) NSString *schoolId;
@property (nonatomic) int16_t state;
@property (nonatomic) int32_t credit;
@property (nullable, nonatomic, copy) NSString *schoolName;
@property (nullable, nonatomic, copy) NSString *subThreeTime;
@property (nonatomic) int16_t ticket;
@property (nonatomic) int16_t sex;
@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *idCardFront;
@property (nullable, nonatomic, copy) NSString *realName;
@property (nullable, nonatomic, copy) NSString *referrer;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSDate *stuCardTime;
@property (nullable, nonatomic, copy) NSString *idCardBack;

- (void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
