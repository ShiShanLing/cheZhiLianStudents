//
//  BindingViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/31.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "BindingViewController.h"
#import "RegistViewController.h"
#import "AppDelegate.h"

@interface BindingViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) UITextField *nowTextField;//选中的输入框
@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    //展示内容，延时是为了让自动布局先生效，然后设置frame才有效
    [self performSelector:@selector(showMainView) withObject:nil afterDelay:0.1f];
    
    //注册监听，防止键盘遮挡视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)showMainView
{
    CGRect frame = self.msgView.frame;
    frame.size.width = CGRectGetWidth(self.view.frame);
    self.msgView.frame = frame;
    [self.mainScrollView addSubview:self.msgView];
    
    //按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(CGRectGetWidth(frame) - 173 - 20, CGRectGetHeight(frame) + 31, 173, 40);
    [registBtn setTitle:@"还没帐号？立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [registBtn addTarget:self action:@selector(clickForRegist:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:registBtn];
    
    //按钮图片
    UIImage *image1 = [[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *image2 = [[UIImage imageNamed:@"btn_red_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [registBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [registBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    self.mainScrollView.contentSize = CGSizeMake(0, registBtn.frame.origin.y + CGRectGetHeight(registBtn.frame) + 20);
}

// 请求绑定账号接口
- (void)requestBindAccountInterfaceWithType:(NSString *)type
{
 [self makeToast:@"该功能未开通"];
}

#pragma mark - 监听
- (void)keyboardWillShow:(NSNotification *)notification {
    //    scrollFrame = self.view.frame;
    
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
    CGFloat textFieldY = textFrame.origin.y + CGRectGetHeight(textFrame);
    
    if(textFieldY < keyboardTop)
    {
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
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
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
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight([UIScreen mainScreen].bounds));
    [UIView commitAnimations];
}

#pragma mark - 输入框代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.nowTextField = textField;
    return YES;
}

#pragma mark - action
///提交
- (IBAction)clickForConfirm:(id)sender {
    [self requestBindAccountInterfaceWithType:_type];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

//跳过
- (IBAction)clickForJump:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickForRegist:(UIButton *)button{
    RegistViewController *nextController = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    nextController.type = _type;
    nextController.openId = _openId;
    [self.navigationController pushViewController:nextController animated:YES];
}
@end
