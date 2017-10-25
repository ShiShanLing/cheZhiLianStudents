//
//  MyOrderViewController.h
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"


@interface MyOrderViewController : GreyTopViewController

/* input */
@property (assign, nonatomic) int comeFrom; //0:地图主页 1:订单确认预定页面

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
/*
 `id` varchar(32) NOT NULL COMMENT '预约时段id',
 `start_time` bigint(13) DEFAULT NULL COMMENT '开始时间',
 `end_time` bigint(13) DEFAULT NULL COMMENT '结束时间',
 `coach_name` varchar(32) DEFAULT NULL COMMENT '教练真实姓名',
 `coach_id` varchar(32) DEFAULT NULL COMMENT '教练id',
 `price` decimal(11,2) DEFAULT '0.00' COMMENT '价格',
 `state` tinyint(1) DEFAULT '1' COMMENT '时段状态(0:未预约1:已预约3:申请取消中)',
 `open_course` tinyint(1) DEFAULT '0' COMMENT '开课状态(0:未开课,1:已开课)',
 
 `comment_state` tinyint(1) DEFAULT '0' COMMENT '评价状态(0:未评价1:已评价)',
 `pay_state` tinyint(1) DEFAULT '0' COMMENT '支付状态(0:未支付1:已支付)',
 `sub_type` tinyint(1) DEFAULT '0' COMMENT '科目类型(0:代表科目二,1:代表科目三)',
 `vacate_state` tinyint(1) DEFAULT '0' COMMENT '请假状态(0:未请假,1:请假审批中,2:审批通过,3:审批未通过)',
 `train_state` tinyint(1) DEFAULT '0' COMMENT '培训状态(0:未上车 , 1: 已上车 , 2:已下车)',
 `is_del` tinyint(1) DEFAULT '0' COMMENT '是否删除(0:未删除,1:已删除)',
 
 {
 id = 008d7f420a8c4690b333b5b8ba0c1734;
 startTime = 1507597200000;
 endTime = 1507600800000;
 coachName = "\U77f3\U5c71\U5cad\U4e00\U53f7";
 coachId = 1a0bc1131b7c47fcb2514386674aa051;
 price = 180;
 state = 3;
 openCourse = 1;
 commentState = 0;
 payState = 0;
 subType = 0;
 trainState = 0;
 vacateState = 0;
 }
 */
@property (nonatomic, assign)NSInteger index;
@end
