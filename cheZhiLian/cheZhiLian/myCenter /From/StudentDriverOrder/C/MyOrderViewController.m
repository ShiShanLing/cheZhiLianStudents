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

#define CUSTOM_GREY RGB(60, 60, 60)
#define BORDER_WIDTH 0.7
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

@implementation MyOrderViewController {
    
   NSString *  orderState;
    
}

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
    
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        [self.mainTableView setupEmptyDataText:@"未登录" verticalOffset:0 emptyImage:[UIImage imageNamed:@"sdf"] buttonText:@"点击登录" tapBlock:^{
            
        }];
    }
    
    [self requestData];
}
-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    orderState = @"0";
    _rowHeight = 235;
    [self settingView];
}
#pragma mark 请求数据
- (void)requestData{
    //
    NSString *URL_Str = [NSString stringWithFormat:@"%@/train/api/listReservation", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
    
    URL_Dic[@"state"] = [NSString stringWithFormat:@"%ld", self.index];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak MyOrderViewController *VC = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.requestSerializer.timeoutInterval = 20;// 网络超时时长设置
    [manager POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSLog(@"responseObject%@",responseObject);
        NSString *resultStr =[NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
        [VC ParsingOrderData:responseObject[@"data"]];
        }else {
            [VC  showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC.mainTableView setupEmptyDataText:@"网络出错" verticalOffset:0 emptyImage:[UIImage imageNamed:@"sdf"] buttonText:@"点击刷新" tapBlock:^{
            
        }];
        [VC showAlert:@"网络出错!!" time:1.2];
    }];
}
- (void)ParsingOrderData:(NSArray *)dataArray {
    [self.orderArray removeAllObjects];
    if (dataArray.count == 0) {
        [self.mainTableView setupEmptyDataText:@"您还没有该类型订单" verticalOffset:0 emptyImage:[UIImage imageNamed:@"sdf"] buttonText:@"" tapBlock:^{
        }];
        //[self  showAlert:@"您还没有该类型订单" time:0.4];
        [self.mainTableView reloadData];
        return;
    }
    for (NSDictionary *dataDic in dataArray) {
        NSEntityDescription *des = [NSEntityDescription entityForName:@"StudentDriverOrderModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        StudentDriverOrderModel *orderListModel = [[StudentDriverOrderModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        for (NSString *key in dataDic) {
            //NSLog(@"订单列表%@",key);
            if ([key isEqualToString:@"orderTimes"]) {
                NSArray *timeListArr = dataDic[key];
                NSMutableArray *orderTimeListArr = [NSMutableArray array];
                for (NSDictionary *timeDic in timeListArr) {
                    NSEntityDescription *timeDes = [NSEntityDescription entityForName:@"OrderTimeModel" inManagedObjectContext:self.managedContext];
                    //根据描述 创建实体对象
                    OrderTimeModel *timeModel = [[OrderTimeModel alloc] initWithEntity:timeDes insertIntoManagedObjectContext:self.managedContext];
                    for (NSString *timeKey in timeDic) {
                        //NSLog(@"时间列表%@ %@",timeKey,timeDic[timeKey]);
                        [timeModel setValue:timeDic[timeKey] forKey:timeKey];
                    }
                    [orderTimeListArr addObject:timeModel];
                }
            [orderListModel setValue:orderTimeListArr forKey:key];
            }else {
                [orderListModel setValue:dataDic[key] forKey:key];
            }
        }
        [self.orderArray addObject:orderListModel];
    }
//    NSLog(@"ParsingOrderData%@", self.orderArray);
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    StudentDriverOrderModel *model = self.orderArray[section];
    NSArray *timeArray =(NSArray *)model.orderTimes;
    return timeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
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
    StudentDriverOrderModel *model = self.orderArray[indexPath.section];
    NSArray *timeArray =(NSArray *)model.orderTimes;
    cell.model = timeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StudentDriverOrderModel *model = self.orderArray[section];
    NSArray *timeArray =(NSArray *)model.orderTimes;
 //   NSLog(@"viewForHeaderInSection%@  self.orderArray%@", timeArray,self.orderArray);
    OrderTimeModel  *timeModel = timeArray[0];
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 40)];
    hView.backgroundColor = MColor(238, 238, 238);
    UIButton *imageBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [imageBtn setImage:[UIImage imageNamed:@"icon_calendar_orderlist"] forState:(UIControlStateNormal)];
    [hView addSubview:imageBtn];
    imageBtn.sd_layout.leftSpaceToView(hView, 0).topSpaceToView(hView, 0).bottomSpaceToView(hView, 0).widthIs(40);
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font =MFont(14);
    NSString *time = [CommonUtil getStringForDate:timeModel.startTime format:@"yyyy-MM-dd"];
    timeLabel.text = time;
    timeLabel.textColor = MColor(0, 213, 155);
    [hView addSubview:timeLabel];
    timeLabel.sd_layout.leftSpaceToView(imageBtn, 10).topSpaceToView(hView, 0).bottomSpaceToView(hView, 0).widthIs(100);
    
    UILabel *orderIdLabel = [[UILabel alloc] init];
    orderIdLabel.text = [NSString stringWithFormat:@"订单号%@", model.orderId];
    orderIdLabel.textAlignment = 2;
    orderIdLabel.font = MFont(14);
    orderIdLabel.textColor = MColor(0, 213, 155);
    [hView addSubview:orderIdLabel];
    orderIdLabel.sd_layout.rightSpaceToView(hView, 10).leftSpaceToView(timeLabel, 10).topSpaceToView(hView, 0).bottomSpaceToView(hView, 0);
    return hView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    StudentDriverOrderModel *model = self.orderArray[section];
    UIView *  fView = [[UIView alloc] init];
    fView.backgroundColor  = [UIColor whiteColor];
    DSButton *rightBtn = [DSButton buttonWithType:(UIButtonTypeSystem)];
    rightBtn.index = section;
    [fView addSubview:rightBtn];
    rightBtn.sd_layout.rightSpaceToView(fView , 14).topSpaceToView(fView, 15).bottomSpaceToView(fView, 15).widthIs(80);
    DSButton *leftBtn = [DSButton buttonWithType:(UIButtonTypeSystem)];
    leftBtn.index = section;
    [fView addSubview:leftBtn];
    leftBtn.sd_layout.rightSpaceToView(rightBtn , 14).topSpaceToView(fView, 15).bottomSpaceToView(fView, 15).widthIs(80);
    DSButton *CancelPromptBtn = [DSButton buttonWithType:(UIButtonTypeSystem)];
    CancelPromptBtn.index = section;
    CancelPromptBtn.font = [UIFont systemFontOfSize:13];
    [CancelPromptBtn setTitle:@"已提交取消申请,等待教练确认中." forState:(UIControlStateNormal)];
    CancelPromptBtn.titleLabel.textColor = [UIColor whiteColor];
    CancelPromptBtn.backgroundColor =MColor(255, 158, 134);
    [fView addSubview:CancelPromptBtn];
    CancelPromptBtn.sd_layout.leftSpaceToView(fView, 14).topSpaceToView(fView, 15).bottomSpaceToView(fView, 15).rightSpaceToView(rightBtn, 15);
    ////0:未完成,1:已完结,2:取消中,3:已取消,4:申诉中,5:已关闭)
    //订单状态state 订单状态(0:未完成,1:已完结,2:取消中,3:已拒绝,4:已取消,5:申诉中,6:已关闭)
    CancelPromptBtn.hidden = YES;
    switch (model.state) {
        case 0:
            //投诉和(取消)
            [self complainBtnConfig:leftBtn];
            [self  cancelOrderBtnConfig:rightBtn];
            break;
        case 1:
            if (model.commentState == 0) {
                leftBtn.hidden = YES;
                [self  eveluateBtnConfig:rightBtn];
                //投诉
            }else {
                leftBtn.hidden = YES;
                rightBtn.hidden = YES;
            }
            break;
        case 2:
            //取消中
            CancelPromptBtn.hidden = NO;
            leftBtn.hidden = YES;
            [self complainBtnConfig:rightBtn];
            break;
        case 3:
            //投诉
            leftBtn.hidden = YES;
            [self  complainBtnConfig:rightBtn];
            break;
        case 4:
            //取消投诉和
            leftBtn.hidden = YES;
            [self  cancelComplainBtnConfig:rightBtn];
            break;
        case 5:
            //关闭的订单
            leftBtn.hidden = YES;
            [self  eveluateBtnConfig:rightBtn];
            break;
        default:
            break;
    }
    return fView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    StudentDriverOrderModel *model = self.orderArray[section];
    CGFloat height = 0;
    switch (model.state) {
        case 0:
            height= 61;
            break;
        case 1:
            if (model.commentState == 0) {
                height= 61;
                //投诉
            }else {
                height= 0.01;
            }
            break;
        case 2:
            height= 61;
            break;
        case 3:
            height= 61;
            break;
        case 4:
            height= 61;
            break;
        case 5:
            height= 61;
            break;
        default:
            break;
    }
    return height;
}
#pragma mark - 按钮样式
// 取消订单按钮
- (void)cancelOrderBtnConfig:(DSButton *)btn {
    
    btn.layer.borderWidth = BORDER_WIDTH;
    btn.layer.borderColor = MColor(60, 60, 60).CGColor;
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = MColor(60, 60, 60);
    btn.hidden = NO;
    [btn setTitle:@"取消订单" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(cancelOrderClick:) forControlEvents:UIControlEventTouchUpInside];
}
// 投诉按钮
- (void)complainBtnConfig:(DSButton *)btn {
    btn.layer.borderWidth = BORDER_WIDTH;
    btn.layer.borderColor = MColor(60, 60, 60).CGColor;
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor whiteColor];
    btn.hidden = NO;
    [btn setTitle:@"投诉" forState:UIControlStateNormal];
    [btn setTitleColor:MColor(60, 60, 60) forState:UIControlStateNormal];
    [btn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(complainClick:) forControlEvents:UIControlEventTouchUpInside];

}
// 取消投诉按钮
- (void)cancelComplainBtnConfig:(DSButton *)btn {
    btn.layer.borderWidth = BORDER_WIDTH;
    btn.layer.borderColor = MColor(60, 60, 60).CGColor;
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor whiteColor];
    btn.hidden = NO;
    [btn setTitle:@"取消投诉" forState:UIControlStateNormal];
    [btn setTitleColor:MColor(60, 60, 60) forState:UIControlStateNormal];
    [btn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(cancelComplainClick:) forControlEvents:UIControlEventTouchUpInside];
}
// 评价按钮
- (void)eveluateBtnConfig:(DSButton *)btn {
    
    btn.layer.borderWidth = 0;
    btn.layer.borderColor = [[UIColor clearColor] CGColor];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = CUSTOM_GREEN;
    btn.hidden = NO;
    [btn setTitle:@"立即评价" forState:UIControlStateNormal];
    [btn setTitleColor:MColor(60, 60, 60) forState:UIControlStateNormal];
    [btn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(eveluateClick:) forControlEvents:UIControlEventTouchUpInside];
}
// 取消订单
- (void)cancelOrderClick:(DSButton *)btn {
    StudentDriverOrderModel *model = self.orderArray[btn.index];
    self.cancelOrderId = model.orderId;
    [self.view addSubview:self.moreOperationView];
}
// 投诉
- (void)complainClick:(DSButton *)btn {
    StudentDriverOrderModel *model = self.orderArray[btn.index];
    MyOrderComplainViewController *targetController = [[MyOrderComplainViewController alloc] initWithNibName:@"MyOrderComplainViewController" bundle:nil];
    targetController.type = @"1";
    targetController.orderModel = model;
    [self.navigationController pushViewController:targetController animated:YES];
    
}
// 取消投诉
- (void)cancelComplainClick:(DSButton *)btn {
    
    

}
// 评价
- (void)eveluateClick:(DSButton *)btn {
    StudentDriverOrderModel *model = self.orderArray[btn.index];
    MyOrderComplainViewController *targetController = [[MyOrderComplainViewController alloc] initWithNibName:@"MyOrderComplainViewController" bundle:nil];
    targetController.type = @"0";
    targetController.orderModel = model;
    [self.navigationController pushViewController:targetController animated:YES];
    
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
    [self requestData];
    orderState = @"0";
}

