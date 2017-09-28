//
//  UserBaseInfoViewController.m
//  guangda
//
//  Created by duanjycc on 15/3/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

// 账号信息
#import "UserBaseInfoViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "LoginViewController.h"
#import "XBProvince.h"

@interface UserBaseInfoViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIView *cityView;
@property (strong, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (strong, nonatomic) IBOutlet UIButton *cityConfirmBtn;
// 城市选择器数据
@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) XBProvince *curProvince;
@property (strong, nonatomic) XBCity *curCity;
@property (strong, nonatomic) XBArea *curArea;
@property (copy, nonatomic) NSString *selectProvinceID;
@property (copy, nonatomic) NSString *selectCityID;
@property (copy, nonatomic) NSString *selectAreaID;


- (IBAction)clickForCommit:(id)sender;

@end

@implementation UserBaseInfoViewController{

    BOOL  editor;
    
}
- (IBAction)ReturnPreviousPage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainScrollView contentSizeToFit];
    [self settingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self showData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 页面设置
- (void)settingView {
    // 从报名页面跳转过来
    if (self.comeFrom == 1) {
        self.backBtn.hidden = YES;
    }
    self.phoneField.delegate = self;
    self.nameField.delegate = self;
    self.idNumTF.delegate = self;
    [self.phoneField addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    // 电话输入框右侧内边距
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 20)];
    self.nameField.rightView = rightPaddingView;
    self.nameField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    // 点击背景退出键盘
    [self keyboardHiddenFun];
    
    // 选择器
    self.selectView.frame = [UIScreen mainScreen].bounds;
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    
    self.cityConfirmBtn.layer.borderWidth = 1;
    self.cityConfirmBtn.layer.borderColor = [MColor(248, 99, 95) CGColor];
    self.cityConfirmBtn.layer.cornerRadius = 4;
    
}

// 显示数据
- (void)showData {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"userData%@", userData);
    NSArray *keyArray =[userData allKeys];
    if (keyArray.count == 0) {
        return;
    }
    
    NSString *idNumStr = [userData objectForKey:@"idCard"];
    if (idNumStr.length == 0 ) {
        editor = YES;
    }else {
        self.nameField.text = [userData objectForKey:@"realName"];
        self.nameField.userInteractionEnabled = NO;
        self.idNumTF.userInteractionEnabled = NO;
        self.idNumTF.text = [userData objectForKey:@"idCard"];
        editor = NO;
        self.commitBtn.hidden = YES;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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

#pragma mark - 页面特性
// 点击背景退出键盘
- (void)keyboardHiddenFun {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backupgroupTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   // 只需要点击非文字输入区域就会响应
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}
-(void)backupgroupTap:(id)sender{
    [self.idNumTF resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.nameField resignFirstResponder];
}

// 开始编辑，铅笔变红
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_redpencil_userbaseinfo"];
    
    if ([textField isEqual:self.phoneField]) {
        [self.phonePencilImage setImage:image];
    }
    else if ([textField isEqual:self.nameField]) {
        [self.namePencilImage setImage:image];
    }
    else  if ([textField isEqual:self.idNumTF]) {
        [self.idNumPencilImage setImage:image];
    }
}

// 结束编辑，铅笔变灰
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIImage *image = [UIImage imageNamed:@"icon_pencil_userinfocell"];
    
    if ([textField isEqual:self.phoneField]) {
        [self.phonePencilImage setImage:image];
    }
    else if ([textField isEqual:self.nameField]) {
        [self.namePencilImage setImage:image];
    }
    else  if ([textField isEqual:self.idNumTF]) {
        [self.idNumPencilImage setImage:image];
    }
}

