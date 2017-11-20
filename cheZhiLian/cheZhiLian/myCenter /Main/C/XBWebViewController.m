//
//  XBWebViewController.m
//  guangda_student
//
//  Created by 冯彦 on 15/11/13.
//  Copyright © 2015年 daoshun. All rights reserved.
//

#import "XBWebViewController.h"

@interface XBWebViewController () <UIWebViewDelegate> {
    NSString *_failedUrl;
    BOOL _loadSuccess;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *mainWeb;
@property (strong, nonatomic) UIView *loadFailView;         // 加载失败显示页面
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation XBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleStr;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_mainUrl]];
    [self.mainWeb loadRequest:request];
    if (self.closeBtnHidden) {
        self.closeBtn.hidden = YES;
    }
}

// 加载失败页面
- (UIView *)loadFailView
{
    if (!_loadFailView) {
        _loadFailView = [[UIView alloc] initWithFrame:self.mainWeb.bounds];
        _loadFailView.backgroundColor = [UIColor whiteColor];
        _loadFailView.layer.masksToBounds = YES;
        
        UIImageView *image = [[UIImageView alloc] init];
        [_loadFailView addSubview:image];
        image.width = 181;
        image.height = 181;
        image.center = CGPointMake(self.mainWeb.width/2, self.mainWeb.height/2 - 50);
        image.image = [UIImage imageNamed:@"bg_net_error"];
        
        UILabel *label = [[UILabel alloc] init];
        [_loadFailView addSubview:label];
        label.width = kScreen_widht;
        label.height = 15;
        label.x = 0;
        label.top = image.bottom + 25;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = MColor(170, 170, 170);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = @"页面加载失败，请检查您的网络，点我重新加载。";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadFailView addSubview:btn];
        btn.frame = [UIScreen mainScreen].bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadFailView;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_loadSuccess == NO) {
        [self.loadFailView removeFromSuperview];
    }
    _loadSuccess = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"webview didFailLoadWithError %@ , and err is %@",webView.debugDescription, error.debugDescription);
    _failedUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"failURL === %@", _failedUrl);
    _loadSuccess = NO;
    [self.mainWeb addSubview:self.loadFailView];
}
#pragma mark - Action
- (IBAction)backClick:(id)sender {
    if (![self.mainWeb canGoBack]) {
        if ([self.titleStr isEqualToString:@"小巴商城"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    [self.mainWeb goBack];
}

- (IBAction)closeClick:(id)sender {
    if ([self.titleStr isEqualToString:@"小巴商城"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)reloadClick {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_failedUrl]];
    [self.mainWeb loadRequest:request];
}

@end
