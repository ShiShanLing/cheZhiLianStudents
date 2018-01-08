//
//  LogInViewController.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/20.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "LogInViewController.h"
#import "InputBoxView.h"
#import "ForgotPasswordVC.h"
#import "RegisteredViewController.h"
#import "AppDelegate.h"
@interface LogInViewController ()<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
//背景
@property (nonatomic, strong)UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *drivingNameTF;//驾校名字
@property (nonatomic, strong)UITextField *NameTF;
@property (nonatomic, strong)UITextField *PassWordTF;
@property (nonatomic, strong)InputBoxView *NameIBV;
@property (nonatomic, strong)InputBoxView *passWordIBV;
@property (nonatomic, strong)InputBoxView *DrivingIBV;
//选择器
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) NSMutableArray *selectArray;

@end

@implementation LogInViewController {
    NSInteger selectRow;
    NSString  *drivingID;//所选择的
}

// 关闭选择页面
- (IBAction)clickForCancelSelect:(id)sender {
    [self.selectView removeFromSuperview];
}

// 完成驾校选择
- (IBAction)clickForDone:(UIButton *)sender {
    self.DrivingIBV.NameTF.text = self.selectArray[selectRow][@"storeName"];
    drivingID = self.selectArray[selectRow][@"storeId"];
    [UserDataSingleton mainSingleton].kStoreId = drivingID;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"chooseDriving" ofType:@"plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [userData removeAllObjects];
    userData =[NSMutableDictionary dictionaryWithDictionary:self.selectArray[selectRow]];
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"chooseDriving.plist"];
    //输入写入
    [userData writeToFile:filename atomically:YES];
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *userData2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"查看是否存储成功%@", userData2);
    [self.selectView removeFromSuperview];
}
//选择驾校
- (void)handleChooseDriing:(UITapGestureRecognizer *)sender {
    [self.pickerView reloadAllComponents];
    self.selectView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.selectView];
}
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    
    [self.selectView removeFromSuperview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super.navigationController setNavigationBarHidden:YES];
    _NameIBV.NameTF.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _NameIBV.NameTF.delegate = nil;
}
- (void)handleSingleRecognizer{
    
    [_NameIBV.NameTF resignFirstResponder];
    [_passWordIBV.NameTF resignFirstResponder];
}
- (void) registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘出现时
- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGSize size = CGSizeMake(kScreen_widht, kScreen_heigth);
    size.height += keyboardSize.height;
    [UIView animateWithDuration:0.0001 animations:^{
        self.scrollView.contentSize = size;//设置UIScrollView默认显示位置
    }];
    [self.scrollView setContentOffset:CGPointMake(0, kFit(50))];//这个 130 是根据视图的高度自己计算出来的
}

- (void) keyboardWasHidden:(NSNotification *) notif {
    
    
    [UIView animateWithDuration:0.0001 animations:^{
        self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth);
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth);
    
}
//回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectArray = [NSMutableArray array];
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    
    [self.selectView addGestureRecognizer:singleFingerOne];
    self.pickerView.showsSelectionIndicator = NO;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self registerForKeyboardNotifications];///让界面岁键盘自适应
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//去除导航条上图片的渲染色
    [self createScrollView];
    self.backgroundImage = [UIImageView new];
    
    _backgroundImage.image = [UIImage imageNamed:@"LogInbj"];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] init];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer addTarget:self action:@selector(handleSingleRecognizer)];//回收键盘
    [_backgroundImage addGestureRecognizer:singleRecognizer];
    [self.scrollView addSubview:_backgroundImage];
    _backgroundImage.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).bottomSpaceToView(self.scrollView, 0);
    
    UIImage *buttonimage = [UIImage imageNamed:@""];
    buttonimage = [buttonimage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];//去
    UIButton *returnBtn = [UIButton new];
    [returnBtn setImage:buttonimage forState:(UIControlStateNormal)];
    [returnBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBtn];
    returnBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, kFit(25)).widthIs(kFit(kFit(40))).heightIs(kFit(38));
    
    UIButton *registeredBtn = [UIButton new];
    registeredBtn.titleLabel.font = MFont(kFit(17));
    [registeredBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [registeredBtn setTitleColor:MColor(210, 210, 210) forState:(UIControlStateNormal)];
    [registeredBtn addTarget:self action:@selector(handleRegisteredBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registeredBtn];
    registeredBtn.sd_layout.rightSpaceToView(self.view, 0).widthIs(kFit(60)).heightIs(kFit(33)).topSpaceToView(self.view, kFit(30));
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"登录";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = MFont(kFit(18));
    titleLabel.textAlignment = 1;
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, kFit(30)).widthIs(kFit(100)).heightIs(33);
    [self CreatingControls];
    [self initSexData];
}
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.bounces = NO;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] init];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer addTarget:self action:@selector(handleSingleRecognizer)];//回收键盘
    [self.scrollView addGestureRecognizer:singleRecognizer];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth - 64);
    self.scrollView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, -20).bottomSpaceToView(self.view, 0);
}
 
