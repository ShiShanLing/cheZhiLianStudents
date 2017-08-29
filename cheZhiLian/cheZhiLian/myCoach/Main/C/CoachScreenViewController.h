//
//  CoachScreenViewController.h
//  guangda_student
//
//  Created by Dino on 15/4/24.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//
#import "GreyTopViewController.h"

@interface CoachScreenViewController : GreyTopViewController
/* input */
@property (copy, nonatomic) NSString *comeFrom; // 1:从主页跳转过来 2:从教练列表跳转过来
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *btnGoSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
// 时间段
@property (strong, nonatomic) NSDate *dateScreenBegin;      // 开始日期
@property (strong, nonatomic) NSDate *dateScreenEnd;
@property (strong, nonatomic) IBOutlet UILabel *dateBeginLabel;     // 日期label
@property (strong, nonatomic) IBOutlet UIButton *leftUpBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightUpBtn;
// 教练星级
@property (strong, nonatomic) NSString *starLevel;
@property (strong, nonatomic) UITextField *nowTextField;
//底部的view
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewBottomSpaceCon;
// 日期选择器
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) NSString *myYear;
@property (strong, nonatomic) NSString *myMonth;
@property (strong, nonatomic) NSString *myDay;

@property (strong, nonatomic) NSString *carTypeId;
@property (strong, nonatomic) NSString *subjectID;


- (IBAction)clickForSubjectNone:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *subjectNoneButton;
//教练赛选
@property (strong, nonatomic) IBOutlet UIView *selectContentView;
@property (strong, nonatomic) IBOutlet UIView *selectSubjectView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectSubjevtViewHeight;
@property (strong, nonatomic) NSDictionary *searchDic;



@end
