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


/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray *dataArray;


@property (copy, nonatomic) NSString *balance;



- (IBAction)clickForAccountManager:(id)sender;

@end

@implementation AccountViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (IBAction)handleReturn:(id)sender {
    if ([self.type isEqualToString:@"1"]) {
              [self.navigationController popViewControllerAnimated:YES];
    }else if([self.type isEqualToString:@"7"]){
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
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
//获取账交易数据
- (void)requestData {
    [self respondsToSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/findAccountLog", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"stuId"] = [UserDataSingleton mainSingleton].studentsId;
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak  AccountViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr =[NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC respondsToSelector:@selector(delayMethod)];
        if ([resultStr isEqualToString:@"1"]) {
            [VC parsingData:responseObject];
        }else {
            [VC  showAlert:responseObject[@"msg"] time:1.2];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC respondsToSelector:@selector(delayMethod)];
        [VC showAlert:@"网络超时请重试" time:1.2];
        NSLog(@"error%@", error);
    }];

}
- (void)parsingData:(NSDictionary *)dataDic {
    [self.dataArray removeAllObjects];
    self.currentMoneyLabel.text  = [NSString stringWithFormat:@"%@", dataDic[@"balance"]];
    [UserDataSingleton mainSingleton].balance =[NSString stringWithFormat:@"%@", dataDic[@"balance"]];
    NSArray *dataArray = dataDic[@"data"];
    if (dataArray.count == 0) {
        return;
    }
    for (NSDictionary *modelDic in dataArray) {
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"TradingRecordsModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        TradingRecordsModel *model = [[TradingRecordsModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        for (NSString *key in modelDic) {
            [model setValue:modelDic[key] forKey:key];
        }
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
// 充值
- (IBAction)rechargeClick:(id)sender {
    TypeinNumberViewController *viewController = [[TypeinNumberViewController alloc] initWithNibName:@"TypeinNumberViewController" bundle:nil];
    viewController.status = @"1";
    [self.navigationController pushViewController:viewController animated:YES];
}
// 提现
- (IBAction)getCashClick:(id)sender {
//    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
//    NSString *aliaccount = user_info[@"alipay_account"];
//    if([CommonUtil isEmpty:aliaccount]){
//        [self makeToast:@"您还未设置支付宝账户,请先去账户管理页面设置您的支付宝账户"];
//        return;
//    }
    TypeinNumberViewController *viewController = [[TypeinNumberViewController alloc] initWithNibName:@"TypeinNumberViewController" bundle:nil];
    viewController.status = @"2";
    viewController.balance = self.balance;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void) backLogin{
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    
    TradingRecordsModel *model = self.dataArray[indexPath.row];
    [cell loadData:model];
    return cell;
}

- (IBAction)clickForAccountManager:(id)sender {
    AccountManagerViewController *nextViewController = [[AccountManagerViewController alloc] initWithNibName:@"AccountManagerViewController" bundle:nil];
    [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
