//
//  CoachScreenViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/24.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CoachScreenViewController.h"
#import "CommonUtil+Date.h"
#import "AppDelegate.h"

@interface CoachScreenViewController ()
<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    CGFloat _keyboardY;     // 键盘弹出时的y坐标
    BOOL _upOrDown;         // yes == up / no == down
    BOOL _dateOrTime;       // yes == date / no == time
    
    int timeScreenBegin;    // 开始时间
    int timeScreenEnd;
    
    int _sex;
    
    BOOL _pickerIsShown;
}

// 学校选择器
@property (weak, nonatomic) IBOutlet UIControl *showSchoolView;
@property (weak, nonatomic) IBOutlet UITextField *schoolNameInputField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerBoxBottomSpaceCon;

@property (weak, nonatomic) IBOutlet UIPickerView *schoolPicker;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;


// 页面数据
@property (strong, nonatomic) NSDate *maxDate;
@property (strong, nonatomic) NSMutableArray *schoolArray;
@property (strong, nonatomic) NSMutableArray *matchedSchoolArray;

@end

@implementation CoachScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self staticViewConfig];

    self.maxDate = [CommonUtil addDate2:[NSDate date] year:0 month:0 day:29];
    NSInteger year = [CommonUtil getYearOfDate:self.maxDate];
    NSInteger yue = [CommonUtil getMonthOfDate:self.maxDate];
    NSInteger ri = [CommonUtil getdayOfDate:self.maxDate];
    self.maxDate = [CommonUtil getDateForString:[NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)year,(long)yue,(long)ri] format:nil];
    
    _sex = 0;
    self.carTypeId = @"0";
    self.subjectID = @"0";
    
    [self initWithDic];
    
    [self getAllSubject];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_widht - 110);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchTextField resignFirstResponder];
}

#pragma mark - ViewConfig
- (void)staticViewConfig {
    self.selectContentView.frame = CGRectMake(0, 0, kScreen_widht, kScreen_heigth - 110);
    [self.scrollView addSubview:self.selectContentView];
    self.scrollView.contentSize = CGSizeMake(0, kScreen_heigth - 110);
    
    self.btnGoSearch.layer.cornerRadius = 3;
    self.btnReset.layer.cornerRadius = 3;
    self.btnReset.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnReset.layer.borderWidth = 1;
    //    self.subjectNoneButton.layer.cornerRadius = 3;
    
    // 驾校选择
    self.showSchoolView.layer.cornerRadius = 3;
    self.showSchoolView.layer.borderWidth = 0.7;
    self.showSchoolView.layer.borderColor = MColor(211, 212, 215).CGColor;
    self.selectView.frame = [UIScreen mainScreen].bounds;
    
    // 点击背景退出键盘
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [self.selectContentView addGestureRecognizer: tapGestureRecognizer1];
    [tapGestureRecognizer1 setCancelsTouchesInView:NO];
    
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardClick:)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [self.selectView addGestureRecognizer:tapGestureRecognizer2];
    
    // 监听驾校搜索输入框
    [self.schoolNameInputField addTarget:self action:@selector(inputSchoolNameChanged:) forControlEvents:UIControlEventEditingChanged];
}

//根据已有的条件初始化
- (void) initWithDic{
    if(self.searchDic){
        // 日期
        NSString * date = self.searchDic[@"condition3"];
        if(date){
            NSDate *difDate = [CommonUtil getDateForString:date format:@"yyyy-MM-dd HH:mm:ss"];
            self.dateBeginLabel.text = [CommonUtil getStringForDate:difDate format:@"yyyy-MM-dd"];
            
            NSDate *selectedDate = [CommonUtil getDateForString:self.dateBeginLabel.text format:@"yyyy-MM-dd"];
            if (([selectedDate timeIntervalSinceDate:self.maxDate] > 0.0)) {
                self.rightUpBtn.enabled = NO;
            }else{
                self.rightUpBtn.enabled = YES;
            }
            
            if(([selectedDate timeIntervalSinceDate:[NSDate date]] < 0.0)){
                self.leftUpBtn.enabled = NO;
            }else{
                self.leftUpBtn.enabled = YES;
            }
            
        }else{
            self.dateBeginLabel.text = @"不限";
        }
        
        // 驾校
        NSString *schoolName = self.searchDic[@"driveschoolname"];
        if ([CommonUtil isEmpty:schoolName]) {
            self.schoolLabel.text = @"不限驾校";
        } else {
          
            self.schoolLabel.text = @"测试驾校";
        }
        
    }else{
        self.dateBeginLabel.text = @"不限";
        self.schoolLabel.text = @"不限驾校";
    }
    
    //显示绑定驾校
    NSDictionary * userInfo = [[NSDictionary alloc]init];
    userInfo = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *drive_school = [userInfo objectForKey:@"drive_school"];
    if (drive_school) {
       self.schoolLabel.text = [userInfo objectForKey:@"drive_school"];
    }

}