// 待评价订单
- (IBAction)clickForWaitEvaluateOrder:(UIButton *)sender {
    if (self.waiEvaluateBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
    [self requestData];
    orderState = @"1";
}

// 已完成订单
- (IBAction)clickForHistoricOrder:(UIButton *)sender {
    if (self.historyBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
    [self requestData];
    orderState = @"2";
}

// 已投诉订单
- (IBAction)clickForComplainedOrder:(UIButton *)sender {
    
    if (self.complainedOrdersBtn.selected == YES) return;
    self.targetOrderListType = OrderListTypeComplete;
    [self oneButtonSellected:sender];
    [self requestData];
    orderState = @"3";
}
// 设置按钮状态



// 关闭更多操作页
- (IBAction)clickForCloseMoreOperation:(UIButton *)sender {
    [self.moreOperationView removeFromSuperview];
}

// 确认申请取消订单
- (IBAction)clickForSureCancelOrder:(UIButton *)sender {
    [self respondsToSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/cancelTrainOrder", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"schoolId"] = kStoreId;
    URL_Dic[@"orderId"] = self.cancelOrderId;
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

// 取消投诉
- (void)cancelComplain:(OrderTimeModel *)order {
    
    
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
- (void)eveluate:(OrderTimeModel *)order {
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
         //   NSLog(@"responseObject%@", responseObject);
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
