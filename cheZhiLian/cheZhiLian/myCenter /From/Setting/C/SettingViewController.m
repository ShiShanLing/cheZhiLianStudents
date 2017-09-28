//
//  SettingViewController.m
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "SettingBindingViewController.h"
#import "AppDelegate.h"
#import "ComplaintViewController.h"
#import "XBWebViewController.h"
@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (strong, nonatomic) IBOutlet UILabel *cacheLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginoutBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

//弹框
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIView *alertBoxView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image1 = [[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *image2 = [[UIImage imageNamed:@"btn_red_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.loginoutBtn setBackgroundImage:image1 forState:UIControlStateNormal];;
    [self.loginoutBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    image1 = [[UIImage imageNamed:@"btn_green"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    image2 = [[UIImage imageNamed:@"btn_green_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.clearBtn setBackgroundImage:image1 forState:UIControlStateNormal];;
    [self.clearBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    //圆角
    self.alertBoxView.layer.cornerRadius = 4;
    self.alertBoxView.layer.masksToBounds = YES;
    
    //显示主页面，延时执行是为了让自动布局先生效，再设置frame才有效果
    [self performSelector:@selector(showMainView) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    /* 显示缓存大小 */
    NSString *fileDocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    // 图片缓存路径
    NSString *diskCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DataCache"];
    
    CGFloat fileSize = [CommonUtil folderSizeAtPath:fileDocumentsPath];
    CGFloat cachesSize = [CommonUtil folderSizeAtPath:diskCachePath];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM",fileSize + cachesSize];
    
    if ([[CommonUtil currentUtil] isLogin:NO]) {
        self.loginoutBtn.hidden = NO;
    }else{
        self.loginoutBtn.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//显示主页面
- (void)showMainView{
    CGRect frame = self.msgView.frame;
    frame.size.width = CGRectGetWidth(self.mainScrollView.frame);
    self.msgView.frame = frame;
    [self.mainScrollView addSubview:self.msgView];
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(frame) + 40);
}

#pragma mark - action
//清除缓存
- (IBAction)clickForClearCache:(id)sender {
    self.alertView.frame = self.view.frame;
    [self.view addSubview:self.alertView];
    
}

// 投诉
- (IBAction)MyComplaint:(id)sender {
    
        ComplaintViewController *viewController = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    
}

//意见反馈
- (IBAction)clickForFeedback:(id)sender {
    if ([[CommonUtil currentUtil] isLogin]) {
        FeedbackViewController *nextController = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

//关于我们
- (IBAction)clickForAbout:(id)sender {
    AboutViewController *nextController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:nextController animated:YES];
}

//关闭
- (IBAction)clickForClose:(id)sender {
    [self.alertView removeFromSuperview];
}

//确定清理缓存
- (IBAction)clickForClear:(id)sender {
    // 删除本地图片缓存文件
    [CommonUtil deleteImageOfDataCache];
    
    // 删除本地“FileDocuments”目录下的文件
    [CommonUtil deleteAllFileOfFileDocuments];
    
    [self makeToast:@"已清除缓存"];
    self.cacheLabel.text = @"0M";
    [self.alertView removeFromSuperview];
}

//陪驾协议
- (IBAction)protocolClick:(id)sender {
    NSString *url = @"http://www.xiaobaxueche.com/serviceprotocol-s.html";
    XBWebViewController *nextVC = [[XBWebViewController alloc] init];
    nextVC.mainUrl = url;
    nextVC.titleStr = @"陪驾服务协议";
    nextVC.closeBtnHidden = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

//退出登录
- (IBAction)clickForLoginout:(id)sender {
    [CommonUtil logout];
    LogInViewController *nextController = [[LogInViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:nextController animated:YES];
    
}

//账号绑定
//- (IBAction)clickForBinding:(id)sender {
//    if ([[CommonUtil currentUtil] isLogin]) {
//        SettingBindingViewController *nextController = [[SettingBindingViewController alloc] initWithNibName:@"SettingBindingViewController" bundle:nil];
//        [self.navigationController pushViewController:nextController animated:YES];
//    }
//}

//修改密码
//- (IBAction)clickForChangePwd:(id)sender {
//    if ([[CommonUtil currentUtil] isLogin]) {
//        ChangePwdViewController *nextController = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
//        [self.navigationController pushViewController:nextController animated:YES];
//    }
//}

@end
