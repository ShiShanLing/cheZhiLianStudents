//
//  ViewController.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/5.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "ViewController.h"
#import "HomePageVC.h"
#import "AppointCoachViewController.h"
#import "CoachDetailViewController.h"

#import "MyCenterVC.h"
#define EXERCISE_URL @"http://xiaobaxueche.com:8080/dadmin2.0.0/examination/index.jsp" // 正式服
@interface ViewController ()<TabBarViewDelegate, UIWebViewDelegate>
@property (strong, nonatomic) TabBarView *tabBarView;
@property (nonatomic, strong)CoachDetailViewController *CoachDetailVC;
/**
 *
 */
@property (nonatomic, strong)MyCenterVC *serveVC;
/**
 *
 */
@property (nonatomic, strong)HomePageVC *homePageVC;                //主界面展示学车信息
@property (strong, nonatomic) UIWebView *exerciseView;              // 题库
@property (assign, nonatomic) BOOL webViewIsLoaded;                 // 题库是否已加载
@property (strong, nonatomic) UIView *exerciseLoadFailView;         // 题库加载失败显示页面
@property (copy, nonatomic) NSURLRequest *tarRequest;               // 当前加载的题库页面request
/**
 *
 */
@property (nonatomic, strong)NavigationBarView *barView;//
@property (nonatomic, strong)UIView *backImageView1;//规格选择弹出视图的背景色
@end

@implementation ViewController{
    int _actFlag; // 活动类型 0:不显示 1:跳转到url 2:内部功能
    NSUInteger _itemIndex; // 0：车智联题库 1：车智联学车 2：车智联陪驾 3：车智联服务 初始值为1
    NSUInteger _lastItemIndex;
    NSURLRequest *_failRequest; // 加载失败request
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   int 转 nsstring 再转 nsdate
    NSString *str=[NSString stringWithFormat:@"%@", @"1504022400000"];
    NSTimeInterval time=[str doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *newTime = [NSString stringWithFormat:@"%@ 00:00:00", [dateFormatter stringFromDate:detaildate]];
    
    NSString *SJCStr = [NSString stringWithFormat:@"%.0f000", [[CommonUtil getDateForString:newTime format:nil] timeIntervalSince1970]];
//    NSLog(@"最终转为字符串时间1 = %@  SJCStr%@", newTime, SJCStr);

    
    [self ShoppingCellClickEvent];
    self.navigationController.navigationBar.hidden = YES;
    self.homePageVC = [[HomePageVC alloc] init];
    self.homePageVC.view.width = kScreen_widht;
    self.homePageVC.view.x = 0;
    self.homePageVC.view.y = 0;
    self.homePageVC.view.height = kScreen_heigth - 80;
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.homePageVC.view];
    _itemIndex = 1;
    _lastItemIndex = _itemIndex;

    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"request url === %@",url);
    if ([url isEqualToString:@"about:blank"]) {
        return NO;
    }
    self.tarRequest = request;
    if (self.webViewIsLoaded) {
        self.webViewIsLoaded = YES;
        [self.exerciseLoadFailView removeFromSuperview];
    }
    if (![url isEqualToString:EXERCISE_URL]) {
        
        [self exerciseViewCompress];
        
    } else {
        [self exerciseViewStretch];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  //  [DejalBezelActivityView activityViewForView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  //  [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    NSLog(@"webviewError -----  %@", error);
    _failRequest = webView.request;
    if (!(self.exerciseView.height < kScreen_heigth)) {
        [self exerciseViewCompress];
    }
    self.webViewIsLoaded = NO;
    [self.exerciseView addSubview:self.exerciseLoadFailView];
}

// 题库页面全屏显示
- (void)exerciseViewStretch
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.exerciseView.top = 0;
        self.exerciseView.height = kScreen_heigth;
    }];
}

// 题库页面非全屏显示
- (void)exerciseViewCompress
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarView.bottom = kScreen_heigth;
        
        self.exerciseView.top = 0;
        self.exerciseView.height = kScreen_heigth - self.tabBarView.height;
    }];
    
}

#pragma mark PayPopUpViewDelegate 确定支付选择支付方式
//创建一个存在于视图最上层的UIViewController
- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)ShoppingCellClickEvent{//
    //xia面是弹窗的初始化
    UIViewController *topVC = [self appRootViewController];
    if (!self.backImageView1) {
        self.backImageView1 = [[UIView alloc] initWithFrame:self.view.bounds];
        self.backImageView1.backgroundColor = [UIColor blackColor];
        self.backImageView1.alpha = 0.3f;
        self.backImageView1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        tapGesture.numberOfTapsRequired=1;
        [self.backImageView1 addGestureRecognizer:tapGesture];
    }
    [topVC.view addSubview:self.backImageView1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_heigth - 80, kScreen_widht, 80)];
    view.backgroundColor = [UIColor redColor];
    [topVC.view addSubview:view];
}

@end
