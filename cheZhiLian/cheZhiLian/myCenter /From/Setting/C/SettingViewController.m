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
    self.loginoutBtn.layer.cornerRadius = 5;
    self.loginoutBtn.layer.masksToBounds = YES;
   
    UIImage *image1 = [[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *image2 = [[UIImage imageNamed:@"btn_red_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    
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
    [self showAlert:@"该功能未开通" time:0.8];
    return;
        ComplaintViewController *viewController = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    
}

//意见反馈
- (IBAction)clickForFeedback:(id)sender {
    [self showAlert:@"该功能未开通" time:0.8];
    return;
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
    [self showAlert:@"该功能未开通" time:0.8];
    return;
    NSString *url = @"http://www.xiaobaxueche.com/serviceprotocol-s.html";
    XBWebViewController *nextVC = [[XBWebViewController alloc] init];
    nextVC.mainUrl = url;
    nextVC.titleStr = @"陪驾服务协议";
    nextVC.closeBtnHidden = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

//退出登录
- (IBAction)clickForLoginout:(id)sender {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [userData  removeAllObjects];
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
    //输入写入
    [userData writeToFile:filename atomically:YES];
    [UserDataSingleton mainSingleton].studentsId = @"";
    [UserDataSingleton mainSingleton].subState = @"";
    [UserDataSingleton mainSingleton].subState = @"20";
    [UserDataSingleton mainSingleton].coachId = @"";
    [UserDataSingleton mainSingleton].balance = @"";
    [UserDataSingleton mainSingleton].userModel =nil;
    [self showAlert:@"退出登录成功" time:1.2];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app logIn];
    
}


@end
