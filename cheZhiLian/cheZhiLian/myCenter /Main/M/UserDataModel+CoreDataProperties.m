//
//  UserDataModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/17.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "UserDataModel+CoreDataProperties.h"

@implementation UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserDataModel"];
}

@dynamic memberAvatar;
@dynamic subState;
@dynamic memberName;
@dynamic memberTruename;
@dynamic memberMobile;
@dynamic noPayOrder;
@dynamic memberId;
@dynamic memberRankPoints;
@dynamic noReceiveOrder;
@dynamic coachId;
@dynamic studentId;
-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {



}
@end