// 设置各个选项的默认值
- (IBAction)setSectionStatus:(id)sender
{
    self.dateBeginLabel.text = @"不限";
    self.subjectID = @"0";
    self.schoolLabel.text = @"不限驾校";
    
    //显示绑定驾校
    NSDictionary * userInfo = [[NSDictionary alloc]init];
    userInfo = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *drive_school = [userInfo objectForKey:@"drive_school"];
    if (drive_school) {
        self.schoolLabel.text = [userInfo objectForKey:@"drive_school"];
    }
    
}

#pragma mark 时间选择器action
- (IBAction)dateBtnClick:(id)sender
{
    [self hideKeyboardClick:nil];
    
    
}

// 改变科目选中按钮的状态
- (void)selectedButton:(UIButton *)button
{
    button.selected = YES;
    button.backgroundColor = MColor(80, 203, 140);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou_selected"]];
    imageView.frame = CGRectMake(button.frame.origin.x-7, button.frame.origin.y-7, 14, 14);
    imageView.tag = button.tag;
    [button.superview addSubview:imageView];
}

- (void)hideKeyboardClick:(id)sender
{
    if (_pickerIsShown) {
        [_schoolNameInputField resignFirstResponder];
    } else {
        [_searchTextField resignFirstResponder];
    }
}

#pragma mark - 监听
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    if (_pickerIsShown == NO) {
        //将footview始终置于键盘上方
        [UIView animateWithDuration:animationDuration animations:^{
            self.footViewBottomSpaceCon.constant = keyboardHeight;
            [self.view layoutIfNeeded];
        }];
    } else {
        // 上移picherView
        [UIView animateWithDuration:animationDuration animations:^{
            self.pickerBoxBottomSpaceCon.constant = kScreen_widht - 64 - 240;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect footViewRect = self.footView.frame;
    footViewRect.origin.y = self.view.frame.size.height - footViewRect.size.height;
    
    // Get the duration of the animation.
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    animationDuration += 0.1f;
    
    if (_pickerIsShown == NO) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.footViewBottomSpaceCon.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } else {
        // 下移picherView
        [UIView animateWithDuration:animationDuration animations:^{
            self.pickerBoxBottomSpaceCon.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_widht - 110);
}

#pragma mark - 输入框代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.nowTextField = textField;
    return YES;
}

// 显示输入名字匹配的驾校
- (void)inputSchoolNameChanged:(UITextField *)textField {
    [self.matchedSchoolArray removeAllObjects];
   
    [self.schoolPicker reloadAllComponents];
}

#pragma mark - 接口请求
// 获取所有科目类型
- (void)getAllSubject
{
    
}

// 获取驾校列表
- (void)postGetSchollList
{
    
}

// 添加车型选择按钮
- (void)addSubjectBtn:(NSMutableArray *)subjectList {
    int _row = 0;
    CGFloat _x = 80+46+10;
    CGFloat _y = 20;
    NSString *subjectid = nil;
    if(self.searchDic){
        subjectid = self.searchDic[@"condition6"];
    }
    
    UIButton *selectedButton = nil;
    for (int i = 0; i < subjectList.count; i++) {
        NSDictionary *subDic = subjectList[i];
        
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *subName = subDic[@"subjectname"];
        NSString *subID= subDic[@"subjectid"];
        
        // 计算字体宽度
        CGSize titleSize = [CommonUtil sizeWithString:subName fontSize:13 sizewidth:0 sizeheight:30];
        CGFloat _width = titleSize.width;
        
        if ((_x + _width + 10) > kScreen_widht) {
            _row++;
            _x = 80;
        }
        
        _y = 20 + _row*(30 + 10);
        subBtn.frame = CGRectMake(_x, _y, _width +20, 30);
        [self.selectSubjectView addSubview:subBtn];
        [subBtn setBackgroundColor:MColor(240, 243, 244)];
        [subBtn setTitle:subName forState:UIControlStateNormal];
        [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        subBtn.tag = [subID intValue];
        subBtn.layer.cornerRadius = 3;
        subBtn.layer.masksToBounds = YES;
        [subBtn addTarget:self action:@selector(clickForSubjectNone:) forControlEvents:UIControlEventTouchUpInside];
        
        if(subjectid && [subjectid intValue] == [subID intValue]){
            selectedButton = subBtn;
            _subjectID = subID;
        }
        _x += _width + 20 + 10;
    }
    
    self.selectSubjevtViewHeight.constant = _y + 50;
}

#pragma mark - PickerVIew
// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0;
}

// 组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:self.datePicker]) {
        return 3;
    }
    else if ([pickerView isEqual:self.schoolPicker]) {
        return 1;
    }
    else {
        return 0;
    }
}

