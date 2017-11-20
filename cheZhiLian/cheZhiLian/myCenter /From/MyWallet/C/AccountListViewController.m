//
//  AccountListViewController.m
//  guangda_student
//
//  Created by Ray on 15/7/13.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AccountListViewController.h"
#import "AccountViewController.h"
#import "CouponListViewController.h"
#import "CoinListViewController.h"
#import "LoginViewController.h"

@interface AccountListViewController ()
{
    NSString *_couponsum;
    NSString *_coinsum;
    NSString *_fCoinsum;
    NSString *_money;
}
@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) IBOutlet UIView *coinView;

- (IBAction)clickForAccount:(id)sender;
- (IBAction)clickForCoupon:(id)sender;
- (IBAction)clickForCoin:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *usedLabel;
@end

@implementation AccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(showMainView) withObject:nil afterDelay:0.1f];
    [self postGetWalletInfo];
//    self.coinView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated  {
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
//账户余额
- (IBAction)clickForAccount:(id)sender {
        AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    viewController.type = @"1";
        [self.navigationController pushViewController:viewController animated:YES];
}
//优惠券
- (IBAction)clickForCoupon:(id)sender {
        CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
}
//学车币
- (IBAction)clickForCoin:(id)sender {
    
        CoinListViewController *viewController = [[CoinListViewController alloc] initWithNibName:@"CoinListViewController" bundle:nil];
        viewController.coinSum = _coinsum;
        viewController.fCoinSum = _fCoinsum;
        [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - 接口方法
// 获取钱包信息
- (void)postGetWalletInfo {
    // 累计消费
    self.usedLabel.text = [NSString stringWithFormat:@"金额%d元 学车币%d个 学时券%d张", 100, 100, 100];
    [self showData];

}

- (void) backLogin{
    
    
    
}

- (void)showData
{
    NSString *money = [UserDataSingleton mainSingleton].balance;
    NSString *moneyStr = [NSString stringWithFormat:@"%@ 元", money];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [string1 addAttribute:NSForegroundColorAttributeName value:MColor(246, 102, 93) range:NSMakeRange(0,money.length)];
    self.moneyLabel.attributedText = string1;
    
    NSString *couponStr = [NSString stringWithFormat:@"%@ 张", @"0"];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:couponStr];
    [string2 addAttribute:NSForegroundColorAttributeName value:MColor(246, 102, 93) range:NSMakeRange(0,_couponsum.length)];
    self.couponLabel.attributedText = string2;
    
    NSString *coinStr = [NSString stringWithFormat:@"%@ 个", @"0"];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:coinStr];
    [string3 addAttribute:NSForegroundColorAttributeName value:MColor(246, 102, 93) range:NSMakeRange(0,_coinsum.length)];
    self.coinLabel.attributedText = string3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
