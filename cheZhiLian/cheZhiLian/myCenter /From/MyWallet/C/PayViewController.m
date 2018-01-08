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
#import <AlipaySDK/AlipaySDK.h>
#import "AccountViewController.h"
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
- (void)requestAlipayWithRechargeInfo:(NSDictionary *)rechargeInfo {

}
#pragma mark - Custom
- (void) backLogin{
  
}
//支付宝支付
- (void)requestAliPaymentSignature:(NSString *)price subject:(NSString *)subject outTradeNo:(NSString *)outTradeNo body:(NSString *)body {
    NSString *URL_Str = [NSString stringWithFormat:@"%@/alipay/api/generateSignature",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"body"] = body;
    URL_Dic[@"subject"]=subject;
    URL_Dic[@"outTradeNo"]=outTradeNo;
    URL_Dic[@"totalAmount"] = price;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block PayViewController *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"requestPaymentSignature%@", responseObject);
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC performSelector:@selector(delayMethod)];
        if ([str isEqualToString:@"1"]) {
            NSString *signature = responseObject[@"data"];
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"chezhilianScheme";
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:signature fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSString *resultStatus = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
                NSInteger state = resultStatus.integerValue;
                switch (state) {
                    case 9000:{
                        [VC showAlert:@"订单支付成功"];
                        UINavigationController *navigationVC = VC.navigationController;
                        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                        for (UIViewController *tempVC in navigationVC.viewControllers) {
                            [viewControllers addObject:tempVC];
                            if ([tempVC isKindOfClass:[AccountViewController class]]) {
                                break;
                            }
                        }
                        [navigationVC setViewControllers:viewControllers animated:YES];
                        [navigationVC popViewControllerAnimated:YES];
                        
                    }
                        break;
                    case 8000:
                        [VC showAlert:@"正在处理中，支付结果未知（有可能已经支付成功），请查询订单列表中订单的支付状态"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 4000:
                        [VC showAlert:@"订单支付失败"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 6001:
                        [VC showAlert:@"用户中途取消"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 6002:
                        [VC showAlert:@"网络连接出错"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    default:
                        break;
                }
                
                NSLog(@"DetermineBtnClick = %@",resultDic);
                
            }];
        }else {
            [VC showAlert:@"订单提交失败请重试!"];
            NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC performSelector:@selector(delayMethod)];
        [VC showAlert:@"网络出现问题.请稍后再试!" time:1.0];
        NSLog(@"%@", error);
    }];
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
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/recharge", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"stuId"] = [UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"schoolId"] = [UserDataSingleton mainSingleton].kStoreId;
    URL_Dic[@"amount"] = self.cashNum;
    __weak  PayViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"报名数据responseObject%@", responseObject);
        NSString *resultStr= [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        //[VC showAlert:responseObject[@"msg"] time:1.2];
        [self performSelector:@selector(delayMethod)];
        if ([resultStr isEqualToString:@"1"]) {
            NSString *price;
            NSString *subject;
            NSString *outTradeNo;
            NSString *body;
            NSArray *dataArray = responseObject[@"data"];
            NSDictionary *dataDic = dataArray[0];
            outTradeNo = dataDic[@"outTradeNo"];
            price=[NSString stringWithFormat:@"%@", dataDic[@"totalAmount"]];
            subject =dataDic[@"subject"];
            body = dataDic[@"body"];
            [self requestAliPaymentSignature:price subject:subject outTradeNo:outTradeNo body:body];
            
        }else {
            [VC makeToast:@"报名失败,请重试!"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}
@end
