//
//  CourseDetailModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/15.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CourseDetailModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailModel (CoreDataProperties)

+ (NSFetchRequest<CourseDetailModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *brandId;
@property (nullable, nonatomic, copy) NSString *cityId;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nonatomic) int16_t commentnum;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSString *createTimeStr;
@property (nonatomic) float esPrice;
@property (nullable, nonatomic, copy) NSString *gcId;
@property (nullable, nonatomic, copy) NSString *gcName;
@property (nonatomic) int16_t giftPoints;
@property (nullable, nonatomic, copy) NSString *goodsAttr;
@property (nullable, nonatomic, copy) NSString *goodsBody;
@property (nonatomic) int16_t goodsClick;
@property (nullable, nonatomic, copy) NSString *goodsColImg;
@property (nonatomic) int16_t goodsCollect;
@property (nonatomic) int16_t goodsCommend;
@property (nullable, nonatomic, copy) NSString *goodsDescription;
@property (nonatomic) int16_t goodsForm;
@property (nullable, nonatomic, copy) NSString *goodsId;
@property (nullable, nonatomic, copy) NSString *goodsImage;
@property (nullable, nonatomic, copy) NSString *goodsImageMore;
@property (nullable, nonatomic, copy) NSString *goodsKeywords;
@property (nullable, nonatomic, copy) NSString *goodsName;
@property (nullable, nonatomic, copy) NSString *goodsSerial;
@property (nonatomic) int16_t goodsShow;
@property (nullable, nonatomic, copy) NSString *goodsSpec;
@property (nullable, nonatomic, copy) NSString *goodsState;
@property (nonatomic) float goodsStorePrice;
@property (nonatomic) float goodsStoreState;
@property (nullable, nonatomic, copy) NSString *goodsSubtitle;
@property (nonatomic) float goodsTotalStorage;
@property (nonatomic) int16_t goodsTransfeeCharge;
@property (nonatomic) float kdPrice;
@property (nullable, nonatomic, copy) NSString *provinceId;
@property (nullable, nonatomic, copy) NSString *provinceName;
@property (nonatomic) float pyPrice;
@property (nonatomic) int16_t salenum;
@property (nullable, nonatomic, copy) NSString *specId;
@property (nullable, nonatomic, copy) NSString *specName;
@property (nonatomic) int16_t specOpen;
@property (nullable, nonatomic, copy) NSString *storeClassId;
@property (nullable, nonatomic, copy) NSString *storeId;
@property (nullable, nonatomic, copy) NSString *storeName;
@property (nullable, nonatomic, copy) NSString *transportId;
@property (nullable, nonatomic, copy) NSString *typeId;
@property (nullable, nonatomic, copy) NSDate *updateTime;
@property (nullable, nonatomic, copy) NSString *updateTimeStr;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
