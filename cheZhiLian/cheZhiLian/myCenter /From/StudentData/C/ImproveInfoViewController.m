//
//  ImproveInfoViewController.m
//  guangda_student
//
//  Created by duanjycc on 15/3/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

// 个人信息
#import "ImproveInfoViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MyDate.h"
#import "LoginViewController.h"
#import "XBProvince.h"

@interface ImproveInfoViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
    int j;
}
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView  *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;

// 日期选择器数据
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateComponents *selectedDateComponets;

@property (strong, nonatomic) MyDate *myPickerDate;
@property (strong, nonatomic) NSString *myYear;
@property (strong, nonatomic) NSString *myMonth;
@property (strong, nonatomic) NSString *myDay;

// 地址选择器数据
@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) XBProvince *curProvince;
@property (strong, nonatomic) XBCity *curCity;
@property (strong, nonatomic) XBArea *curArea;
@property (copy, nonatomic) NSString *selectProvinceID;
@property (copy, nonatomic) NSString *selectCityID;
@property (copy, nonatomic) NSString *selectAreaID;

@end

@implementation ImproveInfoViewController
- (IBAction)ReturnPreviousPage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    
    // 日期选择
    self.myPickerDate = [[MyDate alloc] initWithEndYear:@"2015"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self showLocalData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 页面设置
- (void)settingView {
    [self.mainScrollView contentSizeToFit];

    self.addrField.delegate = self;
    self.emergentPersonField.delegate = self;
    self.emergentPhoneField.delegate = self;
    
    [self.sexSelectBtn addTarget:self action:@selector(clickForSexSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.citySelectBtn addTarget:self action:@selector(clickForCitySelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.birthdaySelectBtn addTarget:self action:@selector(clickForDateSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.emergentPhoneField addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    
    // 选择器
    self.selectView.frame = [UIScreen mainScreen].bounds;
    
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    
    self.sexConfirmBtn.layer.borderWidth = 1;
    self.sexConfirmBtn.layer.borderColor = [MColor(248, 99, 95) CGColor];
    self.sexConfirmBtn.layer.cornerRadius = 4;
    
    self.cityConfirmBtn.layer.borderWidth = 1;
    self.cityConfirmBtn.layer.borderColor = [MColor(248, 99, 95) CGColor];
    self.cityConfirmBtn.layer.cornerRadius = 4;
    
    self.dateConfirmBtn.layer.borderWidth = 1;
    self.dateConfirmBtn.layer.borderColor = [MColor(248, 99, 95) CGColor];
    self.dateConfirmBtn.layer.cornerRadius = 4;
    
    [self initSexData];
//    [self initCityData];
    
    // 点击背景退出键盘
    [self keyboardHiddenFun];
}

// 显示本地数据
- (void)showLocalData {
    [self loadLocalData];
    NSString *genderStr = (_gender == 2)? @"女" : @"男";
    self.sexField.text = genderStr;
    self.birthdayField.text = _birthday;
    self.cityField.text = _city;
    self.addrField.text = _address;
    self.emergentPersonField.text = _urgentPerson;
    
    // 电话号码以3-4-4格式显示
    if (![CommonUtil isEmpty:_urgentPhone]) {
//        NSMutableString *phone = [[NSMutableString alloc] initWithString:_urgentPhone];
//        [phone insertString:@" " atIndex:3];
//        [phone insertString:@" " atIndex:8];
        self.emergentPhoneField.text = _urgentPhone;
    }
}

- (void)testDateSetting {
    self.calendar = [NSCalendar currentCalendar];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.selectedDateComponets = [[NSDateComponents alloc] init];
}

#pragma mark - 页面特性
// 点击背景退出键盘
- (void)keyboardHiddenFun {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backupgroupTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   // 只需要点击非文字输入区域就会响应
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}
-(void)backupgroupTap:(id)sender{
    [self.addrField resignFirstResponder];
    [self.emergentPersonField resignFirstResponder];
    [self.emergentPhoneField resignFirstResponder];
}

// 开始编辑，铅笔变红
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_redpencil_userbaseinfo"];
    
    if ([textField isEqual:self.addrField]) {
        [self.addrPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.emergentPersonField]) {
        [self.emergentPersonPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.emergentPhoneField]) {
        [self.emergentPhonePencilImage setImage:image];
    }
}

// 结束编辑，铅笔变灰
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_pencil_userinfocell"];
    
    if ([textField isEqual:self.addrField]) {
        [self.addrPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.emergentPersonField]) {
        [self.emergentPersonPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.emergentPhoneField]) {
        [self.emergentPhonePencilImage setImage:image];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    
    return YES;
}

#pragma mark - PickerVIew
// 数据
- (void)initSexData {
    _sexArray = [NSArray arrayWithObjects:@"男", @"女", nil];
}

- (void)initCityData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"china.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"china"];
    self.provinces = [XBProvince provincesWithArray:array];
    
    self.curProvince = self.provinces[0];
    self.curCity = self.curProvince.citiesArray[0];
    self.curArea = self.curCity.areasArray[0];
}

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0;
}

// 组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:self.sexPicker]) {
        return 1;
    }
    else if ([pickerView isEqual:self.cityPicker]) {
        return 3;
    }
    else if ([pickerView isEqual:self.datePicker]) {
        return 3;
    }
    else {
        return 0;
    }
}

