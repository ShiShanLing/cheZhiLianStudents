//
//  GuangdaOrder.m
//  guangda_student
//
//  Created by duanjycc on 15/5/20.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GuangdaOrder.h"
#import "GuangdaCoach.h"

@implementation GuangdaOrder

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 订单信息
        _coachInfoDict = dict[@"cuserinfo"];
        _coach = [GuangdaCoach coachWithDict:dict[@"cuserinfo"]];
        _orderId = [dict[@"orderid"] description];
        _creatTime = [dict[@"creat_time"] description];
        _startTime = [dict[@"start_time"] description];
        _endTime = [dict[@"end_time"] description];
        _detailAddr = [CommonUtil isEmpty:dict[@"detail"]]? @"暂无" : dict[@"detail"];
        _cost = [dict[@"total"] description];
        _delMoney = [dict[@"delmoney"] description];
        _minutes = [dict[@"hours"] intValue];
        _hourArray = dict[@"orderprice"];
        _studentState = [dict[@"studentstate"] intValue];
        _coachState = [dict[@"coachstate"] intValue];
        _carLicense = [dict[@"carlicense"] description];
        _modelid = [dict[@"modelid"] description];
        _subjectName = [dict[@"subjectname"] description];
        _subjectID = [dict[@"subjectid"] description];
        _courseType = [dict[@"coursetype"] description];
        _reason = [dict[@"reason"] description];
        _complaintContent = [dict[@"complaintcontent"] description];
        // 按钮信息
        _canComplain = [dict[@"can_complaint"] intValue];
        _needUncomplain = [dict[@"need_uncomplaint"] intValue];
        _canCancel = [dict[@"can_cancel"] intValue];
        _canUp = [dict[@"can_up"] intValue];
        _canDown = [dict[@"can_down"] intValue];
        _canComment = [dict[@"can_comment"] intValue];
        
        int attachCar = [dict[@"attachcar"] intValue];
        if (attachCar) {
            _needCar = YES;
        } else {
            _needCar = NO;
        }
    }
    return self;
}

+ (instancetype)orderWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)ordersWithArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count > 0) {
        for (NSDictionary *dict in array) {
            [tempArray addObject:[GuangdaOrder orderWithDict:dict]];
        }
    }
    return tempArray;
}

// 未完成订单
+ (instancetype)unCompleteOrderWithDict:(NSDictionary *)dict
{
    GuangdaOrder *order = [[self alloc] initWithDict:dict];
    order.orderType = OrderTypeUncomplete;
    return order;
}

+ (NSMutableArray *)unCompleteOrdersWithArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count > 0) {
        for (NSDictionary *dict in array) {
            [tempArray addObject:[GuangdaOrder unCompleteOrderWithDict:dict]];
        }
    }
    return tempArray;
}

// 待评价订单
+ (instancetype)waitEvaluateOrderWithDict:(NSDictionary *)dict
{
    GuangdaOrder *order = [[self alloc] initWithDict:dict];
    order.orderType = OrderTypeWaitEvaluate;
    return order;
}

+ (NSMutableArray *)waitEvaluateOrdersWithArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count > 0) {
        for (NSDictionary *dict in array) {
            [tempArray addObject:[GuangdaOrder waitEvaluateOrderWithDict:dict]];
        }
    }
    return tempArray;
}

// 已完成订单
+ (instancetype)completeOrderWithDict:(NSDictionary *)dict
{
    GuangdaOrder *order = [[self alloc] initWithDict:dict];
    order.orderType = OrderTypeComplete;
    return order;
}

+ (NSMutableArray *)completeOrdersWithArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count > 0) {
        for (NSDictionary *dict in array) {
            [tempArray addObject:[GuangdaOrder completeOrderWithDict:dict]];
        }
    }
    return tempArray;
}

// 待处理订单
+ (instancetype)complainedOrderWithDict:(NSDictionary *)dict
{
    GuangdaOrder *order = [[self alloc] initWithDict:dict];
    order.orderType = OrderTypeAbnormal;
    return order;
}

+ (NSMutableArray *)complainedOrdersWithArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count > 0) {
        for (NSDictionary *dict in array) {
            [tempArray addObject:[GuangdaOrder complainedOrderWithDict:dict]];
        }
    }
    return tempArray;
}

@end

