//
//  CoachDetailsModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CoachDetailsModel+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoachDetailsModel (CoreDataProperties)

+ (NSFetchRequest<CoachDetailsModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *realName;
@property (nullable, nonatomic, copy) NSString *carTypeName;
@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *reservationNum;

-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