// 每组行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([pickerView isEqual:self.sexPicker]) {
        return _sexArray.count;
    }
    
    else if ([pickerView isEqual:self.cityPicker]) {
        // 省
        if (component == 0) {
            return self.provinces.count;
        }
        // 市
        else if (component == 1) {
            return self.curProvince.citiesArray.count;
        }
        // 区
        else {
            return self.curCity.areasArray.count;
        }
    }

    else if ([pickerView isEqual:self.datePicker]) {
        switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
            case 0: { // 第一栏为年
                return self.myPickerDate.year.count;
            }
            case 1: // 第二栏为月份
                return 12;
            case 2: { // 第三栏为对应月份的天数
                int selectMonth = [_myMonth intValue];
                if (selectMonth == 1 || selectMonth == 3 || selectMonth == 5 || selectMonth == 7 || selectMonth == 8 || selectMonth == 10 || selectMonth == 12) {
                    return 31;
                }
                else if (selectMonth == 4 || selectMonth == 6 || selectMonth == 9 || selectMonth == 11) {
                    return 30;
                }
                else if (selectMonth == 2) {
                    int selectYear = [_myYear intValue];
                    if ((selectYear % 4 == 0 && selectYear % 100 != 0) || selectYear % 400 == 0) {
                        return 29;
                    }
                    else {
                        return 28;
                    }
                }
            }
            default:
                return 0;
        }
    }
    
    else {
        return 0;//如果不是就返回0
    }
}

// 自定义每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    
    // 性别选择器
    if ([pickerView isEqual:self.sexPicker]) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 45)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [_sexArray objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:21];         //用label来设置字体大小
        
        myView.textColor = [UIColor whiteColor];
        
        myView.backgroundColor = [UIColor clearColor];
        
        return myView;
    }
    
    // 城市选择器
    else if ([pickerView isEqual:self.cityPicker]) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 45)];
        myView.font = [UIFont systemFontOfSize:18];         //用label来设置字体大小
        myView.textColor = [UIColor whiteColor];
        myView.backgroundColor = [UIColor clearColor];
        myView.textAlignment = NSTextAlignmentCenter;
        // 省
        if (component == 0) {
            XBProvince *province = [self.provinces objectAtIndex:row];
            myView.text = province.provinceName;
        }
        // 市
        else if (component == 1) {
            XBCity *city = self.curProvince.citiesArray[row];
            myView.text = city.cityName;
        }
        // 区
        else {
            XBArea *area = self.curCity.areasArray[row];
            myView.text = area.areaName;
        }
        return myView;
    }
    
    // 日期选择器
    else if ([pickerView isEqual:self.datePicker]) {
        
        UILabel *dateLabel = (UILabel *)view;
        if (!dateLabel) {
            dateLabel = [[UILabel alloc] init];
            [dateLabel setFont:[UIFont systemFontOfSize:21]];
            [dateLabel setTextColor:[UIColor whiteColor]];
            [dateLabel setBackgroundColor:[UIColor clearColor]];
        }
        
        switch (component) {
            case 0: {
                NSString *currentYear = self.myPickerDate.year[row];
                [dateLabel setText:currentYear];
                dateLabel.textAlignment = NSTextAlignmentRight;
                break;
            }
            case 1: {
                
                NSString *currentMonth = self.myPickerDate.month[row];
                [dateLabel setText:[NSString stringWithFormat:@"%@月",currentMonth]];
                dateLabel.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case 2: {
                NSString *currentDay = self.myPickerDate.day[row];
                [dateLabel setText:currentDay];
                dateLabel.textAlignment = NSTextAlignmentLeft;
                break;
            }
            default:
                break;
        }
        
        return dateLabel;
    }
    
    else {
        return myView;
    }
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.datePicker]) {
        switch (component) {
            case 0: {
                _myYear = self.myPickerDate.year[row];
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:pickerView didSelectRow:0 inComponent:2];
                break;
            }
            case 1: {
                _myMonth = self.myPickerDate.month[row];
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:pickerView didSelectRow:0 inComponent:2];
                break;
            }
            case 2: {
                _myDay = self.myPickerDate.day[row];
                break;
            }
            default:
                break;
        }
        //        [pickerView reloadAllComponents];
    }
    
    if ([pickerView isEqual:self.cityPicker]) {
        // 省
        if (component == 0) {
            self.curProvince = self.provinces[row];
            self.curCity = self.curProvince.citiesArray[0];
            self.curArea = self.curCity.areasArray[0];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }
        // 市
        else if (component == 1) {
            self.curCity = self.curProvince.citiesArray[row];
            self.curArea = self.curCity.areasArray[0];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        // 区
        else {
            self.curArea = self.curCity.areasArray[row];
        }
    }
}

