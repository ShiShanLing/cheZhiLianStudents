//
//  ParsingOrderDataModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "ParsingOrderDataModel+CoreDataProperties.h"

@implementation ParsingOrderDataModel (CoreDataProperties)

+ (NSFetchRequest<ParsingOrderDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ParsingOrderDataModel"];
}

@dynamic coachId;
@dynamic orderId;
@dynamic endTime;
@dynamic startTime;
@dynamic price;
@dynamic commentState;
@dynamic studentId;
@dynamic state;
@dynamic payState;

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        NSString *str = [NSString stringWithFormat:@"%@", value];
        self.orderId = str.intValue;
    }else {
        [super setValue:value forKey:key];
    }

}
@end
