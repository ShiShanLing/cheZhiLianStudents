//
//  MyOrderViewController.m
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderListTableViewCell.h"
#import "AppDelegate.h"
#import "DSPullToRefreshManager.h"
#import "DSBottomPullToMoreManager.h"
#import "AppointCoachViewController.h"
#import "MyOrderComplainViewController.h"
#import "MyOrderEvaluationViewController.h"
typedef NS_OPTIONS(NSUInteger, OrderListType) {
    OrderListTypeUncomplete = 0,    // 未完成订单
    OrderListTypeWaitEvaluate,      // 待评价订单
    OrderListTypeComplete,          // 已完成订单
    OrderListTypeComplained,        // 待处理订单
};

@interface MyOrderViewController ()<UITableViewDataSource, UITableViewDelegate, DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient,UIAlertViewDelegate, OrderListTableViewCellDelegate> {
    CGFloat _rowHeight;
    NSString *_pageNum;
    int _alertType; // 提示框类型 1.确认上车 2.确认下车 3.取消投诉
}
@property (strong, nonatomic) DSPullToRefreshManager *pullToRefresh;    // 下拉刷新
@property (strong, nonatomic) DSBottomPullToMoreManager *pullToMore;    // 上拉加载
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

// 确认取消订单页面
@property (strong, nonatomic) IBOutlet UIView *moreOperationView; // 更多操作
@property (strong, nonatomic) IBOutlet UIView *sureCancelOrderView; // 确认取消订单
@property (weak, nonatomic) IBOutlet UIButton *postCancelOrderBtn; // 请教练确认

// 导航栏选择条
@property (strong, nonatomic) IBOutlet UIView *selectBarView;
@property (strong, nonatomic) IBOutlet UIButton *unfinishedBtn;         // 未完成
@property (strong, nonatomic) IBOutlet UIButton *waiEvaluateBtn;        // 待评价
@property (strong, nonatomic) IBOutlet UIButton *historyBtn;            // 已完成
@property (strong, nonatomic) IBOutlet UIButton *complainedOrdersBtn;   // 已投诉
@property (assign, nonatomic) OrderListType orderListType;
@property (assign, nonatomic) OrderListType targetOrderListType;
- (IBAction)clickForUnfinishedOrder:(id)sender;
- (IBAction)clickForWaitEvaluateOrder:(id)sender;
- (IBAction)clickForHistoricOrder:(id)sender;
@property (copy, nonatomic) NSString *cancelOrderId;

/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray *orderArray;


@end

@implementation MyOrderViewController

- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
      self.navigationController.navigationBarHidden = YES;
    [self getFreshData];
    [self requestData];
}
-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _rowHeight = 235;
    [self settingView];
}
#pragma mark 请求数据
- (void)requestData{
    //http://192.168.100.101:8080/com-zerosoft-boot-assembly-seller-local-1.0.0-SNAPSHOT/train/api/listReservation?stuId=794c68fe981a448b88ba4e4061bacedf
    NSString *URL_Str = [NSString stringWithFormat:@"%@/train/api/listReservation", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
    NSLog(@"URL_Dic%@", URL_Dic);
    
    
    __weak MyOrderViewController *VC = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.requestSerializer.timeoutInterval = 20;// 网络超时时长设置
    [manager POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@",responseObject);
        NSString *resultStr =[NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
        [VC ParsingOrderData:responseObject[@"data"]];
        }else {
            [VC  showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"网络出错!!" time:1.2];
    }];
}
- (void)ParsingOrderData:(NSArray *)dataArray {
    [self.orderArray removeAllObjects];
    
    if (dataArray.count == 0) {
        [self  showAlert:@"您还没有订单" time:1.2];
        return;
    }
    
    for (NSDictionary *dataDic in dataArray) {
        NSEntityDescription *des = [NSEntityDescription entityForName:@"ParsingOrderDataModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        ParsingOrderDataModel *model = [[ParsingOrderDataModel  alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        
        for (NSString *key in dataDic) {
            NSLog(@"%@key", key);
            [model setValue:dataDic[key] forKey:key];
        }
        [self.orderArray addObject:model];
    }
   // NSLog(@"self.orderArray%@", self.orderArray);
    [self.mainTableView reloadData];
}
- (void)settingView {
    // 按钮组边框
    self.selectBarView.layer.cornerRadius = 4;
    self.selectBarView.layer.borderWidth = 1;
    self.selectBarView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.waiEvaluateBtn.layer.borderWidth = 1;
    self.waiEvaluateBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.historyBtn.layer.borderWidth = 1;
    self.historyBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self.unfinishedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unfinishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.historyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.waiEvaluateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.waiEvaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.complainedOrdersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.complainedOrdersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self oneButtonSellected:self.unfinishedBtn];
    
    [self sureCancelOrderViewConfig];
}

// 确定取消订单弹框
- (void)sureCancelOrderViewConfig {
    self.moreOperationView.frame = [UIScreen mainScreen].bounds;
    self.sureCancelOrderView.bounds = CGRectMake(0, 0, 300, 150);
    self.sureCancelOrderView.center = CGPointMake(kScreen_widht/2, kScreen_heigth/2);
    self.sureCancelOrderView.layer.borderWidth = 1;
    self.sureCancelOrderView.layer.borderColor = [MColor(204, 204, 204) CGColor];
    self.sureCancelOrderView.layer.cornerRadius = 4;
    
    // 请教练确认
    self.postCancelOrderBtn.layer.borderWidth = 0.8;
    self.postCancelOrderBtn.layer.borderColor = [MColor(204, 204, 204) CGColor];
    self.postCancelOrderBtn.layer.cornerRadius = 3;
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 235;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"OrderListTableViewCellIdentifier";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = self.orderArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
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
    
}

- (void)getMoreData {
    
    _pageNum = [NSString stringWithFormat:@"%d", [_pageNum intValue] + 1];
    
}

- (void)pageNumMinus {
    _pageNum = [NSString stringWithFormat:@"%d", [_pageNum intValue] - 1];
}

#pragma mark - Private
// 判断是否有数据
- (void)ifNoData {
    if (/* DISABLES CODE */ (1)) {
        self.mainTableView.hidden = YES;
        self.bgImageView.hidden = NO;
    }
    else {
        self.mainTableView.hidden = NO;
        self.bgImageView.hidden = YES;
    }
}

// 设置按钮状态
- (void)oneButtonSellected:(UIButton *)button {
    self.unfinishedBtn.backgroundColor = [UIColor clearColor];
    self.waiEvaluateBtn.backgroundColor = [UIColor clearColor];
    self.historyBtn.backgroundColor = [UIColor clearColor];
    self.complainedOrdersBtn.backgroundColor = [UIColor clearColor];
    self.unfinishedBtn.selected = NO;
    self.waiEvaluateBtn.selected = NO;
    self.historyBtn.selected = NO;
    self.complainedOrdersBtn.selected = NO;
    
    button.backgroundColor = [UIColor blackColor];
    button.selected = YES;
}
#pragma mark - 按钮方法  ---这他妈也不是我写的方法,,我不敢改 因为没时间
// 未完成订单
- (IBAction)clickForUnfinishedOrder:(UIButton *)sender {
    if (self.unfinishedBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
}

// 待评价订单
- (IBAction)clickForWaitEvaluateOrder:(UIButton *)sender {
    if (self.waiEvaluateBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
}

// 已完成订单
- (IBAction)clickForHistoricOrder:(UIButton *)sender {
    if (self.historyBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
}

// 已投诉订单
- (IBAction)clickForComplainedOrder:(UIButton *)sender {
    
    if (self.complainedOrdersBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
}
// 设置按钮状态

// 取消订单
- (void)cancelOrder:(ParsingOrderDataModel *)order {
    self.cancelOrderId = order.orderId;
    [self.view addSubview:self.moreOperationView];
    
}

// 关闭更多操作页
- (IBAction)clickForCloseMoreOperation:(UIButton *)sender {
    [self.moreOperationView removeFromSuperview];
}

// 确认申请取消订单
- (IBAction)clickForSureCancelOrder:(UIButton *)sender {
    [self respondsToSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/cancelTrainTime", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"schoolId"] = kStoreId;
    URL_Dic[@"trainTimeId"] = self.cancelOrderId;
    __weak  MyOrderViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC respondsToSelector:@selector(delayMethod)];
        if ([resultStr isEqualToString:@"1"]) {
            [VC showAlert:responseObject[@"msg"] time:1.2];
            [VC requestData];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC respondsToSelector:@selector(delayMethod)];
        NSLog(@"error%@", error);
    }];

    [self.moreOperationView removeFromSuperview];
}


- (IBAction)backClick:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

// 投诉
- (void)complain:(ParsingOrderDataModel *)order {
    MyOrderComplainViewController *targetController = [[MyOrderComplainViewController alloc] initWithNibName:@"MyOrderComplainViewController" bundle:nil];
    targetController.orderid = order.orderId;
    [self.navigationController pushViewController:targetController animated:YES];
}
// 取消投诉
- (void)cancelComplain:(ParsingOrderDataModel *)order {
    
    
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *comments = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = comments.text.length >= 1;
    }
}
// 评价
- (void)eveluate:(ParsingOrderDataModel *)order {
    __weak  MyOrderViewController *VC = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"对订单进行评论" message:@"请填写" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.placeholder = @"评论";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *comments = alertController.textFields.firstObject;
        [VC performSelector:@selector(indeterminateExample)];
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/appraiseCoach", kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"appraise"] = comments.text;
        URL_Dic[@"id"] = order.orderId;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [VC showAlert:responseObject[@"msg"] time:1.2];
                [VC requestData];
            }else {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }
            [VC performSelector:@selector(delayMethod)];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC performSelector:@selector(delayMethod)];
            NSLog(@"error%@", error);
        }];

    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    okAction.enabled = NO;
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertController addAction:noAction];
    [alertController addAction:okAction];
    
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertController animated:YES completion:^{
        nil;
    }];
    
//    NSString *orderId = order.orderId;
//    MyOrderEvaluationViewController *targetController = [[MyOrderEvaluationViewController alloc] initWithNibName:@"MyOrderEvaluationViewController" bundle:nil];
//    targetController.orderid = orderId;
//    [self.navigationController pushViewController:targetController animated:YES];
//  //  [self showAlert:@"评论功能未开通" time:1.2];
}

@end
