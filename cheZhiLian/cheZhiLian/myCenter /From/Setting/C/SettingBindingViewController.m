//
//  SettingBindingViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/31.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "SettingBindingViewController.h"
#import "BindingViewController.h"
#import "AppDelegate.h"

@interface SettingBindingViewController ()
@property (strong, nonatomic) IBOutlet UILabel *qqLabel;
@property (strong, nonatomic) IBOutlet UILabel *weixinLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiboLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *msgView;
@end

@implementation SettingBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //显示主页面，延时执行是为了让自动布局先生效，再设置frame才有效果
    [self performSelector:@selector(showMainView) withObject:nil afterDelay:0.1f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//显示页面
- (void)showMainView{
    CGRect frame = self.msgView.frame;
    frame.size.width = CGRectGetWidth(self.mainScrollView.frame);
    self.msgView.frame = frame;
    [self.mainScrollView addSubview:self.msgView];
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.msgView.frame) + 20);
    
}

// qq 1
- (IBAction)qqBindUserAccount:(id)sender
{
   
    
}

// 微信 2
- (IBAction)wxBindUserAccount:(id)sender
{
    
    
    
    
}

// 微博 3
- (IBAction)wbBindUserAccount:(id)sender
{
    
    
    
}

// 请求绑定第三方账号接口
- (void)bindAccountWithUserID:(NSString *)userId openID:(NSString *)openId type:(NSString *)type
{
   

}

- (void)refreshBindInfo
{


}


@end
