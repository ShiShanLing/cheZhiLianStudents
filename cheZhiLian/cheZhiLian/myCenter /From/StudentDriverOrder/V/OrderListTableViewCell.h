//
//  OrderListTableViewCell.h
//  guangda_student
//
//  Created by 冯彦 on 15/8/19.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderListTableViewCellDelegate <NSObject>
//// 取消订单
//- (void)cancelOrder:(GuangdaOrder *)order;
//// 确认上车
//- (void)confirmOn:(GuangdaOrder *)order;
//// 确认下车
//- (void)confirmDown:(GuangdaOrder *)order;
//// 投诉
//- (void)complain:(GuangdaOrder *)order;
//// 取消投诉
//- (void)cancelComplain:(GuangdaOrder *)order;
//// 评价
//- (void)eveluate:(GuangdaOrder *)order;
//// 继续预约
//- (void)bookMore:(GuangdaOrder *)order;
@end

@interface OrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<OrderListTableViewCellDelegate> delegate;

/**
 *
 */
@property (nonatomic, strong)ParsingOrderDataModel *model;

- (void)loadData;

@end
