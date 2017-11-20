//
//  RegisteredViewController.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/20.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "RegisteredViewController.h"
#import "InputBoxView.h"
#import "TakeBackKBView.h"
@interface RegisteredViewController ()<TakeBackKBViewDelegate, UITextFieldDelegate>
//为了让键盘不会遮盖住输入框.所以使用 UIScrollView
@property (nonatomic, strong)UIScrollView *scrollView;
//背景
@property (nonatomic, strong)UIImageView *backgroundImage;
//模仿京东键盘上方的回收按钮
@property (nonatomic, strong)TakeBackKBView *takeBackKBView;
@property (nonatomic, strong)InputBoxView *NameIBV;//手机号
@property (nonatomic, strong)InputBoxView *VerificationCodeIBV;//验证码
@property (nonatomic, strong)InputBoxView *passWordIBV;//密码
@property (nonatomic, strong)InputBoxView *repeatPWIBV;//重复密码
@property (nonatomic, strong)InputBoxView *referrerIBV;//推荐人

@property (nonatomic, strong)JKCountDownButton *countdownBtn;

@end

@implementation RegisteredViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.NameIBV.NameTF.delegate = self;;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.NameIBV.NameTF.delegate = nil;
}

//回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)handleSingleRecognizer:(UITapGestureRecognizer *)sender {
    [_NameIBV.NameTF resignFirstResponder];
    [_VerificationCodeIBV.NameTF resignFirstResponder];
    [_passWordIBV.NameTF resignFirstResponder];
    [_repeatPWIBV.NameTF resignFirstResponder];
    [_referrerIBV.NameTF resignFirstResponder];
}
#pragma mark TakeBackKBViewDelegate
- (void)CancelKeyboard {
    [_NameIBV.NameTF resignFirstResponder];
    [_VerificationCodeIBV.NameTF resignFirstResponder];
    [_passWordIBV.NameTF resignFirstResponder];
    [_repeatPWIBV.NameTF resignFirstResponder];
    [_referrerIBV.NameTF resignFirstResponder];
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
    
    [self.scrollView setContentOffset:CGPointMake(0, kFit(90))];//这个 130 是根据视图的高度自己计算出来的
    
    
}
- (void) keyboardWasHidden:(NSNotification *) notif {
    [UIView animateWithDuration:0.0001 animations:^{
        self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth);
    }];
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createScrollView];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//去除导航条上图片的渲染色
    
    self.backgroundImage = [UIImageView new];
    
    _backgroundImage.image = [UIImage imageNamed:@"LogInbj"];
    [self.scrollView addSubview:_backgroundImage];
    _backgroundImage.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, 0).rightSpaceToView(self.scrollView, 0).bottomSpaceToView(self.scrollView, 0);
    
    UIImage *buttonimage = [UIImage imageNamed:@"fh"];
    buttonimage = [buttonimage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];//去
    UIButton *returnBtn = [UIButton new];
    [returnBtn setImage:buttonimage forState:(UIControlStateNormal)];
    [returnBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBtn];
    returnBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, kFit(25)).widthIs(kFit(kFit(40))).heightIs(kFit(38));
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"注册";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = MFont(kFit(18));
    titleLabel.textAlignment = 1;
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, kFit(30)).widthIs(kFit(100)).heightIs(33);
    
    [self CreatingControls];
    
    self.takeBackKBView = [[TakeBackKBView alloc] initWithFrame:CGRectMake(0, kScreen_heigth, kScreen_widht, kFit(50))];
    self.takeBackKBView.delegate=self;
    
    [self.view addSubview:_takeBackKBView];
    
}
//创建UIScrollView
- (void)createScrollView {
    
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.bounces = NO;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] init];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer addTarget:self action:@selector(handleSingleRecognizer:)];//回收键盘
    [self.scrollView addGestureRecognizer:singleRecognizer];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(kScreen_widht, kScreen_heigth - 64);
    self.scrollView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, -20).bottomSpaceToView(self.view, 0);


}

- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)CreatingControls {
    self.NameIBV = [InputBoxView new];
    UIColor *color = MColor(210, 210, 210);
    _NameIBV.NameTF.delegate =self;
    _NameIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _NameIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
    [self.scrollView addSubview:_NameIBV];
    _NameIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(self.scrollView, kFit(150)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
        //---------------- ⬆️ 用户名
    self.VerificationCodeIBV = [InputBoxView new];
    _VerificationCodeIBV.NameTF.delegate =self;
    _VerificationCodeIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _VerificationCodeIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [self.scrollView addSubview:_VerificationCodeIBV];
    _VerificationCodeIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_NameIBV, kFit(0)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    //创建验证码按钮添加到手机号的空间上
    self.countdownBtn = [JKCountDownButton new];
    self.countdownBtn.layer.cornerRadius = 13;
    self.countdownBtn.layer.masksToBounds = YES;
    [_countdownBtn.layer setBorderWidth:1.0]; //边框宽度
    _countdownBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _countdownBtn.layer.borderColor= [UIColor colorWithRed:0/256.0 green:223/256.0 blue:160/256.0 alpha:1].CGColor;
    [_countdownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_countdownBtn addTarget:self action:@selector(handleCountdownBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [_countdownBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.VerificationCodeIBV addSubview:self.countdownBtn];
    self.countdownBtn.sd_layout.rightSpaceToView(self.VerificationCodeIBV, kFit(15)).heightIs(kFit(37)).widthIs(kFit(115)).centerYEqualToView(self.VerificationCodeIBV);
    //----------------- ⬆️ 验证码
    self.passWordIBV = [InputBoxView new];
    UIImage *passWordIBVImage = [UIImage imageNamed:@"mima"];
    passWordIBVImage = [passWordIBVImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_passWordIBV.nameBtn setImage:passWordIBVImage forState:(UIControlStateNormal)];
    _passWordIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _passWordIBV.NameTF.delegate =self;
    _passWordIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    _passWordIBV.NameTF.secureTextEntry = YES;
    [self.scrollView addSubview:_passWordIBV];
    _passWordIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_VerificationCodeIBV, kFit(0)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    //----------------- ⬆️ 密码
    self.repeatPWIBV = [InputBoxView new];
    UIImage *repeatImage = [UIImage imageNamed:@"mima"];
    repeatImage = [repeatImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_repeatPWIBV.nameBtn setImage:repeatImage forState:(UIControlStateNormal)];
    _repeatPWIBV.NameTF.delegate =self;
    _referrerIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _repeatPWIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"重复密码" attributes:@{NSForegroundColorAttributeName: color}];
    _repeatPWIBV.NameTF.secureTextEntry = YES;
    [self.scrollView addSubview:_repeatPWIBV];
    _repeatPWIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_passWordIBV, kFit(0)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    
    //------------------ ⬆️ 重复密码
    
    self.referrerIBV = [InputBoxView new];
    UIImage *referrerImage = [UIImage imageNamed:@"hytj"];
    referrerImage = [referrerImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_referrerIBV.nameBtn setImage:referrerImage forState:(UIControlStateNormal)];
    _referrerIBV.NameTF.delegate =self;
    _referrerIBV.NameTF.returnKeyType = UIReturnKeyDone;
    _referrerIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"推荐人" attributes:@{NSForegroundColorAttributeName: color}];
    [self.scrollView addSubview:_referrerIBV];
    _referrerIBV.sd_layout.leftSpaceToView(self.scrollView, 0).topSpaceToView(_repeatPWIBV, kFit(0)).rightSpaceToView(self.scrollView, 0).heightIs(kFit(55));
    
    //------------------ ⬆️ 推荐人
    
    UIButton *RegisteredBtn = [UIButton new];
    RegisteredBtn.backgroundColor = kNavigation_Color;
    RegisteredBtn.titleLabel.font = MFont(kFit(17));
    RegisteredBtn.layer.cornerRadius = 6;
    RegisteredBtn.layer.masksToBounds = YES;
    [RegisteredBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [RegisteredBtn setTitleColor:MColor(255, 255, 255) forState:(UIControlStateNormal)];
    [RegisteredBtn addTarget:self action:@selector(handleRegisteredBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:RegisteredBtn];
    RegisteredBtn.sd_layout.leftSpaceToView(self.scrollView, kFit(12)).rightSpaceToView(self.scrollView, kFit(12)).topSpaceToView(_referrerIBV, kFit(50)).heightIs(kFit(50));

}

//获取验证码
- (void)handleCountdownBtn:(JKCountDownButton *)sender {
    NSString *phone = self.NameIBV.NameTF.text;
        if(![CommonUtil checkPhonenum:phone]){
            [self makeToast:@"手机号码输入有误,请重新输入"];
            return;
        }
     [self performSelector:@selector(indeterminateExample)];
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
    }];
    NSString *str=[NSString stringWithFormat:@"%@/floor/api/verifyCode", kURL_SHY];
    NSMutableDictionary *URLDIC = [NSMutableDictionary dictionary];
    URLDIC[@"mobile"] = phone;
        NSLog(@"URLDIC%@", URLDIC);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __weak RegisteredViewController *VC = self;
    [session POST:str parameters:URLDIC progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [VC performSelector:@selector(delayMethod)];
        NSString *requltStr = [NSString stringWithFormat:@"%@", responseObject[@"reqult"]];
        if ([requltStr isEqualToString:@"1"]) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC performSelector:@selector(delayMethod)];
        [VC showAlert:@"请求超时请重试!" time:1.2];
        NSLog(@"error%@", error);
    }];
   
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark 跳转界面
- (void)handleRegisteredBtn:(UIButton *)sender {
    
    NSString *phoneStr = self.NameIBV.NameTF.text;
    NSString *PasswordStr = self.passWordIBV.NameTF.text;
    NSString *confirmStr = self.repeatPWIBV.NameTF.text;
    NSString *verificationStr = self.VerificationCodeIBV.NameTF.text;
    NSString *referrerStr = self.referrerIBV.NameTF.text;
    if (phoneStr.length != 0) {
        if ([PasswordStr isEqualToString:confirmStr]) {
            __block RegisteredViewController *VC = self;
            NSString *URL=[NSString stringWithFormat:@"%@/student/api/register", kURL_SHY];
            NSMutableDictionary *URLDIC = [NSMutableDictionary dictionary];
            URLDIC[@"mobile"] = phoneStr;
            URLDIC[@"password"] =PasswordStr;
            URLDIC[@"mobileCode"] = verificationStr;
            URLDIC[@"referrer"] = referrerStr;
            URLDIC[@"schoolId"] = kStoreId;
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:URL parameters:URLDIC progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"uploadProgress%@", uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject%@", responseObject);
                [VC AnalyticalData:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error%@", error);
            }];
        }else {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入的密码不相同" preferredStyle:(UIAlertControllerStyleActionSheet)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert1 addAction:action];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
        }else {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式不正确" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        [alert1 addAction:action];
        [self presentViewController:alert1 animated:YES completion:nil];
    }
}
- (void)AnalyticalData:(NSDictionary *)dic {
    
    NSString *codeStr = dic[@"msg"];
    NSNumber *number = dic[@"result"];
    NSString *str = [NSString stringWithFormat:@"%@", number];
    if ([str isEqualToString:@"1"]) {
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"恭喜你!" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertV addAction:cancle];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];
    }else {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"抱歉!" message:[NSString stringWithFormat:@"注册失败,%@", codeStr] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertV addAction:cancle];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];

    }
}
- (UIStatusBarStyle)preferredStatusBarStyle { //改变状态条颜色
    
    return UIStatusBarStyleLightContent;
    
}



@end