// 每组行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

// 自定义每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    if ([pickerView isEqual:self.datePicker]) {
        
        UILabel *dateLabel = (UILabel *)view;
        if (!dateLabel) {
            dateLabel = [[UILabel alloc] init];
            [dateLabel setFont:[UIFont systemFontOfSize:21]];
            [dateLabel setTextColor:[UIColor whiteColor]];
            [dateLabel setBackgroundColor:[UIColor clearColor]];
        }
        
        switch (component) {
            case 0: {
                
                [dateLabel setText:@"测试1"];
                dateLabel.textAlignment = NSTextAlignmentRight;
                break;
            }
            case 1: {
                
                NSString *currentMonth = @"测试1";
                //                [dateLabel setText:[NSString stringWithFormat:@"%@月",currentMonth]];
                [dateLabel setText:currentMonth];
                dateLabel.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case 2: {
                NSString *currentDay = @"测试2";
                [dateLabel setText:currentDay];
                dateLabel.textAlignment = NSTextAlignmentLeft;
                break;
            }
            default:
                break;
        }
        
        return dateLabel;
    }
    
    // 驾校选择器
    else if ([pickerView isEqual:self.schoolPicker]) {
        UILabel *schoolLabel = (UILabel *)view;
        if (!schoolLabel) {
            schoolLabel = [[UILabel alloc] init];
            [schoolLabel setFont:[UIFont systemFontOfSize:16]];
            [schoolLabel setTextColor:[UIColor whiteColor]];
            [schoolLabel setBackgroundColor:[UIColor clearColor]];
            schoolLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        return schoolLabel;
    }
    
    else {
        return myView;
    }
    
    //    return myView;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.datePicker]) {
        switch (component) {
            case 0: {
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:pickerView didSelectRow:0 inComponent:2];
                break;
            }
            case 1: {
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:pickerView didSelectRow:0 inComponent:2];
                break;
            }
            case 2: {
                
                break;
            }
            default:
                break;
        }
        
    }
}

#pragma mark - 生成查询条件字典
- (NSMutableDictionary *)searchDictCreate {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSString *searchStr = self.searchTextField.text;
    if (searchStr.length > 0) {
        [paramDic setObject:searchStr forKey:@"condition1"];   // 搜索文字
    }
    

    
    [paramDic setObject:_subjectID forKey:@"condition6"];
    
    
    paramDic[@"comefrom"] = self.comeFrom;

    return paramDic;
}


