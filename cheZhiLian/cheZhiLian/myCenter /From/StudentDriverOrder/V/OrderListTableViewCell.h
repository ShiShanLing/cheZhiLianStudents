//
//  OrderListTableViewCell.h
//  guangda_student
//
//  Created by 冯彦 on 15/8/19.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderListTableViewCellDelegate <NSObject>
// 取消订单
- (void)cancelOrder:(OrderTimeModel *)order;
// 确认上车
- (void)confirmOn:(OrderTimeModel *)order;
// 确认下车
- (void)confirmDown:(OrderTimeModel *)order;
// 投诉
- (void)complain:(OrderTimeModel *)order;
// 取消投诉
- (void)cancelComplain:(OrderTimeModel *)order;
// 评价
- (void)eveluate:(OrderTimeModel *)order;
// 继续预约
- (void)bookMore:(OrderTimeModel *)order;
@end

@interface OrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<OrderListTableViewCellDelegate> delegate;

/**
 *
 */
@property (nonatomic, strong)OrderTimeModel *model;



@end
