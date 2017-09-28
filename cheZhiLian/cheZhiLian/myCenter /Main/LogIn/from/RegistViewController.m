//
//  RegistViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistMsgViewController.h"
#import "LearnDriveInfoViewController.h"
#import "AppDelegate.h"

@interface RegistViewController ()<UITextFieldDelegate>{
    CGRect scrollFrame;
}
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

//输入框
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *loginNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwd2TextField;

@property (strong, nonatomic) UIButton *registButton;
@property (strong, nonatomic) UITextField *nowTextField;

// 新的UI修改后的textField
@property (strong, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *trueNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *trueNameLine;
@property (strong, nonatomic) IBOutlet UIView *passwordLine;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneTextField.delegate = self;
    self.loginNameTextField.delegate = self;
    self.nickNameTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.pwd2TextField.delegate = self;
    
    [self performSelector:@selector(showRegistMsg) withObject:nil afterDelay:0.1f];
    
    //注册监听，防止键盘遮挡视图
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)showRegistMsg{
    scrollFrame = self.view.frame;
    
    CGRect frame = self.mainView.frame;
    frame.size.width = CGRectGetWidth(self.view.frame);
    self.mainView.frame = frame;
    [self.mainScrollView addSubview:self.mainView];
    
    
    //注册按钮
    _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = 74;
    _registButton.frame = CGRectMake(x, CGRectGetHeight(frame) + 65, CGRectGetWidth(self.view.frame) - x*2, 45);
    [_registButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    //按钮图片
    UIImage *image1 = [[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *image2 = [[UIImage imageNamed:@"btn_red_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_registButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [_registButton setBackgroundImage:image2 forState:UIControlStateHighlighted];
//    [self.mainScrollView addSubview:self.registButton];
    [self.registButton addTarget:self action:@selector(clickForRegist:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.mainScrollView.contentSize = CGSizeMake(0, self.registButton.frame.origin.y + CGRectGetHeight(self.registButton.frame) + 40);
    self.mainScrollView.contentSize = CGSizeMake(0, 0);
}

- (void)requestRegistInterfaceWithType:(NSString *)type
{
    NSString *trueName = self.trueNameTextField.text;
    NSString *pwdStr = self.passwordTextField.text;
    
    if (_phoneNum.length != 11) {
        [self makeToast:@"请输入正确格式的手机号"];
        return;
    }
    
    if (_phoneNum.length ==0
        || trueName.length == 0
        || pwdStr.length == 0)
    {
        [self makeToast:@"请输入完整信息"];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phoneNum forKey:@"phone"];
    [paramDic setObject:trueName forKey:@"realname"];
    [paramDic setObject:[CommonUtil md5:pwdStr] forKey:@"password"];
    
    if (![type isEqualToString:@"0"])
    {
        [paramDic setObject:type forKey:@"type"];
        [paramDic setObject:_openId forKey:@"openid"];
    }
    
    NSLog(@"paramDic == %@", paramDic);
    

}

// 上传设备号
- (void)uploadDeviceToken:(NSString *)deviceToken
{
   

}

#pragma mark - 监听
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.frame;
    
    if (self.nowTextField == nil) {
        return;
    }
    
    //获取这个textField在self.view中的位置， fromView为textField的父view
    CGRect textFrame = self.nowTextField.superview.frame;
    CGFloat textFieldY = textFrame.origin.y + CGRectGetHeight(textFrame) + self.mainScrollView.frame.origin.y - self.mainScrollView.contentOffset.y;
    
    if(textFieldY < keyboardTop){
        //键盘没有挡住输入框
        return;
    }
    
    //键盘遮挡了输入框
    newTextViewFrame.origin.y = keyboardTop - textFieldY;
    
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    animationDuration += 0.1f;
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = scrollFrame;
    [UIView commitAnimations];
}

#pragma mark - 输入框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    self.nowTextField = textField;
//    return YES;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.nowTextField = textField;
    // 修改下划线的颜色
    if (textField == self.trueNameTextField) {
        self.trueNameLine.backgroundColor = [UIColor redColor];
        self.trueNameLabel.textColor = [UIColor redColor];
    }
    if (textField == self.passwordTextField) {
        self.passwordLine.backgroundColor = [UIColor redColor];
        self.passwordLabel.textColor = [UIColor redColor];
        self.submitBtn.enabled = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.trueNameTextField) {
        if (self.trueNameTextField.text.length == 0) {
            self.trueNameLine.backgroundColor = MColor(211, 211, 211);
            self.trueNameLabel.textColor = [UIColor blackColor];
        }else{
            self.trueNameLine.backgroundColor = [UIColor redColor];
            self.trueNameLabel.textColor = [UIColor redColor];
        }
    }else if (textField == self.passwordTextField) {
        
        if (self.passwordTextField.text.length == 0) {
            self.passwordLine.backgroundColor = MColor(211, 211, 211);
            self.passwordLabel.textColor = [UIColor blackColor];
            self.submitBtn.enabled = NO;
        }else{
            self.passwordLine.backgroundColor = [UIColor redColor];
            self.passwordLabel.textColor = [UIColor redColor];
            self.submitBtn.enabled = YES;
        }
    }
    return YES;
}

- (IBAction)hideKeyboardClick:(id)sender {
    [self.trueNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - action
- (IBAction)clickForRegist:(id)sender
{
//    UIButton *button = (UIButton *)sender;
    [self requestRegistInterfaceWithType:_type];
}
@end
