//
//  UserDataModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/9/4.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "UserDataModel+CoreDataProperties.h"

@implementation UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserDataModel"];
}

@dynamic coachId;
@dynamic stuId;
@dynamic subState;
@dynamic enrollState;
@dynamic points;
@dynamic stuCard;
@dynamic idCard;
@dynamic birthday;
@dynamic subTwoTime;
@dynamic balance;
@dynamic schoolId;
@dynamic state;
@dynamic credit;
@dynamic schoolName;
@dynamic subThreeTime;
@dynamic ticket;
@dynamic sex;
@dynamic avatar;
@dynamic userName;
@dynamic idCardFront;
@dynamic realName;
@dynamic referrer;
@dynamic createTime;
@dynamic phone;
@dynamic stuCardTime;
@dynamic idCardBack;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"birthday"]   ) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.birthday = detaildate;
    }else   if ([key isEqualToString:@"stuCardTime"]   ) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.stuCardTime = detaildate;
    }else if ([key isEqualToString:@"createTime"]   ) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.createTime = detaildate;
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {


}
@end
