//
//  CourseDetailModel+CoreDataProperties.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/15.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CourseDetailModel+CoreDataProperties.h"

@implementation CourseDetailModel (CoreDataProperties)

+ (NSFetchRequest<CourseDetailModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CourseDetailModel"];
}

@dynamic brandId;
@dynamic cityId;
@dynamic cityName;
@dynamic commentnum;
@dynamic createTime;
@dynamic createTimeStr;
@dynamic esPrice;
@dynamic gcId;
@dynamic gcName;
@dynamic giftPoints;
@dynamic goodsAttr;
@dynamic goodsBody;
@dynamic goodsClick;
@dynamic goodsColImg;
@dynamic goodsCollect;
@dynamic goodsCommend;
@dynamic goodsDescription;
@dynamic goodsForm;
@dynamic goodsId;
@dynamic goodsImage;
@dynamic goodsImageMore;
@dynamic goodsKeywords;
@dynamic goodsName;
@dynamic goodsSerial;
@dynamic goodsShow;
@dynamic goodsSpec;
@dynamic goodsState;
@dynamic goodsStorePrice;
@dynamic goodsStoreState;
@dynamic goodsSubtitle;
@dynamic goodsTotalStorage;
@dynamic goodsTransfeeCharge;
@dynamic kdPrice;
@dynamic provinceId;
@dynamic provinceName;
@dynamic pyPrice;
@dynamic salenum;
@dynamic specId;
@dynamic specName;
@dynamic specOpen;
@dynamic storeClassId;
@dynamic storeId;
@dynamic storeName;
@dynamic transportId;
@dynamic typeId;
@dynamic updateTime;
@dynamic updateTimeStr;

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"updateTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        
        self.updateTime = detaildate;
    }else if ([key isEqualToString:@"createTime"]) {
        //int 转 nsstring 再转 nsdate
        NSString *str=[NSString stringWithFormat:@"%@", value];
        NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        
        self.createTime = detaildate;
    }else if([key isEqualToString:@"goodsState"] ) {
    
        self.goodsState = [NSString stringWithFormat:@"%@", value];
    
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {

}

@end
