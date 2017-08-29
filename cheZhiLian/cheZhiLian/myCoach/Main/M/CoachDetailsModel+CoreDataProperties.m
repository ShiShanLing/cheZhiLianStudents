//
//  CoachDetailsModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/16.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CoachDetailsModel+CoreDataProperties.h"

@implementation CoachDetailsModel (CoreDataProperties)

+ (NSFetchRequest<CoachDetailsModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CoachDetailsModel"];
}

@dynamic phone;
@dynamic address;
@dynamic realname;

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
