//
//  ImproveInfoViewController.h
//  guangda_student
//
//  Created by duanjycc on 15/3/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

@interface ImproveInfoViewController : GreyTopViewController



// 性别
@property (strong, nonatomic) IBOutlet UITextField *sexField;
@property (strong, nonatomic) IBOutlet UIButton *sexSelectBtn;
@property (assign, nonatomic) int gender; // 1.男 2.女

// 出生年月
@property (strong, nonatomic) IBOutlet UITextField *birthdayField;
@property (strong, nonatomic) IBOutlet UIButton *birthdaySelectBtn;
@property (copy, nonatomic) NSString *birthday;

// 所在城市
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UIButton *citySelectBtn;
@property (copy, nonatomic) NSString *city;

// 联系地址
@property (strong, nonatomic) IBOutlet UITextField *addrField;
@property (strong, nonatomic) IBOutlet UIImageView *addrPencilImage;
@property (copy, nonatomic) NSString *address;

// 紧急联系人
@property (strong, nonatomic) IBOutlet UITextField *emergentPersonField;
@property (strong, nonatomic) IBOutlet UIImageView *emergentPersonPencilImage;
@property (copy, nonatomic) NSString *urgentPerson;

// 紧急联系电话
@property (strong, nonatomic) IBOutlet UITextField *emergentPhoneField;
@property (strong, nonatomic) IBOutlet UIImageView *emergentPhonePencilImage;
@property (copy, nonatomic) NSString *urgentPhone;

// 选择器
@property (strong, nonatomic) IBOutlet UIView *selectView;
// 性别选择器
@property (strong, nonatomic) IBOutlet UIView *sexView;
@property (nonatomic, strong) IBOutlet UIPickerView *sexPicker;
@property (strong, nonatomic) IBOutlet UIButton *sexConfirmBtn;
@property (strong, nonatomic) NSArray *sexArray;
// 城市选择器
@property (strong, nonatomic) IBOutlet UIView *cityView;
@property (nonatomic, strong) IBOutlet UIPickerView *cityPicker;
@property (strong, nonatomic) IBOutlet UIButton *cityConfirmBtn;
// 日期选择
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *dateConfirmBtn;

// 取消选择
- (IBAction)clickForCancelSelect:(id)sender;
// 确认选择
- (IBAction)clickForSexDone:(id)sender;
- (IBAction)clickForCityDone:(id)sender;
- (IBAction)clickForDateDone:(id)sender;

// 提交数据
- (IBAction)clickForCommit:(id)sender;

@end
