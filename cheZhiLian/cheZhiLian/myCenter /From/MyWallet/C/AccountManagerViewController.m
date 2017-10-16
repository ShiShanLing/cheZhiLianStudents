//
//  AccountManagerViewController.m
//  guangda_student
//
//  Created by guok on 15/6/1.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "LoginViewController.h"

@interface AccountManagerViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)clickForSubmit:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *inpputViewBg;

@property (strong, nonatomic) IBOutlet UITextField *accountInputView;

@property (strong, nonatomic) IBOutlet UIButton *clearAccountButton;
- (IBAction)clickForClearAccount:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *closeKeyBoard;
- (IBAction)clickForCloseKeyBoard:(id)sender;

@end

@implementation AccountManagerViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)ClickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inpputViewBg.layer.cornerRadius = 5;
    self.inpputViewBg.layer.borderWidth = 1;
    self.inpputViewBg.layer.borderColor = [MColor(199, 199, 199) CGColor];
    
    
    //提交按钮默认不可以点击
    [self.submitButton setTitleColor:MColor(183, 183, 183) forState:UIControlStateNormal];
    self.submitButton.enabled = NO;
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *aliaccount = user_info[@"alipay_account"];
    
    if(![CommonUtil isEmpty:aliaccount]){
        self.accountInputView.text = aliaccount;
    }
    
    UIImage *image1 = [[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *image2 = [[UIImage imageNamed:@"btn_red_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.clearAccountButton setBackgroundImage:image1 forState:UIControlStateNormal];;
    [self.clearAccountButton setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    //注册监听，防止键盘遮挡视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.closeKeyBoard.hidden = NO;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.closeKeyBoard.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *aliaccount = user_info[@"alipay_account"];
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *input = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(![CommonUtil isEmpty:input] && ![input isEqualToString:aliaccount]){
        [self.submitButton setTitleColor:MColor(80, 203, 140) forState:UIControlStateNormal];
        self.submitButton.enabled = YES;
    }else{
        [self.submitButton setTitleColor:MColor(183, 183, 183) forState:UIControlStateNormal];
        self.submitButton.enabled = NO;
    }
    return  YES;
}

// 提交
- (IBAction)clickForSubmit:(id)sender {
    
    NSString *aliaccount = [self.accountInputView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *uri = @"/cmy?action=ChangeAliAccount";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:user_info[@"studentid"] forKey:@"userid"];
    [paramDic setObject:user_info[@"token"] forKey:@"token"];
    [paramDic setObject:@"2" forKey:@"type"];
    [paramDic setObject:aliaccount forKey:@"aliaccount"];
    
}

- (void) backLogin{
    if(![self.navigationController.topViewController isKindOfClass:[LogInViewController class]]){
        LogInViewController *nextViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

// 重置支付宝账号
- (IBAction)clickForClearAccount:(id)sender{
    
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    
    NSString *uri = @"/cmy?action=DelAliAccount";
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:user_info[@"studentid"] forKey:@"userid"];
    [paramDic setObject:user_info[@"token"] forKey:@"token"];
    [paramDic setObject:@"2" forKey:@"type"];
  
}

- (IBAction)clickForCloseKeyBoard:(id)sender {
    [self.accountInputView resignFirstResponder];
}
@end