#pragma mark - Action
// 重置筛选条件
- (IBAction)clickForSubjectNone:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (!button.selected) {
        // selected
        button.selected = YES;
        button.backgroundColor = MColor(80, 203, 140);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou_selected"]];
        imageView.frame = CGRectMake(button.frame.origin.x-7, button.frame.origin.y-7, 14, 14);
        imageView.tag = button.tag;
        [button.superview addSubview:imageView];
        
        self.subjectID = [NSString stringWithFormat:@"%ld", (long)button.tag];
        
        for (id objc in button.superview.subviews) {
            // 移除其他的button的选中效果
            if ([objc isKindOfClass:[UIButton class]]) {
                UIButton *button2 = (UIButton *)objc;
                if (button2.tag != button.tag) {
                    button2.selected = NO;
                    button2.backgroundColor = MColor(240, 243, 244);
                    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
            
            if ([objc isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView2 = (UIImageView *)objc;
                if (imageView2.tag != imageView.tag) {
                    [imageView2 removeFromSuperview];
                }
            }
        }
    }
    button.layer.cornerRadius = 3;
}
// 去筛选
- (IBAction)goSearchClick:(id)sender
{
    [self.searchTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchCoachDict" object:[self searchDictCreate]];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 关闭选择页面
- (IBAction)clickForCancelSelect:(id)sender
{
    [self.selectView removeFromSuperview];
    _pickerIsShown = NO;
}

// 日期
- (IBAction)addDateClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        NSString *beginString = self.dateBeginLabel.text;
        NSDate *begin = [NSDate date];
        if([@"不限" isEqualToString:beginString]){
            
            NSDate *selectedDate = begin;
            
            self.rightUpBtn.enabled = YES;
            self.leftUpBtn.enabled = NO;
            self.dateScreenBegin = selectedDate;
            NSString *selectedDateStr = [CommonUtil getStringForDate:selectedDate format:@"yyyy-MM-dd"];
            self.dateBeginLabel.text = selectedDateStr;
        }else{
            NSDate *begin = [CommonUtil getDateForString:[NSString stringWithFormat:@"%@ 00:00:00",beginString] format:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *selectedDate = [CommonUtil addDate2:begin year:0 month:0 day:1];
            self.leftUpBtn.enabled = YES;
            if ([selectedDate timeIntervalSinceDate:self.maxDate] >= 0.0) {
                self.rightUpBtn.enabled = NO;
            }else{
                self.rightUpBtn.enabled = YES;
            }
            
            
            self.dateScreenBegin = selectedDate;
            NSString *selectedDateStr = [CommonUtil getStringForDate:selectedDate format:@"yyyy-MM-dd"];
            self.dateBeginLabel.text = selectedDateStr;
        }
    }else if (button.tag == 1) {
        // 结束日期
        NSDate *selectedDate = [[NSDate date] initWithTimeInterval:24*60*60 sinceDate:self.dateScreenEnd];
        
        if (([selectedDate timeIntervalSinceDate:self.maxDate] > 0.0)) {
            [self makeToast:@"只能预约30天后的课程"];
            return;
        }
        
        self.dateScreenEnd = selectedDate;
    }
}

- (IBAction)deleteDateClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        NSString *beginString = self.dateBeginLabel.text;
        NSDate *now = [NSDate date];
        if([@"不限" isEqualToString:beginString]){
            return;
        }else{
            NSDate *begin = [CommonUtil getDateForString:beginString format:@"yyyy-MM-dd"];
            NSDate *selectedDate = [CommonUtil addDate2:begin year:0 month:0 day:-1];
            self.rightUpBtn.enabled = YES;
            if (([selectedDate timeIntervalSinceDate:now] < 0.0)) {
                self.leftUpBtn.enabled = NO;
            }else{
                self.leftUpBtn.enabled = YES;
            }
            
            self.dateScreenBegin = selectedDate;
            NSString *selectedDateStr = [CommonUtil getStringForDate:selectedDate format:@"yyyy-MM-dd"];
            self.dateBeginLabel.text = selectedDateStr;
        }
        
    }else{
        NSDate *selectedDate = [[NSDate date] initWithTimeInterval:-24*60*60 sinceDate:self.dateScreenEnd];
        
        if ([selectedDate timeIntervalSinceDate:self.dateScreenBegin] < 0.0) {
            [self makeToast:@"结束时间不能早于开始时间"];
            return;
        }
        
        self.dateScreenEnd = selectedDate;
    }
}

- (IBAction)dismissSelfView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseSchoolClick:(id)sender {
    
    //显示绑定驾校
    NSDictionary * userInfo = [[NSDictionary alloc]init];
    userInfo = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *drive_school = [userInfo objectForKey:@"drive_school"];
    if (drive_school) {
        return;
    }
    
    if (self.schoolArray) {
        [self.schoolPicker reloadAllComponents];
        [self.view addSubview:self.selectView];
        _pickerIsShown = YES;
    } else {
        [self postGetSchollList];
    }
}

// 完成驾校选择
- (IBAction)selectDoneClick:(id)sender {
    NSInteger index = [self.schoolPicker selectedRowInComponent:0];
    [self.selectView removeFromSuperview];
    _pickerIsShown = NO;
}

@end
