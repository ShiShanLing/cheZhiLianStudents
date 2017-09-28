//
//  RegistVercodeViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/17.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "RegistVercodeViewController.h"
#import "RegistViewController.h"
#import "FindPwdViewController.h"

@interface RegistVercodeViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *verCodeTextField;
//@property (strong, nonatomic) IBOutlet UILabel *verCodeLabel;   // 显示获取到的验证码label
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *vercodeLabel;
@property (strong, nonatomic) IBOutlet UIView *phoneUnderline;  // 手机号下划线
@property (strong, nonatomic) IBOutlet UIView *vercodeUnderline;    // 密码下划线

@property (strong, nonatomic) NSString *verCode;                    // 验证码
@property (strong, nonatomic) IBOutlet UIButton *buttonGetCode;     // 获取验证码按钮
@property (strong, nonatomic) IBOutlet UILabel *labelCode;          // 验证码提示label
@property (strong, nonatomic) NSTimer *waitTimer;   // 计时器
@property (strong, nonatomic) IBOutlet UIButton *nextStepBtn;       // 下一步按钮

@property (strong, nonatomic) NSString *phoneNum;

@end

@implementation RegistVercodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.scrollView addSubview:self.contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 类型  1.教练注册  2.教练找回密码  3.学员注册  4.学员找回密码
- (IBAction)requestGetVerCode:(id)sender {
    [self.phoneNumTextField resignFirstResponder];
    [self.verCodeTextField resignFirstResponder];
    
    
}

- (void)countdown {
    int tag = (int)self.labelCode.tag - 1;
    if (tag <= 0) {
        self.buttonGetCode.enabled = YES;
//        self.labelCode.hidden = YES;
        [_waitTimer invalidate];
        _waitTimer = nil;
        
        self.labelCode.text = @"获取验证码";
//        self.labelCode.textColor = [UIColor whiteColor];
    } else {
        self.labelCode.text = [NSString stringWithFormat:@"%d\"后重获", tag];
        self.labelCode.tag = tag;
    }
}

- (IBAction)nextStepClick:(id)sender {
    [self.phoneNumTextField resignFirstResponder];
    [self.verCodeTextField resignFirstResponder];
    
    }

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // 修改下划线的颜色
    if (textField == self.phoneNumTextField) {
        self.phoneUnderline.backgroundColor = [UIColor redColor];
        self.phoneLabel.textColor = [UIColor redColor];
    }
    if (textField == self.verCodeTextField) {
        self.vercodeUnderline.backgroundColor = [UIColor redColor];
        self.vercodeLabel.textColor = [UIColor redColor];
        if (_phoneNum != nil) {
            self.nextStepBtn.enabled = YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.phoneNumTextField) {
        if (self.phoneNumTextField.text.length == 0) {
            self.phoneUnderline.backgroundColor = MColor(211, 211, 211);
            self.phoneLabel.textColor = [UIColor blackColor];
        }else{
            self.phoneUnderline.backgroundColor = [UIColor redColor];
            self.phoneLabel.textColor = [UIColor redColor];
        }
    }else if (textField == self.verCodeTextField) {
        
        if (self.verCodeTextField.text.length == 0) {
            self.vercodeUnderline.backgroundColor = MColor(211, 211, 211);
            self.vercodeLabel.textColor = [UIColor blackColor];
            self.nextStepBtn.enabled = NO;
        }else{
            self.vercodeUnderline.backgroundColor = [UIColor redColor];
            self.vercodeLabel.textColor = [UIColor redColor];
            if (_phoneNum != nil) {
                self.nextStepBtn.enabled = YES;
            }
        }
    }
    return YES;
}

- (IBAction)hideKeyboardClick:(id)sender {
    [_phoneNumTextField resignFirstResponder];
    [_verCodeTextField resignFirstResponder];
}


@end
