//
//  AccountViewController.m
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "TypeinNumberViewController.h"
#import "AppDelegate.h"
#import "AccountManagerViewController.h"
#import "LoginViewController.h"

@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *currentMoneyLabel;  // 当前金额
@property (strong, nonatomic) IBOutlet UILabel *frozenMoneyLabel;   // 冻结金额
@property (strong, nonatomic) NSArray *recordList;

@property (strong, nonatomic) IBOutlet UIView *moneyView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;       // 充值
@property (strong, nonatomic) IBOutlet UIButton *getCashBtn;        // 提现

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;

@property (copy, nonatomic) NSString *balance;

- (IBAction)clickForAccountManager:(id)sender;

@end

@implementation AccountViewController

- (IBAction)handleReturn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       [self requestAccountRemainMoneyInterface];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rechargeBtn.layer.cornerRadius = 5;
    self.getCashBtn.layer.cornerRadius = 5;
    
    self.moneyView.layer.cornerRadius = 5;
    self.moneyView.layer.borderColor = [MColor(199, 199, 199) CGColor];
    self.moneyView.layer.borderWidth = .5;
    
    self.topLineHeight.constant = .5;
    self.bottomLineHeight.constant = .5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 充值
- (IBAction)rechargeClick:(id)sender {
    TypeinNumberViewController *viewController = [[TypeinNumberViewController alloc] initWithNibName:@"TypeinNumberViewController" bundle:nil];
    viewController.status = @"1";
    [self.navigationController pushViewController:viewController animated:YES];
}

// 提现
- (IBAction)getCashClick:(id)sender {
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSString *aliaccount = user_info[@"alipay_account"];
    if([CommonUtil isEmpty:aliaccount]){
        [self makeToast:@"您还未设置支付宝账户,请先去账户管理页面设置您的支付宝账户"];
        return;
    }
    
    TypeinNumberViewController *viewController = [[TypeinNumberViewController alloc] initWithNibName:@"TypeinNumberViewController" bundle:nil];
    viewController.status = @"2";
    viewController.balance = self.balance;
    [self.navigationController pushViewController:viewController animated:YES];
}

# pragma mark - 网络请求
- (void)requestAccountRemainMoneyInterface
{
 
}

- (void) backLogin{
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"accountCell";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    }
    
    NSDictionary *recordDic = self.recordList[indexPath.row];
    [cell loadData:recordDic];
    return cell;
}

- (IBAction)clickForAccountManager:(id)sender {
    AccountManagerViewController *nextViewController = [[AccountManagerViewController alloc] initWithNibName:@"AccountManagerViewController" bundle:nil];
    [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
