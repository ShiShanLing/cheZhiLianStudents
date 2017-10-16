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
@dynamic trainState;
@dynamic subType;
@dynamic coachName;

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.orderId = [NSString stringWithFormat:@"%@", value];
    }else if([key isEqualToString:@"price"] ){
        NSLog(@"setValue:(id)value forKey:%@",value);
            self.price= [NSString stringWithFormat:@"%@",value];
    }else if([key isEqualToString:@"commentState"] ){
        self.commentState= [NSString stringWithFormat:@"%@",value];
    }else if([key isEqualToString:@"endTime"] ){
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.endTime= detaildate;
    }else if([key isEqualToString:@"startTime"] ){
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        self.startTime= detaildate;
    }else{
        [super setValue:value forKey:key];
    }

}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {


}

@end
