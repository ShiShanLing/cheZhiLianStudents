//
//  TypeinNumberViewController.m
//  guangda_student
//  Created by Dino on 15/4/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "TypeinNumberViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PayViewController.h"
@interface TypeinNumberViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *typeInView;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashExplainLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@end

@implementation TypeinNumberViewController

- (IBAction)ClickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES
     ];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.status isEqualToString:@"2"]) {
        self.title = @"提现";
    }else {
        self.title = @"充值";
    }
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputField addTarget:self action:@selector(fieldTextChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self viewConfig];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputField resignFirstResponder];
}
#pragma mark 页面配置
- (void)viewConfig {
    self.typeInView.layer.borderWidth = 1;
    self.typeInView.layer.borderColor = [MColor(170, 170, 170) CGColor];
    self.nextStepBtn.layer.cornerRadius = 3;
    self.nextStepBtn.enabled = NO;
    // 提现
    if ([_status isEqualToString:@"2"]) {
        self.titleLabel.text = @"请输入提现金额";
        self.inputField.placeholder = [NSString stringWithFormat:@"账户余额%@元", [UserDataSingleton mainSingleton].balance];
        [self.nextStepBtn setTitle:@"提交" forState:UIControlStateNormal];
        [self requestCashExplainText];
    }
}
#pragma mark - 网络请求
// 提现
- (void)requestApplyCashInterface
{
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/withdraw", kURL_SHY];
    //stuId=4da75644c78040169ced8a6d3736fccb&=10
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"stuId"] =[UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"amount"] = self.inputField.text;
    __weak  TypeinNumberViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC showAlert:responseObject[@"msg"] time:1.2];
            [VC.navigationController popViewControllerAnimated:YES];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}
// 提现解释文字
- (void)requestCashExplainText {
  
}
#pragma mark - 输入框代理
// 不得输入小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
//    NSLog(@"range == %ld,%ld", range.location, range.length);
    //没输入金额时，不能输入0
    if([textField.text isEqualToString:@""]&&[string isEqualToString:@"0"]){
        return NO;
    }
    
    if (self.inputField == textField)
    {
        
        if (range.length == 1 || [self isPureInt:string] || textField.text.intValue <= [UserDataSingleton mainSingleton].balance.floatValue) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Custom
- (void)fieldTextChanged:(UITextField *)field {
    if ([CommonUtil isEmpty:field.text]) {
        self.nextStepBtn.enabled = NO;
        self.nextStepBtn.backgroundColor = MColor(170, 170, 170);
    } else {
        self.nextStepBtn.enabled = YES;
        self.nextStepBtn.backgroundColor = MColor(80, 203, 140);
    }
}

// 整形判断
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void) backLogin{
    if(![self.navigationController.topViewController isKindOfClass:[LogInViewController class]]){
        LogInViewController *nextViewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - Action
- (IBAction)nextStepClick:(id)sender {
    [self.inputField resignFirstResponder];
    
    int money = [UserDataSingleton mainSingleton].balance.floatValue;
    
    int stats = [self.status intValue];
    
    switch (stats) {
        case 1: { // 充值
            
            PayViewController *nextVC = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
            nextVC.cashNum = self.inputField.text;
            nextVC.purpose = 0;
            [self.navigationController pushViewController:nextVC animated:YES];
            break;
        }
            
        case 2: // 提现
            [self requestApplyCashInterface];
            break;
            
        default:
            break;
    }
    
}

@end
