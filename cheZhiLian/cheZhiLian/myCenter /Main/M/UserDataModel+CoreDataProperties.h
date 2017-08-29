//
//  UserDataModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/17.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "UserDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *memberAvatar;
@property (nonatomic) int16_t subState;
@property (nullable, nonatomic, copy) NSString *memberName;
@property (nullable, nonatomic, copy) NSString *memberTruename;
@property (nullable, nonatomic, copy) NSString *memberMobile;
@property (nonatomic) int16_t noPayOrder;
@property (nullable, nonatomic, copy) NSString *memberId;
@property (nonatomic) int16_t memberRankPoints;
@property (nonatomic) int16_t noReceiveOrder;
@property (nonatomic) int16_t coachId;
@property (nonatomic) int16_t studentId;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
