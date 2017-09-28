//
//  ForgotPasswordVC.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/21.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "InputBoxView.h"
@interface ForgotPasswordVC ()
@property (nonatomic, strong)UIImageView *backgroundImage;



@property (nonatomic, strong)InputBoxView *NameIBV;//手机号
@property (nonatomic, strong)InputBoxView *VerificationCodeIBV;//验证码
@property (nonatomic, strong)InputBoxView *passWordIBV;//密码

@property (nonatomic, strong)JKCountDownButton *countdownBtn;

@end

@implementation ForgotPasswordVC
- (void)handleSingleRecognizer{
    
    [_NameIBV.NameTF resignFirstResponder];
    [_passWordIBV.NameTF resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//去除导航条上图片的渲染色
    
    self.backgroundImage = [UIImageView new];
    _backgroundImage.userInteractionEnabled = YES;
    _backgroundImage.image = [UIImage imageNamed:@"LogInbj"];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] init];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer addTarget:self action:@selector(handleSingleRecognizer)];//回收键盘
    [_backgroundImage addGestureRecognizer:singleRecognizer];
    [self.view addSubview:_backgroundImage];
    _backgroundImage.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    UIImage *buttonimage = [UIImage imageNamed:@"fh"];
    buttonimage = [buttonimage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];//去
    UIButton *returnBtn = [UIButton new];
    [returnBtn setImage:buttonimage forState:(UIControlStateNormal)];
    [returnBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBtn];
    returnBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, kFit(25)).widthIs(kFit(kFit(40))).heightIs(kFit(38));
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"找回密码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = MFont(kFit(18));
    titleLabel.textAlignment = 1;
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, kFit(30)).widthIs(kFit(100)).heightIs(33);
    
    [self CreatingControls];

}
//返回上一页
- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)CreatingControls {
    
    
    self.NameIBV = [InputBoxView new];
    UIColor *color = MColor(210, 210, 210);
    _NameIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:_NameIBV];
    _NameIBV.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, kFit(64)).rightSpaceToView(self.view, 0).heightIs(kFit(55));
 
    
    //---------------- ⬆️ 用户名
    
    self.VerificationCodeIBV = [InputBoxView new];
    _VerificationCodeIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:_VerificationCodeIBV];
    _VerificationCodeIBV.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_NameIBV, kFit(0)).rightSpaceToView(self.view, 0).heightIs(kFit(55));
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
    _passWordIBV.NameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    _passWordIBV.NameTF.secureTextEntry = YES;
    [self.view addSubview:_passWordIBV];
    _passWordIBV.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_VerificationCodeIBV, kFit(0)).rightSpaceToView(self.view, 0).heightIs(kFit(55));
    
    //----------------- ⬆️ 密码
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.backgroundColor = kNavigation_Color;
    submitBtn.titleLabel.font = MFont(kFit(17));
    submitBtn.layer.cornerRadius = 6;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"找回密码" forState:(UIControlStateNormal)];
    [submitBtn setTitleColor:MColor(255, 255, 255) forState:(UIControlStateNormal)];
    [submitBtn addTarget:self action:@selector(handlesubmitBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:submitBtn];
    submitBtn.sd_layout.leftSpaceToView(self.view, kFit(12)).rightSpaceToView(self.view, kFit(12)).topSpaceToView(_passWordIBV, kFit(50)).heightIs(kFit(50));
    
}
- (void)handlesubmitBtn {

    if (_passWordIBV.NameTF.text.length == 0 || _NameIBV.NameTF.text.length == 0 || _VerificationCodeIBV.NameTF.text.length == 0) {
        [self showAlert:@"选项不能为空" time:1.0];
        return;
    }
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/member/api/updatePassword", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"memberPasswd"] = _passWordIBV.NameTF.text;
    URL_Dic[@"mobileCode"] = _VerificationCodeIBV.NameTF.text;
    URL_Dic[@"mobile"] = _NameIBV.NameTF.text;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block ForgotPasswordVC *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr= [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC showAlert:@"修改成功!" time:1.5];
            [VC.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"请求失败请重试" time:1.0];
        
    }];
    [self handleSingleRecognizer];
}

//获取验证码
- (void)handleCountdownBtn:(JKCountDownButton *)sender {
    NSString *phone = self.NameIBV.NameTF.text;
    if (phone.length == 0) {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"警告!" message:@"手机号为空" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertV addAction:confirm];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];
    }else {
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
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __weak ForgotPasswordVC *VC = self;
        [session POST:str parameters:URLDIC progress:^(NSProgress * _Nonnull uploadProgress) {
          //  NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          //  NSLog(@"uploadProgress%@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC showAlert:@"请求失败请重试" time:1.0];
           // NSLog(@"uploadProgress%@", error);
        }];
    }
}

//系统提示的弹出窗
- (void)timerFireMethod:(NSTimer*)theTimer {//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message time:(CGFloat)time{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
