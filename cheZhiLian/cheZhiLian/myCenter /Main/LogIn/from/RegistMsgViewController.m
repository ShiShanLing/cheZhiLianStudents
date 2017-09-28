//
//  RegistMsgViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "RegistMsgViewController.h"
#import "CZPhotoPickerController.h"

@interface RegistMsgViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UITextField *numTextField;
@property (strong, nonatomic) IBOutlet UIView *inputView;

@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIView *idCardView;

//证件照按钮

@property (strong, nonatomic) IBOutlet UIButton *cartBtn;
@property (strong, nonatomic) IBOutlet UIButton *cartBackBtn;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cardBackImageView;

//身份证按钮
@property (strong, nonatomic) IBOutlet UIButton *idCardBtn;//正面
@property (strong, nonatomic) IBOutlet UIButton *idCardBackBtn;//反面
@property (strong, nonatomic) IBOutlet UIImageView *idCardImageView;
@property (strong, nonatomic) IBOutlet UIImageView *idCardBackImageView;

//点击的按钮
@property (strong, nonatomic) UIButton *clickButton;

//弹框
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIView *alertMsgView;

//拍照，相册
@property (nonatomic, strong) CZPhotoPickerController *pickPhotoController;
@property (strong, nonatomic) UIImageView *clickImageView;//需要显示图片的imageview
@end

@implementation RegistMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numTextField.delegate = self;
    
    [self showMsgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMsgView{
    CGFloat scale = CGRectGetWidth([UIScreen mainScreen].bounds)/600;
//    CGFloat imageWidth = scale*130;
    CGFloat imageHeight = scale*169;
    
    //设置输入区域的frame
    CGRect frame = self.inputView.frame;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.inputView.frame = frame;
    [self.mainScrollView addSubview:self.inputView];
    
//    CGRect f = self.idCardBackImageView.frame;
    
    //设置证件照区域的frame
    frame = self.cardView.frame;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    frame.origin.y = CGRectGetHeight(self.inputView.frame) + 6;
    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(self.cardBackImageView.frame) + imageHeight;
    self.cardView.frame = frame;
    [self.mainScrollView addSubview:self.cardView];
    
    //设置身份证区域的frame
    frame = self.idCardView.frame;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    frame.origin.y = CGRectGetHeight(self.cardView.frame) + 7 + self.cardView.frame.origin.y;
    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(self.cardBackImageView.frame) + imageHeight;
    self.idCardView.frame = frame;
    [self.mainScrollView addSubview:self.idCardView];
    
    //设置滚动范围
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(frame) + frame.origin.y + 20);
    
    //设置圆角
    self.alertMsgView.layer.cornerRadius = 4;
    self.alertMsgView.layer.masksToBounds = YES;
}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private
- (CZPhotoPickerController *)photoController
{
    typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        
        if (imagePickerController == nil || imageInfoDict == nil) {
            return;
        }
        
        UIImage *image = imageInfoDict[UIImagePickerControllerOriginalImage];
        if (self.clickImageView != nil) {
            self.clickImageView.image = image;
            if (self.clickButton != nil) {
                [self.clickButton setTitle:@"" forState:UIControlStateNormal];
                self.clickButton.adjustsImageWhenDisabled = NO;
            }
            
        }
        [self.alertView removeFromSuperview];
    }];
}

#pragma mark - action
//跳过
- (IBAction)clickForJump:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//提交
- (IBAction)clickForConfirm:(id)sender {
    [self.numTextField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//关闭弹框
- (IBAction)clickForCloseAlert:(id)sender {
    [self.alertView removeFromSuperview];
}

//上传图片
- (IBAction)clickForImage:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.tag = 0;
    
    if (button.tag == 0 && [CZPhotoPickerController canTakePhoto]) {
        //拍照
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        //相册
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

//弹框
- (IBAction)clickForAlert:(id)sender {
    [self.numTextField resignFirstResponder];
    
    UIButton *button = (UIButton *)sender;
    self.clickButton = button;
    if (button.tag == 0){
        //证件照
        self.clickImageView = self.cardImageView;
    }else if (button.tag == 1){
        //身份证正面
        self.clickImageView = self.idCardImageView;
    }else if (button.tag == 2){
        //身份证反面
        self.clickImageView = self.idCardBackImageView;
    }else if (button.tag == 3){
        //证件反面
        self.clickImageView = self.cardBackImageView;
    }else{
        self.clickImageView = nil;
        self.clickButton = nil;
    }
    self.alertView.frame = self.view.frame;
    [self.view addSubview:self.alertView];
}

- (IBAction)clickForClose:(id)sender {
    [self.alertView removeFromSuperview];
}

//编辑
- (IBAction)clickForEdit:(id)sender {
    [self.numTextField becomeFirstResponder];
}
@end
