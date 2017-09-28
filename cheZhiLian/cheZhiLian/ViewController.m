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
    NSUInteger _itemIndex; // 0：小巴题库 1：小巴学车 2：小巴陪驾 3：小巴服务 初始值为1
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
    [self addTabBarView];
    // 题库
    self.exerciseView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreen_widht, kScreen_heigth - 80 - 64)];
    self.exerciseView.delegate = self;
    self.webViewIsLoaded = NO;
    [self addExerciseLoadFailView];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"NavigationBarView" owner:self options:nil];
    //得到第一个UIView
    NavigationBarView *barView= [nib objectAtIndex:0];
    barView.frame = CGRectMake(0, 0, kScreen_widht, 64);
    [self.view addSubview:barView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    

}
// 题库加载失败页面
- (void)addExerciseLoadFailView {
    self.exerciseLoadFailView = [[UIView alloc] initWithFrame:self.exerciseView.bounds];
    [self.exerciseView addSubview:self.exerciseLoadFailView];
    self.exerciseLoadFailView.backgroundColor = [UIColor whiteColor];
    self.exerciseLoadFailView.layer.masksToBounds = YES;
    
    UIImageView *image = [[UIImageView alloc] init];
    [self.exerciseLoadFailView addSubview:image];
    image.width = 181;
    image.height = 181;
    image.center = CGPointMake(self.exerciseView.width/2, self.exerciseView.height/2 - 50);
    image.image = [UIImage imageNamed:@"bg_net_error"];
    
    UILabel *label = [[UILabel alloc] init];
    [self.exerciseLoadFailView addSubview:label];
    label.width = kScreen_widht;
    label.height = 15;
    label.x = 0;
    label.top = image.bottom + 25;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = MColor(170, 170, 170);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"题库加载失败，请检查您的网络，点我重新加载。";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exerciseLoadFailView addSubview:btn];
    btn.frame = [UIScreen mainScreen].bounds;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(reloadExerciseClick) forControlEvents:UIControlEventTouchUpInside];
    
}
// 重载题库页面
- (void)reloadExerciseClick {
    [self.exerciseView loadRequest:_failRequest];
}
// 添加tabBar
- (void)addTabBarView
{
    TabBarView *tabBarView = [[TabBarView alloc]init];
    self.tabBarView = tabBarView;
    tabBarView.width = kScreen_widht;
    tabBarView.height = 80;
    tabBarView.x = 0;
    tabBarView.bottom = kScreen_heigth;
    tabBarView.backgroundColor = MColor(249, 249, 249);
    tabBarView.delegate = self;
    tabBarView.itemsCount = 4;
    [self.view addSubview:tabBarView];
    
    UIView *topLine = [[UIView alloc] init];
    [tabBarView addSubview:topLine];
    topLine.width = kScreen_widht;
    topLine.height = 1;
    topLine.x = 0;
    topLine.y = 0;
    topLine.backgroundColor = MColor(214, 214, 214);
    
    [tabBarView itemsTitleConfig:@[@"题库", @"学车", @"预约", @"服务"]];
}
- (void)itemClick:(NSUInteger)itemIndex {
   
    if (_itemIndex == 0) { // 题库
         [self.exerciseView removeFromSuperview];
    }
    if (_itemIndex == 1) {
        [self.homePageVC.view removeFromSuperview];
    }
    if (_itemIndex == 2) { //
        [self.CoachDetailVC.view removeFromSuperview];
    }
    if (_itemIndex == 3) { // 小巴服务页面
        [self.serveVC.view removeFromSuperview];
        self.serveVC = nil;
    }
    _lastItemIndex = _itemIndex;
    _itemIndex = itemIndex;
    
       // 题库
    if (itemIndex == 0) {
        self.navigationController.navigationBar.hidden = NO;
        [self.view addSubview:self.exerciseView];
        if (!self.webViewIsLoaded) {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:EXERCISE_URL]];
            [self.exerciseView loadRequest:request];
        }
    }
    // 学车
    else if (itemIndex == 1) {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationItem.title = @"首页";
        self.homePageVC = [[HomePageVC alloc] init];
        self.homePageVC.view.width = kScreen_widht;
        self.homePageVC.view.height = kScreen_heigth - 80;
        [self.view addSubview:self.homePageVC.view];
    }
    // 预约
    else if (itemIndex == 2) {
        self.navigationController.navigationBar.hidden = YES;
        self.CoachDetailVC = [[CoachDetailViewController alloc] initWithNibName:@"CoachDetailViewController" bundle:nil];
        self.CoachDetailVC.view.width = kScreen_widht;
        self.CoachDetailVC.view.height = kScreen_heigth - 80;
        [self.view addSubview:self.CoachDetailVC.view];
    }
    // 服务
    else if (itemIndex == 3) {
         [self clickForServe];
    }

}

// 在线报名、预约考试等服务
- (void)clickForServe {
    if (!self.serveVC) {
        self.serveVC = [[MyCenterVC alloc] init];
        self.serveVC.view.width = kScreen_widht;
        self.serveVC.view.x = 0;
        self.serveVC.view.y = 0;
        self.serveVC.view.height = kScreen_heigth - 80;
    }
    [self.view addSubview:self.serveVC.view];
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
