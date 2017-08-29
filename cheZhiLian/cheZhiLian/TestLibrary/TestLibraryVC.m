//
//  TestLibraryVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/14.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "TestLibraryVC.h"
#define EXERCISE_URL @"http://xiaobaxueche.com:8080/dadmin2.0.0/examination/index.jsp" // 正式服
@interface TestLibraryVC ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *exerciseView;              // 题库
@property (assign, nonatomic) BOOL webViewIsLoaded;                 // 题库是否已加载
@property (strong, nonatomic) UIView *exerciseLoadFailView;         // 题库加载失败显示页面
@property (copy, nonatomic) NSURLRequest *tarRequest;               // 当前加载的题库页面request
@end

@implementation TestLibraryVC {
    NSURLRequest *_failRequest; // 加载失败request
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    // 题库
    self.exerciseView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreen_widht, kScreen_heigth - 80 - 64)];
    self.exerciseView.delegate = self;
    self.webViewIsLoaded = NO;
    [self.view addSubview:self.exerciseView];
    [self addExerciseLoadFailView];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 题库页面全屏显示
- (void)exerciseViewStretch
{
   
}

// 题库页面非全屏显示
- (void)exerciseViewCompress
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.exerciseView.height = kScreen_heigth - 64 -49;
    }];
    
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
    [DejalBezelActivityView activityViewForView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    _failRequest = webView.request;
    if (!(self.exerciseView.height < kScreen_heigth)) {
        [self exerciseViewCompress];
    }
    self.webViewIsLoaded = NO;
    [self.exerciseView addSubview:self.exerciseLoadFailView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