- (void)handleReturnBtn {
    
}
- (void)CreatingControls {
    
    
    UIColor *color = MColor(210, 210, 210);
   self.DrivingIBV = [InputBoxView new];
    
    _DrivingIBV.NameTF.delegate = self;
    _DrivingIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _DrivingIBV.NameTF.userInteractionEnabled = NO;
    _DrivingIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"选择驾校" attributes:@{NSForegroundColorAttributeName: color}];
    [self.scrollView addSubview:_DrivingIBV];
    _DrivingIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, kFit(114)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    //覆盖自定义空间的UITextFi
    UILabel *coveringLabel = [[UILabel alloc] init];
    //coveringLabel.backgroundColor = [UIColor redColor];
    coveringLabel.userInteractionEnabled = YES;
    [self.scrollView addSubview:coveringLabel];
    coveringLabel.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, kFit(114)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleChooseDriing:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    
    [coveringLabel addGestureRecognizer:singleFingerOne];
    
    self.NameIBV = [InputBoxView new];
    _NameIBV.NameTF.delegate = self;
    _NameIBV.NameTF.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:_NameIBV];
    _NameIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_DrivingIBV, 0).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
      _NameIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
    self.passWordIBV = [InputBoxView new];
    _passWordIBV.NameTF.delegate = self;
    _passWordIBV.NameTF.returnKeyType = UIReturnKeyDone;
    UIImage *nameImage = [UIImage imageNamed:@"mima"];
    nameImage = [nameImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_passWordIBV.nameBtn setImage:nameImage forState:(UIControlStateNormal)];
    
    _passWordIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    _passWordIBV.NameTF.secureTextEntry = YES;
    [self.scrollView addSubview:_passWordIBV];
    _passWordIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_NameIBV, kFit(0)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    
    UIButton *ForgotPasswordBtn = [UIButton new];
    [ForgotPasswordBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    [ForgotPasswordBtn setTitleColor:MColor(210, 210, 210) forState:(UIControlStateNormal)];
    ForgotPasswordBtn.titleLabel.font = MFont(kFit(14));
    [ForgotPasswordBtn addTarget:self action:@selector(handleForgotPasswordBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:ForgotPasswordBtn];
    ForgotPasswordBtn.sd_layout.rightSpaceToView(self.scrollView, 0).topSpaceToView(_passWordIBV, 0).widthIs(kFit(75)).heightIs(kFit(44));
    
    UIButton *LoginBtn = [UIButton new];
    LoginBtn.backgroundColor = kNavigation_Color;
    LoginBtn.titleLabel.font = MFont(kFit(17));
    LoginBtn.layer.cornerRadius = 6;
    LoginBtn.layer.masksToBounds = YES;
    [LoginBtn setTitle:@"立即登录" forState:(UIControlStateNormal)];
    [LoginBtn setTitleColor:MColor(255, 255, 255) forState:(UIControlStateNormal)];
    [LoginBtn addTarget:self action:@selector(handleLigInBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:LoginBtn];
    LoginBtn.sd_layout.leftSpaceToView(self.scrollView, kFit(12)).rightSpaceToView(self.scrollView, kFit(12)).topSpaceToView(_passWordIBV, kFit(50)).heightIs(kFit(50));
}

#pragma mark  登录按钮 注册 和 忘记密码按钮
- (NSString*)dictionaryToJson:(NSDictionary *)dic //字典转字符串
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//登录
- (void)handleLigInBtn {
    
    [self.NameIBV.NameTF resignFirstResponder];
    [self.passWordIBV.NameTF resignFirstResponder];
    
    NSString *phoneStr = self.NameIBV.NameTF.text;
    NSString *PasswordStr = self.passWordIBV.NameTF.text;
    if (self.NameIBV.NameTF.text.length == 0 || self.passWordIBV.NameTF.text.length == 0) {
        [self makeToast:@"账号或者密码不能为空"];
        return;
    }
    if(![CommonUtil checkPhonenum:phoneStr]){
        [self makeToast:@"手机号码输入有误,请重新输入"];
        return;
    }
        [self performSelector:@selector(indeterminateExample)];
    
        __block LogInViewController *VC = self;
        NSString *URL=[NSString stringWithFormat:@"%@/student/api/login", kURL_SHY];
        NSMutableDictionary *URLDIC = [NSMutableDictionary dictionary];
        URLDIC[@"userName"] = phoneStr;
        URLDIC[@"password"] =PasswordStr;
        URLDIC[@"schoolId"] = drivingID;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer.timeoutInterval = 10.0f;
        [session POST:URL parameters:URLDIC progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"handleLigInBtn%@", responseObject);
            
            [VC performSelector:@selector(delayMethod)];
            [VC AnalyticalData:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC performSelector:@selector(delayMethod)];
            [VC showAlert:@"数据请求失败,请重试!handleLigInBtn" time:1.0];
        }];
}
//解析的登录过后的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSArray *tempDictQueryDiamond = dic[@"data"];
        NSDictionary *urseDataDic = tempDictQueryDiamond[0];
        NSLog(@"AnalyticalData%@", urseDataDic);
        [self AnalysisUserData:urseDataDic];
    }else {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"抱歉!" message:[NSString stringWithFormat:@"登录失败,%@", dic[@"msg"]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertV addAction:cancle];
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];

    }
}
//获取用户详情信息 用来存储到本地判断登录状态
- (void)AnalysisUserData:(NSDictionary*)dataDic{
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = dataDic[@"stuId"];
    NSLog(@"dataDic%@ URL_Dic %@", dataDic, URL_Dic);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block LogInViewController *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AnalysisUserData%@", responseObject);
        [VC AnalyticalDataDetails:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"数据请求失败,请重试" time:1.0];
    }];
}
//解析用户详情数据 并且存储到本地一份
- (void)AnalyticalDataDetails:(NSDictionary *)dic {
    
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *userDataDic = dic[@"data"][0];
        NSDictionary *userDic = userDataDic;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData removeAllObjects];
        for (NSString *key in userDic) {
            if ([key isEqualToString:@"subState"]) {
                [UserDataSingleton mainSingleton].subState =[NSString stringWithFormat:@"%@", userDic[key]];
            }
            if ([key isEqualToString:@"stuId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"state"]) {
                
                [UserDataSingleton mainSingleton].state = [NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"balance"]) {
                [UserDataSingleton mainSingleton].balance = [NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            [userData setObject:userDic[key] forKey:key];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangesData" object:nil];
        NSLog(@"userData2%@", userData2);
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app jumpToMainViewController];
    }else {
        [self showAlert:dic[@"result"] time:1.2];
    }
}
//忘记密码
- (void)handleForgotPasswordBtn {
    ForgotPasswordVC *VC = [[ForgotPasswordVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
// 注册
- (void)handleRegisteredBtn:(UIButton *)sender {
    RegisteredViewController *VC = [[RegisteredViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle { //改变状态条颜色
    
    return UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PickerVIew
// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0;
}
// 组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// 每组行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.selectArray.count;
}
// 数据
- (void)initSexData {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"chooseDriving.plist"];
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSArray *datacount = [userData allKeys];
    if (datacount != 0) {
        self.DrivingIBV.NameTF.text = userData[@"storeName"];
        drivingID = userData[@"storeId"];
    }
    
    self.pickerView.tag = 1;
    NSString *URL_Str = [NSString stringWithFormat:@"%@/store/api/getAllSchoolList",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    __weak  LogInViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   //     NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC ParsingDrivingData:responseObject];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (void) ParsingDrivingData:(NSDictionary *)data {
    NSArray *dataArray = data[@"data"];
    if (dataArray.count == 0) {
        [self showAlert:@"驾校信息获取失败,暂时无法登陆" time:1.0];
        return;
    }
    for (NSDictionary *dic in dataArray) {
        NSMutableDictionary *MDIC = [NSMutableDictionary dictionary];
        [MDIC setValue:dic[@"storeId"] forKey:@"storeId"];
        [MDIC setValue:dic[@"storeName"] forKey:@"storeName"];
        [self.selectArray addObject:MDIC];
    }
    NSLog(@"selectArray%@", self.selectArray);
}
// 自定义每行的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    // 性别选择器
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200, 45)];
    myView.textAlignment = NSTextAlignmentCenter;
    
    myView.font = [UIFont systemFontOfSize:21];         //用label来设置字体大小
    
    myView.textColor = MColor(161, 161, 161);
    
    myView.backgroundColor = [UIColor clearColor];
    
    if (selectRow == row){
        myView.textColor = MColor(34, 192, 100);
    }
    myView.text = [self.selectArray objectAtIndex:row][@"storeName"];
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectRow = row;
    NSLog(@"selectRow%ld", (long)selectRow);
    [pickerView reloadComponent:0];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
