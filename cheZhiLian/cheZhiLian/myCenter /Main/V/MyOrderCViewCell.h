//
//  MyOrderCViewCell.h
//  EntityConvenient
//
//  Created by 石山岭 on 2016/11/29.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWave.h"
#import "FloorVIew.h"

@protocol MyOrderCViewCellDelegate <NSObject>
/**
 *订单选择  160 161 162 163 164 依次排列   311是点击用户名个头像的事件 313 是点击积分显示view的事件
 */
- (void)MyOrderChoose:(int)index;


@end

/**
 *我的界面第一个cell
 */
@interface MyOrderCViewCell : UITableViewCell

/**
 *用户头像
 */
@property (nonatomic, strong)FloorVIew *floorView;//view;
@property (nonatomic, strong)JSWave *headerView;//波浪头型
@property (nonatomic, assign)id<MyOrderCViewCellDelegate>delegate;
/**
 *
 */
@property (nonatomic, strong)UserDataModel *model;
/**
 *科目状态0:未通过任何科目, 1:科目一已通过, 2:科目二已通过, 3:科目三已通过, 4:科目四已通过
 */
@property (nonatomic, strong)UILabel * subjectsShow;
//这里来判断如果数据为空就给默认图片
- (void)SetDefaultValue;

@end
