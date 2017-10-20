//
//  ComplaintViewController.m
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "ComplaintViewController.h"
#import "ComplaintTableViewCell.h"
#import "MyOrderComplainViewController.h"
#import "DSPullToRefreshManager.h"
#import "DSBottomPullToMoreManager.h"
#import "LoginViewController.h"

@interface ComplaintViewController ()<UITableViewDataSource, UITableViewDelegate, DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient>
{
    BOOL _isCoach;
    NSString *_pageNum;
}

@property (strong, nonatomic) DSPullToRefreshManager *pullToRefresh;    // 下拉刷新
@property (strong, nonatomic) DSBottomPullToMoreManager *pullToMore;    // 上拉加载
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (strong, nonatomic) NSMutableArray *complainListArray;

@end

@implementation ComplaintViewController

- (IBAction)handleReturn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    self.noDataView.hidden = YES;
    _complainListArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getFreshData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 页面设置
- (void)settingView {
    //刷新加载
    self.pullToRefresh = [[DSPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0 tableView:self.mainTableView withClient:self];
    
    //加载更多
    self.pullToMore = [[DSBottomPullToMoreManager alloc] initWithPullToMoreViewHeight:60.0 tableView:self.mainTableView withClient:self];
    
    self.mainTableView.allowsSelection = NO;
}

#pragma mark - 页面特性
// 添加内容textView
- (void)addContentTextView {
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat y = 0;
    NSString *text =@"这个教练不太帅";
    CGFloat textHeight = [CommonUtil sizeWithString:text fontSize:15 sizewidth:kScreen_widht - 20 sizeheight:MAXFLOAT].height;
    y += (textHeight + 15);
    y -= 15;
    return 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"ComplaintTableViewCell";
    ComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ComplaintTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    }
    
    cell.coachPortraitImageView.layer.cornerRadius = 18.0;
    cell.coachPortraitImageView.layer.masksToBounds = YES;
    [cell loadData:nil];

    /* 按钮点击事件 */
    // 追加投诉
    [cell.btnAddOutlet removeTarget:self action:@selector(clickToComplain:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddOutlet addTarget:self action:@selector(clickToComplain:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAddOutlet.tag = 100 + indexPath.row;
    
    // 取消投诉
    [cell.btnCancelOutlet removeTarget:self action:@selector(clickForCancelComplaint:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCancelOutlet addTarget:self action:@selector(clickForCancelComplaint:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCancelOutlet.tag = 200 + indexPath.row;
    
    return cell;
}

#pragma mark - DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pullToRefresh tableViewScrolled];
    [_pullToMore relocatePullToMoreView];    // 重置加载更多控件位置
    [_pullToMore tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pullToRefresh tableViewReleased];
    [_pullToMore tableViewReleased];
}

/* 刷新处理 */
- (void)pullToRefreshTriggered:(DSPullToRefreshManager *)manager {
    [self getFreshData];
}

/* 加载更多 */
- (void)bottomPullToMoreTriggered:(DSBottomPullToMoreManager *)manager {
    [self getMoreData];
}

- (void)getFreshData {
    _pageNum = @"0";
    [self postGetMyComplaint];
}

- (void)getMoreData {
    _pageNum = [NSString stringWithFormat:@"%d", (int)_complainListArray.count / 10];
    [self postGetMoreComplaint];
}

#pragma mark - 网络请求
// test
- (void)printDic:(NSDictionary *)responseObject withTitle:(NSString *)title {
    
}

// 我的投诉列表
- (void)postGetMyComplaint {
}

- (void) backLogin{
    
}
// 更多投诉
- (void)postGetMoreComplaint {
    [self makeToast:@"该功能未开通"];
}
// 取消投诉
- (void)postCancelComplaint:(NSString *)orderId {
   [self makeToast:@"该功能未开通"];
}
#pragma mark - 点击事件
// 投诉
- (void)clickToComplain:(UIButton *)sender {
    NSInteger row = sender.tag - 100;
    NSDictionary *comDict = _complainListArray[row];
    NSDictionary *orderDic = comDict[@"contentlist"][0];
    NSString *orderId = orderDic[@"order_id"];
    
    MyOrderComplainViewController *targetController = [[MyOrderComplainViewController alloc] initWithNibName:@"MyOrderComplainViewController" bundle:nil];
    //targetController.orderModel = orderId;
    [self.navigationController pushViewController:targetController animated:YES];
}

// 取消投诉
- (void)clickForCancelComplaint:(UIButton *)sender {
    NSInteger row = sender.tag - 200;
    NSDictionary *comDict = _complainListArray[row];
    NSDictionary *orderDic = comDict[@"contentlist"][0];
    NSString *orderId = orderDic[@"order_id"];
    
    [self postCancelComplaint:orderId];
}

@end
