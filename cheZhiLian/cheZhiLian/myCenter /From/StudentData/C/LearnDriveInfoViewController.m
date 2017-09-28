//
//  LearnDriveInfoViewController.m
//  guangda_student
//
//  Created by duanjycc on 15/3/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "LearnDriveInfoViewController.h"
#import "CZPhotoPickerController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIImageView+WebCache.h"
#import "MyDate.h"
#import "LoginViewController.h"

@interface LearnDriveInfoViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    int myPhotoType;
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;

// 日期选择器
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *dateConfirmBtn;
@property (strong, nonatomic) MyDate *myPickerDate;
@property (strong, nonatomic) NSString *myYear;
@property (strong, nonatomic) NSString *myMonth;
@property (strong, nonatomic) NSString *myDay;
@property (strong, nonatomic) NSString *curYear;
@property (strong, nonatomic) NSString *curMonth;
@property (strong, nonatomic) NSString *curDay;

// 拍照
@property (nonatomic, strong) CZPhotoPickerController *pickPhotoController;

- (IBAction)clickForCancelSelect:(id)sender;
- (IBAction)clickForTimeSelect:(id)sender;
- (IBAction)clickForDateDone:(id)sender;
- (IBAction)clickForCommit:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation LearnDriveInfoViewController
- (IBAction)ReturnPreviousPage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timeDateInit];
    [self settingView];
    [self showData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 页面设置
- (void)settingView {
    [self.mainScrollView contentSizeToFit];
    
    // 输入框右边距
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 20)];
    self.stuCardIdField.rightView = rightPaddingView;
    self.stuCardIdField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.idCardField.rightView = rightPaddingView;
    self.idCardField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    // 设置是"跳过" 还是 "返回"
    if ([_isSkip isEqualToString:@"1"])
    {
        // skip
        [self.backBtn setImage:nil forState:UIControlStateNormal];
        [self.backBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [self.backBtn setTitleColor:MColor(80, 203, 151) forState:UIControlStateNormal];
        [self.backBtn removeTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn addTarget:self action:@selector(clickForJump) forControlEvents:UIControlEventTouchUpInside];
    }else {
        // back
        [self.backBtn setImage:[UIImage imageNamed:@"arrow_back_userinfohome"] forState:UIControlStateNormal];
        [self.backBtn setTitle:nil forState:UIControlStateNormal];
        [self.backBtn removeTarget:self action:@selector(clickForJump) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.stuCardIdField.delegate = self;
    self.idCardField.delegate = self;
    
    // 选择器
    self.selectView.frame = [UIScreen mainScreen].bounds;
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    self.dateConfirmBtn.layer.borderWidth = 1;
    self.dateConfirmBtn.layer.borderColor = [MColor(248, 99, 95) CGColor];
    self.dateConfirmBtn.layer.cornerRadius = 4;
    
    // 拍照
    [self.idCardFrontBtn addTarget:self action:@selector(clickForPhotoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.idCardBackBtn addTarget:self action:@selector(clickForPhotoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.licenseFrontBtn addTarget:self action:@selector(clickForPhotoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.licenseBackBtn addTarget:self action:@selector(clickForPhotoView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 点击背景退出键盘
    [self keyboardHiddenFun];
}

// 显示数据
- (void)showData {
    [self loadLocalData];
    self.stuCardIdField.text = _student_cardnum;
    self.madeTimeField.text = _student_card_creat;
    self.idCardField.text = _id_cardnum;
    
    [self.idCardFrontImageView sd_setImageWithURL:[NSURL URLWithString:_id_cardpicfurl] placeholderImage:nil];
    [self.idCardBackImageView sd_setImageWithURL:[NSURL URLWithString:_id_cardpicburl] placeholderImage:nil];
    [self.licenseFrontImageView sd_setImageWithURL:[NSURL URLWithString:_student_cardpicfurl] placeholderImage:nil];
    [self.licenseBackImageView sd_setImageWithURL:[NSURL URLWithString:_student_cardpicburl] placeholderImage:nil];
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
    [self.stuCardIdField resignFirstResponder];
    [self.idCardField resignFirstResponder];
}

// 开始编辑，铅笔变红
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_redpencil_userbaseinfo"];
    
    if ([textField isEqual:self.stuCardIdField]) {
        [self.stuCardIdPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.idCardField]) {
        [self.idCardPencilImage setImage:image];
    }
}

// 结束编辑，铅笔变灰
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_pencil_userinfocell"];
    
    if ([textField isEqual:self.stuCardIdField]) {
        [self.stuCardIdPencilImage setImage:image];
    }
    
    else if ([textField isEqual:self.idCardField]) {
        [self.idCardPencilImage setImage:image];
    }
}

#pragma mark - PickerVIew
- (void)timeDateInit {
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateFormatter stringFromDate:curDate];
    _curYear = [locationString substringToIndex:4];
    _curMonth = [locationString substringWithRange:NSMakeRange(4, 2)];
    _curDay = [locationString substringWithRange:NSMakeRange(6, 2)];
    self.myPickerDate = [[MyDate alloc] initWithEndYear:_curYear];
}

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0;
}

// 组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:self.datePicker]) {
        return 3;
    }
    else {
        return 0;
    }
}

// 每组行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.datePicker]) {
        switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
            case 0:  // 第一栏为年
                return self.myPickerDate.year.count;
            case 1: {// 第二栏为月份
                if ([_myYear intValue] == [_curYear intValue]) {
                    return [_curMonth intValue];
                }
                return 12;
            }
            case 2: { // 第三栏为对应月份的天数
                int selectMonth = [_myMonth intValue];
                if ([_myYear intValue] == [_curYear intValue] && [_myMonth intValue] == [_curMonth intValue]) {
                    return [_curDay intValue];
                }
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
    
    //    return myView;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.datePicker]) {
        switch (component) {
            case 0: {
                _myYear = self.myPickerDate.year[row];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
//                [pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:pickerView didSelectRow:0 inComponent:1];
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
    
}

#pragma mark - photo
- (CZPhotoPickerController *)photoController
{
    __weak typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        
        if (imagePickerController == nil || imageInfoDict == nil) {
            return;
        }
        
        UIImage *image = imageInfoDict[UIImagePickerControllerOriginalImage];
        image = [CommonUtil scaleImage:image minLength:1200];
        
        if (myPhotoType == idCardFront) {
            self.idCardFrontImageView.image = image;
            self.idCardFrontView.backgroundColor = [UIColor whiteColor];
            self.idCardFrontLabel.hidden = YES;
        }
        else if (myPhotoType == idCardBack) {
            self.idCardBackImageView.image = image;
            self.idCardBackView.backgroundColor = [UIColor whiteColor];
            self.idCardBackLabel.hidden = YES;
        }
        else if (myPhotoType == licenseFront) {
            self.licenseFrontImageView.image = image;
            self.licenseFrontView.backgroundColor = [UIColor whiteColor];
            self.licenseFrontLabel.hidden = YES;
        }
        else if (myPhotoType == licenseBack) {
            self.licenseBackImageView.image = image;
            self.licenseBackView.backgroundColor = [UIColor whiteColor];
            self.licenseBackLabel.hidden = YES;
        }
        
    }];
}

#pragma mark - 网络请求
// 上传学员信息
- (void)postPerfectStudentInfo {
    [self catchInputData];
}

- (void) backLogin{
    
    if(![self.navigationController.topViewController isKindOfClass:[LogInViewController class]]) {
        LogInViewController *nextViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
    
}

#pragma mark - 数据处理
// 取得输入数据
- (void)catchInputData {
    _student_cardnum = self.stuCardIdField.text;
    _student_card_creat = self.madeTimeField.text;
    _id_cardnum = self.idCardField.text;
}

// 数据本地化
- (void)locateData {
    [self emptyDataFun];
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSMutableDictionary *new_user_info = [NSMutableDictionary dictionaryWithDictionary:user_info];
    [new_user_info setObject:_student_cardnum forKey:@"student_cardnum"];
    [new_user_info setObject:_student_card_creat forKey:@"student_card_creat"];
    [new_user_info setObject:_id_cardnum forKey:@"id_cardnum"];
    [new_user_info setObject:_id_cardpicfurl forKey:@"id_cardpicf_url"];
    [new_user_info setObject:_id_cardpicburl forKey:@"id_cardpicb_url"];
    [new_user_info setObject:_student_cardpicfurl forKey:@"student_cardpicf_url"];
    [new_user_info setObject:_student_cardpicburl forKey:@"student_cardpicb_url"];
    [CommonUtil saveObjectToUD:new_user_info key:@"UserInfo"];
}

// 加载本地数据
- (void)loadLocalData {
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    _student_cardnum = [user_info objectForKey:@"student_cardnum"];
    _student_card_creat = [user_info objectForKey:@"student_card_creat"];
    _id_cardnum = [user_info objectForKey:@"id_cardnum"];
    _id_cardpicfurl = [user_info objectForKey:@"id_cardpicf_url"];
    _id_cardpicburl = [user_info objectForKey:@"id_cardpicb_url"];
    _student_cardpicfurl = [user_info objectForKey:@"student_cardpicf_url"];
    _student_cardpicburl = [user_info objectForKey:@"student_cardpicb_url"];
}

// 空数据处理
- (void)emptyDataFun {
    if ([CommonUtil isEmpty:_student_cardnum]) {
        _student_cardnum = @"";
    }
    if ([CommonUtil isEmpty:_student_card_creat]) {
        _student_card_creat = @"";
    }
    if ([CommonUtil isEmpty:_id_cardnum]) {
        _id_cardnum = @"";
    }
    if ([CommonUtil isEmpty:_id_cardpicfurl]) {
        _id_cardpicfurl = @"";
    }
    if ([CommonUtil isEmpty:_id_cardpicburl]) {
        _id_cardpicburl = @"";
    }
    if ([CommonUtil isEmpty:_student_cardpicfurl]) {
        _student_cardpicfurl = @"";
    }
    if ([CommonUtil isEmpty:_student_cardpicburl]) {
        _student_cardpicburl = @"";
    }
}

// NSString类型检查
//- (void)stringCheck:(id)object {
//    if (![object isKindOfClass:[NSString class]]) {
//        object = @"";
//    }
//}

#pragma mark - 点击事件
// 提交
- (IBAction)clickForCommit:(id)sender {
    [self postPerfectStudentInfo];
}

//跳过
- (void)clickForJump
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 开启制证时间选择
- (IBAction)clickForTimeSelect:(id)sender {
    _myYear = _curYear;
    _myMonth = _curMonth;
    _myDay = @"01";
    int yearRow = [_curYear intValue] - 1925;
    [self.datePicker selectRow:yearRow inComponent:0 animated:YES];
    [self.datePicker selectRow:([_curMonth intValue] - 1) inComponent:1 animated:YES];
    [self.datePicker selectRow:0 inComponent:2 animated:YES];
    
    [self.view addSubview:self.selectView];
}

// 完成日期选择
- (IBAction)clickForDateDone:(id)sender {
    self.madeTimeField.text = [NSString stringWithFormat:@"%@-%@-%@", _myYear, _myMonth, _myDay];
    [self.selectView removeFromSuperview];
}

// 关闭选择页面
- (IBAction)clickForCancelSelect:(id)sender {
    [self.selectView removeFromSuperview];
}

// 显示photoView
- (void)clickForPhotoView:(UIButton *)sender {
    if ([sender isEqual:self.idCardFrontBtn]) {
        myPhotoType = idCardFront;
    }
    else if ([sender isEqual:self.idCardBackBtn]) {
        myPhotoType = idCardBack;
    }
    else if ([sender isEqual:self.licenseFrontBtn]) {
        myPhotoType = licenseFront;
    }
    else if ([sender isEqual:self.licenseBackBtn]) {
        myPhotoType = licenseBack;
    }
    
    self.photoView.hidden = NO;
}

// 拍照
- (IBAction)clickForCamera:(id)sender {
    self.photoView.hidden = YES;
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.saveToCameraRoll = YES;
    if ([CZPhotoPickerController canTakePhoto]) {
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

// 相册
- (IBAction)clickForAlbum:(id)sender {
    self.photoView.hidden = YES;
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.saveToCameraRoll = YES;
    if ([CZPhotoPickerController canTakePhoto]) {
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (IBAction)clickForCancelPortraitChange:(id)sender {
    self.photoView.hidden = YES;
}

@end