// 手机号码3-4-4格式
- (void)formatPhoneNumber:(UITextField*)textField {
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    // nStr表示不带空格的号码
    NSString* nStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* preTxt = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" "
                                                                           withString:@""];
    
    char editFlag = 0;// 正在执行删除操作时为0，否则为1
    
    if (nStr.length <= preTxt.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    // textField设置text
    if (nStr.length > 11)
    {
        textField.text = previousTextFieldContent;
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    // 空格
    NSString* spaceStr = @" ";
    
    NSMutableString* mStrTemp = [NSMutableString new];
    int spaceCount = 0;
    if (nStr.length < 3 && nStr.length > -1)
    {
        spaceCount = 0;
    }else if (nStr.length < 7 && nStr.length >2)
    {
        spaceCount = 1;
        
    }else if (nStr.length < 12 && nStr.length > 6)
    {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++)
    {
        if (i == 0) {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)], spaceStr];
        }else if (i == 1)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
        }else if (i == 2)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
    }
    
    if (nStr.length == 11)
    {
        [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
    }
    
    if (nStr.length < 4)
    {
        [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length-nStr.length % 3,
                                                                    nStr.length % 3)]];
    }else if(nStr.length > 3)
    {
        NSString *str = [nStr substringFromIndex:3];
        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,
                                                                   str.length % 4)]];
        if (nStr.length == 11)
        {
            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    
    textField.text = mStrTemp;
    // textField设置selectedTextRange
    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
    if (editFlag == 0)
    {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4)
        {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }
    else {
        //添加
        if (nStr.length == 8 || nStr.length == 3)
        {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                              offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition
                                                         toPosition :targetPosition]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    
    return YES;
}
#pragma mark - 网络请求
// 提交账号信息
- (void)postPerfectAccountInfo {
    [self performSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/authentication", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] =[UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"realName"] = self.nameField.text;
    URL_Dic[@"idCard"] = self.idNumTF.text;
    __weak  UserBaseInfoViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC performSelector:@selector(delayMethod)];
        if ([resultStr isEqualToString:@"1"]) {
            [VC AnalysisUserData];
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC performSelector:@selector(delayMethod)];
        [VC makeToast:@"网络出错.请重试!"];
        NSLog(@"error%@", error);
    }];

    
}

- (void) backLogin{
    if(![self.navigationController.topViewController isKindOfClass:[LogInViewController class]]){
        LogInViewController *nextViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - 点击事件
- (IBAction)clickForCommit:(id)sender {
    [self.idNumTF resignFirstResponder];
    [self.nameField resignFirstResponder];
    if ([CommonUtil isEmpty:self.nameField.text]) {
        [self showAlert:@"请输入您的真实姓名" time:1.2];

        return;
    }
        if ([CommonUtil isEmpty:self.idNumTF.text]) {
        [self showAlert:@"填写您的身份证号" time:1.2];
        return;
    }else if (![CommonUtil checkUserID:self.idNumTF.text]) {
        [self showAlert:@"请确认您的填写的身份证号是否正确!" time:1.2];
        return;
    }
    [self postPerfectAccountInfo];
}

// 开启城市选择
- (IBAction)clickForCitySelect:(UIButton *)sender {
    self.cityView.hidden = NO;
    [self.view addSubview:self.selectView];
}

// 完成城市选择
- (IBAction)clickForCityDone:(id)sender {
    NSString *addrStr = nil;
    NSString *areaStr = [self.curArea.areaName stringByReplacingOccurrencesOfString:@"  " withString:@""];
    addrStr =  [NSString stringWithFormat:@"%@-%@-%@", self.curProvince.provinceName, self.curCity.cityName, areaStr];
    self.idNumTF.text = addrStr;
    self.selectProvinceID = self.curProvince.provinceID;
    self.selectCityID = self.curCity.cityID;
    self.selectAreaID = self.curArea.areaID;
    
    [self.selectView removeFromSuperview];
}

// 关闭选择页面
- (IBAction)clickForCancelSelect:(id)sender {
    [self.selectView removeFromSuperview];
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//跳过
- (void)clickForJump {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)AnalysisUserData{
    
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"studentId"] =[UserDataSingleton mainSingleton].studentsId;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __block UserBaseInfoViewController *VC = self;
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"0"]) {
                
            }else {
                [VC AnalyticalData:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [VC showAlert:@"请求失败请重试" time:1.0];
        }];
    
}
//解析的用户详情的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *urseDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData removeAllObjects];
        for (NSString *key in urseDataDic) {
            [userData setObject:urseDataDic[key] forKey:key];
        }
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
        //输入写入
        [userData writeToFile:filename atomically:YES];
        //那怎么证明我的数据写入了呢？读出来看看
        NSMutableDictionary *userData2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    
}


@end
