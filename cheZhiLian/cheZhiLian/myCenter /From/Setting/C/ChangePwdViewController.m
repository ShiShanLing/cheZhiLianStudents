//
//  ChangePwdViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/4/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ChangePwdViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwd2TextField;
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = self.msgView.frame;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.msgView.frame = frame;
    [self.mainScrollView addSubview:self.msgView];
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(frame));
    
    
    self.oldPwdTextField.delegate = self;
    self.pwd2TextField.delegate = self;
    self.pwdTextField.delegate = self;
    
    // 点击背景退出键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backupgroupTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   // 只需要点击非文字输入区域就会响应
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}

-(void)backupgroupTap:(id)sender{
    [self.oldPwdTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.pwd2TextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 接口方法
//修改密码
- (void)changePsw {
    [self makeToast:@"该功能未开通"];
}

//提交
- (IBAction)clickForConfirm:(id)sender {
    if ((self.oldPwdTextField.text.length == 0) || (self.pwdTextField.text.length == 0) || (self.pwd2TextField.text.length == 0)) {
        [self makeToast:@"密码不能为空"];
        return;
    }
    
    // 对比原密码
    NSString *oldPwd = [CommonUtil getObjectFromUD:@"loginpassword"];
    if (![self.oldPwdTextField.text isEqualToString:oldPwd]) {
        [self makeToast:@"原密码错误"];
        return;
    }
    
    // 新密码对比
    if (![self.pwdTextField.text isEqualToString:self.pwd2TextField.text]) {
        [self makeToast:@"两次输入的新密码不一致"];
        return;
    }
    
    [self changePsw];
}

@end
