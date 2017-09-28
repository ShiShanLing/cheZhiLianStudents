//
//  RecommendCodeViewController.m
//  guangda
//
//  Created by Ray on 15/7/20.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "RecommendCodeViewController.h"
#import "LoginViewController.h"
#import "LearnDriveInfoViewController.h"
#import "AppDelegate.h"
@interface RecommendCodeViewController ()

@property (strong, nonatomic) IBOutlet UITextField *inviteCode;
@property (strong, nonatomic) IBOutlet UIView *inviteCodeView;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation RecommendCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //圆角
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.layer.masksToBounds = YES;
    
    self.inviteCodeView.layer.borderWidth = 1;
    self.inviteCodeView.layer.borderColor = MColor(222, 222, 222).CGColor;
    
}

- (void) getRecommendRecordList{
    [self makeToast:@"改功能未开通"];
}

- (void) backLogin{
  
}

//发送邀请码
- (IBAction)clickForSure:(id)sender {
    if (self.inviteCode.text.length != 8 || [self.inviteCode.text isEqualToString:@"请输入推荐码"]) {
        [self makeToast:@"请输入8位的推荐码"];
    }else{
        [self getRecommendRecordList];
    }
}

- (IBAction)clickForPop:(id)sender {
    if (self.popType == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
