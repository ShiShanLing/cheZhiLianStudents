//
//  CourseListModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/14.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CourseListModel+CoreDataProperties.h"

@implementation CourseListModel (CoreDataProperties)

+ (NSFetchRequest<CourseListModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CourseListModel"];
}

@dynamic transportId;
@dynamic goodsId;
@dynamic pyPrice;
@dynamic cityName;
@dynamic goodsShow;
@dynamic gcId;
@dynamic goodsCommend;
@dynamic goodsForm;
@dynamic storeClassId;
@dynamic goodsDescription;
@dynamic goodsName;
@dynamic gcName;
@dynamic storeName;
@dynamic goodsStoreState;
@dynamic goodsCollect;
@dynamic salenum;
@dynamic kdPrice;
@dynamic goodsStorePrice;
@dynamic goodsBody;
@dynamic goodsSubtitle;
@dynamic esPrice;
@dynamic goodsAttr;
@dynamic goodsTransfeeCharge;
@dynamic typeId;
@dynamic goodsSerial;
@dynamic provinceName;
@dynamic goodsKeywords;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"esPrice"]) {
        self.esPrice = [NSString stringWithFormat:@"%@", value];
    }else if ([key isEqualToString:@"kdPrice"]) {
        self.kdPrice = [NSString stringWithFormat:@"%@", value];
    }else if ([key isEqualToString:@"salenum"]) {
        self.salenum = [NSString stringWithFormat:@"%@", value];
    }else{
        [super setValue:value forKey:key];
    }

}
-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {



}
@end
