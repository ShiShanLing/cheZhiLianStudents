//
//  CourseListModel+CoreDataProperties.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/14.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CourseListModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CourseListModel (CoreDataProperties)

+ (NSFetchRequest<CourseListModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *transportId;
@property (nullable, nonatomic, copy) NSString *goodsId;
@property (nonatomic) float pyPrice;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nonatomic) int16_t goodsShow;
@property (nullable, nonatomic, copy) NSString *gcId;
@property (nonatomic) int16_t goodsCommend;
@property (nonatomic) int16_t goodsForm;
@property (nullable, nonatomic, copy) NSString *storeClassId;
@property (nullable, nonatomic, copy) NSString *goodsDescription;
@property (nullable, nonatomic, copy) NSString *goodsName;
@property (nullable, nonatomic, copy) NSString *gcName;
@property (nullable, nonatomic, copy) NSString *storeName;
@property (nonatomic) int16_t goodsStoreState;
@property (nonatomic) int16_t goodsCollect;
@property (nullable, nonatomic, copy) NSString *salenum;
@property (nullable, nonatomic, copy) NSString *kdPrice;
@property (nonatomic) float goodsStorePrice;
@property (nullable, nonatomic, copy) NSString *goodsBody;
@property (nullable, nonatomic, copy) NSString *goodsSubtitle;
@property (nullable, nonatomic, copy) NSString *esPrice;
@property (nullable, nonatomic, copy) NSString *goodsAttr;
@property (nonatomic) int16_t goodsTransfeeCharge;
@property (nullable, nonatomic, copy) NSString *typeId;
@property (nullable, nonatomic, copy) NSString *goodsSerial;
@property (nullable, nonatomic, copy) NSString *provinceName;
@property (nullable, nonatomic, copy) NSString *goodsKeywords;
- (void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
