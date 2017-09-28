//
//  PayViewController.m
//  guangda_student
//
//  Created by 冯彦 on 15/9/28.
//  Copyright © 2015年 daoshun. All rights reserved.
//

#import "PayViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeWeixin = 0,  // 微信支付
    PayTypeAli          // 支付宝支付
};

@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (assign, nonatomic) PayType payType;

@end

@implementation PayViewController

- (IBAction)handleReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.countLabel.text = self.cashNum;
    [self aliClick:self.aliBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayComplete) name:@"wxpaycomplete" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 微信支付
- (void)requestWeixinPayWithRechargeInfo:(NSDictionary *)rechargeInfo
{
    [self makeToast:@"该功能未开通"];
}
#pragma mark 支付宝
- (void)requestAlipayWithRechargeInfo:(NSDictionary *)rechargeInfo
{
    [self makeToast:@"该功能未开通"];
}
#pragma mark - Custom
- (void) backLogin{
  
}

// Alert提示
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

// 获取手机IP
- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
//    NSLog(@"手机的IP是：%@", address);
    return address;
}

// 微信支付结束后调用
- (void)wxPayComplete
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action
- (IBAction)wxClick:(id)sender {
    if (self.wxBtn.selected) return;
    self.wxBtn.selected = YES;
    self.aliBtn.selected = NO;
    self.payType = PayTypeWeixin;
}

- (IBAction)aliClick:(id)sender {
    if (self.aliBtn.selected) return;
    self.aliBtn.selected = YES;
    self.wxBtn.selected = NO;
    self.payType = PayTypeAli;
}

- (IBAction)payClick:(id)sender {
    if (self.purpose == 0) { // 充值
       [self makeToast:@"该功能未开通"];
    }
    else if (self.purpose == 1) { // 报名支付
       [self makeToast:@"该功能未开通"];
    }
}
@end