#pragma mark - 网络请求
// 提交账号信息
- (void)postPerfectPersonInfo {
 
    NSString *URL_Str = [NSString stringWithFormat:@""];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    __weak  ImproveInfoViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];


}

- (void) backLogin{
 

}

#pragma mark - 数据处理
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

// 取得页面数据
- (void)catchInputData {
    _gender = [self.sexField.text isEqualToString:@"男"]? 1 : 2;
    _birthday = self.birthdayField.text;
    _address = self.addrField.text;
    _urgentPerson = self.emergentPersonField.text;
    _urgentPhone = [self.emergentPhoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 页面数据本地化
- (void)locateData {
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSMutableDictionary *new_user_info = [NSMutableDictionary dictionaryWithDictionary:user_info];
    [new_user_info setObject:[NSNumber numberWithInt:_gender] forKey:@"gender"];
    [new_user_info setObject:_birthday forKey:@"birthday"];
    [new_user_info setObject:_address forKey:@"address"];
    [new_user_info setObject:_urgentPerson forKey:@"urgent_person"];
    [new_user_info setObject:_urgentPhone forKey:@"urgent_phone"];
    [CommonUtil saveObjectToUD:new_user_info key:@"UserInfo"];
}

// 加载本地数据
- (void)loadLocalData {
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    _gender = [[user_info objectForKey:@"gender"] intValue];
    _birthday = [user_info objectForKey:@"birthday"];
    _address = [user_info objectForKey:@"address"];
    _urgentPerson = [user_info objectForKey:@"urgent_person"];
    _urgentPhone = [user_info objectForKey:@"urgent_phone"];
    
    if (![CommonUtil isEmpty:_birthday]) {
        NSArray *subStr = [_birthday componentsSeparatedByString:@"-"];
        if (subStr.count == 3) {
            _myYear = subStr[0];
            _myMonth = subStr[1];
            _myDay = subStr[2];
        }
    }
}

#pragma mark - 点击事件
- (IBAction)clickForCommit:(id)sender {
    [self postPerfectPersonInfo];
}

// 开启性别选择
- (void)clickForSexSelect:(UIButton *)sender {
    self.sexView.hidden = NO;
    self.cityView.hidden = YES;
    self.dateView.hidden = YES;
    [self.view addSubview:self.selectView];
}

// 完成性别选择
- (IBAction)clickForSexDone:(id)sender {
    NSInteger row = [self.sexPicker selectedRowInComponent:0];
    self.sexField.text = _sexArray[row];
    [self.selectView removeFromSuperview];
}

// 开启城市选择
- (void)clickForCitySelect:(UIButton *)sender {
    self.sexView.hidden = YES;
    self.cityView.hidden = NO;
    self.dateView.hidden = YES;
    [self.view addSubview:self.selectView];
}

// 完成城市选择
- (IBAction)clickForCityDone:(id)sender {
    NSString *addrStr = nil;
    NSString *areaStr = [self.curArea.areaName stringByReplacingOccurrencesOfString:@"  " withString:@""];
//    if (self.curProvince.isZxs) { // 直辖市
//        addrStr = [NSString stringWithFormat:@"%@-%@", self.curProvince.provinceName, areaStr];
//    } else {
        addrStr =  [NSString stringWithFormat:@"%@-%@-%@", self.curProvince.provinceName, self.curCity.cityName, areaStr];
//    }
    self.cityField.text = addrStr;
    self.selectProvinceID = self.curProvince.provinceID;
    self.selectCityID = self.curCity.cityID;
    self.selectAreaID = self.curArea.areaID;
    
    [self.selectView removeFromSuperview];
}

// 开启日期选择
- (void)clickForDateSelect:(UIButton *)sender {
    self.sexView.hidden = YES;
    self.cityView.hidden = YES;
    self.dateView.hidden = NO;
    
    int yearRow = 0;
    int monthRow = 0;
    int dayRow = 0;
    if ([CommonUtil isEmpty:_myYear] && [CommonUtil isEmpty:_myMonth] && [CommonUtil isEmpty:_myDay]) {
        _myYear = @"1990";
        _myMonth = @"01";
        _myDay = @"15";
        yearRow = 65;
        dayRow = 14;
    } else {
        yearRow = _myYear.intValue - 1925;
        monthRow = _myMonth.intValue - 1;
        dayRow = _myDay.intValue - 1;
    }
    
    [self.datePicker selectRow:yearRow inComponent:0 animated:YES];
    [self.datePicker selectRow:monthRow inComponent:1 animated:YES];
    [self.datePicker selectRow:dayRow inComponent:2 animated:YES];
    
    [self.view addSubview:self.selectView];
}

// 完成日期选择
- (IBAction)clickForDateDone:(id)sender {
    self.birthdayField.text = [NSString stringWithFormat:@"%@-%@-%@",_myYear,_myMonth,_myDay];
    [self.selectView removeFromSuperview];
}

// 关闭选择页面
- (IBAction)clickForCancelSelect:(id)sender {
    [self.selectView removeFromSuperview];
}



@end
