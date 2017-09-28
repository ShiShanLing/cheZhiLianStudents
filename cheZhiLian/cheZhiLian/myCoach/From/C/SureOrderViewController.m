//
//  SureOrderViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "SureOrderViewController.h"
#import "SureOrderTableViewCell.h"
#import <CoreText/CoreText.h>


#define FOOTVIEW_HEIGHT 48
#define SELVIEW_HEIGHT 250

@interface SureOrderViewController ()<UITableViewDataSource, UITableViewDelegate> {
    int _validCouponNum; // 可用学时券总数
    int _validCoinNum; // 可用小巴币总数
    float _validMoney; // 余额总数
    int _remainderCouponNum; // 剩余学时券数
    int _remainderCoinNum; // 剩余学时币数
    float _remainderMoney; // 剩余余额
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *priceSumLabel;
/**
 *
 */

// 预约结果view
@property (strong, nonatomic) IBOutlet UIView *appointResultView;
@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;
@property (strong, nonatomic) IBOutlet UILabel *resultStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;//账户余额
@property (strong, nonatomic) IBOutlet UILabel *resultDetailsLabel;

@property (strong, nonatomic) IBOutlet UIButton *appointResultBtn;
@property (strong, nonatomic) IBOutlet UIView *resultContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resultStatusHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusImageHeight;

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) IBOutlet UILabel *tipTravel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipTravelTopMargin;
@property (strong, nonatomic) NSMutableArray *orderArray;//订单数组
@property (strong, nonatomic) NSMutableArray *couponArray;//小巴券列表
@property (assign, nonatomic) int delMoney;//小巴券抵掉的钱

@property (strong, nonatomic) IBOutlet UILabel *couponCountLabel;

@property (assign, nonatomic) int canUseDiffCoupon;
@property (assign, nonatomic) int canUsedMaxCouponCount;

@property (weak, nonatomic) IBOutlet UIButton *goAppointBtn;


// 选择支付方式
@property (strong, nonatomic) IBOutlet UIView *payTypeSelectView;
@property (weak, nonatomic) IBOutlet UIControl *coverView;
@property (strong, nonatomic) UIButton *coverBgBtn;
@property (weak, nonatomic) IBOutlet UILabel *remainCouponLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;


@property (weak, nonatomic) IBOutlet UIButton *couponSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *coinSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneySelectBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;

// 页面数据
@property (strong, nonatomic) NSMutableArray *bookOrdersArray;  // 预约订单数组

@property (assign, nonatomic) BOOL moneyIsDeficit;              // 余额是否不足

@end

@implementation SureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.carModelID isEqualToString:@"19"] && self.needCar) {
       
    }
    else {
       
    }
    self.priceSumLabel.text = [NSString stringWithFormat:@"应付金额%@元", self.priceSum];
    
    self.orderArray = [NSMutableArray array];
    _couponArray = [NSMutableArray array];
    _delMoney = 0;
    self.payMoney = [self.priceSum floatValue];
    self.couponCountLabel.text = @"您是交全款的用户所以不用付钱";
    
    self.canUseDiffCoupon = 0;
    self.canUsedMaxCouponCount = 1;
    
    [self goAppointBtnConfig];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 44)];
    label.numberOfLines = 0;
    label.text = @"请事先与教练确认练车地址和交通方式";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = [CommonUtil sizeWithString:label.text fontSize:16 sizewidth:kScreen_widht sizeheight:CGFLOAT_MAX];
    view.frame = CGRectMake(0, 0, kScreen_widht, size.height + 20);
    label.frame = CGRectMake(10, 0, kScreen_widht - 20, size.height + 20);
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    self.payTypeSelectView.frame = CGRectMake(0, kScreen_heigth, kScreen_widht, SELVIEW_HEIGHT);
    [self.view addSubview:self.payTypeSelectView];
    
    self.coverBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverBgBtn.frame = CGRectMake(0, 0, kScreen_widht, kScreen_heigth);
    self.coverBgBtn.backgroundColor = [UIColor blackColor];
    self.coverBgBtn.alpha = 0;
    [self.coverBgBtn addTarget:self action:@selector(clickForHideSelectionView:) forControlEvents:UIControlEventTouchUpInside];
}

//刷新余额
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 获取可以使用的小巴券、小巴币数目、账户余额并配置界面
}

// 选择单个支付按钮状态
- (void)selectButton:(UIButton *)button {
    self.couponSelectBtn.selected = NO;
    self.coinSelectBtn.selected = NO;
    self.moneySelectBtn.selected = NO;
    button.selected = YES;
}
// 混合支付按钮状态
- (void)selectMixButton {
    self.couponSelectBtn.selected = NO;
    self.coinSelectBtn.selected = YES;
    self.moneySelectBtn.selected = YES;
}
// 设置支付方式选择按钮为不可选
- (void)invalidSelectBtn:(UIButton *)button {
    [button setImage:[UIImage imageNamed:@"coupon_invalid"] forState:UIControlStateNormal];
    button.enabled = NO;
}

// 设置支付方式选择按钮为可选
- (void)validSelectBtn:(UIButton *)button {
    [button setImage:[UIImage imageNamed:@"coupon_unselected"] forState:UIControlStateNormal];
    button.enabled = YES;
}
// 设置确认支付按钮状态
- (void)goAppointBtnConfig {
    
        [self.goAppointBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [self.goAppointBtn setBackgroundImage:[UIImage imageNamed:@"sure_appoint_red"] forState:UIControlStateNormal];
        [self.goAppointBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.goAppointBtn addTarget:self action:@selector(payDetailStatistics) forControlEvents:UIControlEventTouchUpInside];
}

- (void) backLogin{
    
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 37)];
    
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 8)];
    smallView.backgroundColor = MColor(246, 246, 246);
    [view addSubview:smallView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreen_widht, 1)];
    line.backgroundColor = MColor(219, 220, 223);
    [view addSubview:line];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(75, 8, kScreen_widht-150, 25)];
    titleView.backgroundColor = MColor(80, 203, 140);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleView.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    [view addSubview:titleView];
    CoachTimeListModel *model;
    if (self.dateTimeSelectedList.count != 0) {
        model = self.dateTimeSelectedList[section];
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: model.startTime];
    NSString *date = currentDateStr;
    
    UILabel *label = [[UILabel alloc] initWithFrame:titleView.bounds];
    label.text = date;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FOOTVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // 取得数据
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, FOOTVIEW_HEIGHT)];
//    view.backgroundColor = RGB(246, 246, 246);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    [view addSubview:leftLabel];
    CGFloat leftLabelW = 100;
    CGFloat leftLabelH = 16;
    CGFloat leftLabelX = 18;
    CGFloat leftLabelY = (FOOTVIEW_HEIGHT - leftLabelH)/2;
    leftLabel.frame = CGRectMake(leftLabelX, leftLabelY, leftLabelW, leftLabelH);
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = [UIColor blackColor];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.text = @"选择支付方式";
    
    UIView *bottomLine = [[UIView alloc] init];
    [view addSubview:bottomLine];
    CGFloat bottomLineW = kScreen_widht;
    CGFloat bottomLineH = 1;
    CGFloat bottomLineX = 0;
    CGFloat bottomLineY = FOOTVIEW_HEIGHT - 1;
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    bottomLine.backgroundColor = MColor(219, 220, 223);
    
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    [view addSubview:arrowIcon];
    CGFloat arrowIconW = 7;
    CGFloat arrowIconH = 12;
    CGFloat arrowIconX = kScreen_widht - arrowIconW -18;
    CGFloat arrowIconY = (FOOTVIEW_HEIGHT - arrowIconH)/2;
    arrowIcon.frame = CGRectMake(arrowIconX, arrowIconY, arrowIconW, arrowIconH);
    arrowIcon.backgroundColor = [UIColor clearColor];
    [arrowIcon setImage:[UIImage imageNamed:@"arrow_userinfohome"]];
    
    UILabel *payTypeLabel = [[UILabel alloc] init];
    [view addSubview:payTypeLabel];
    CGFloat payTypeLabelW = 170;
    CGFloat payTypeLabelH = leftLabelH;
    CGFloat payTypeLabelX = arrowIconX - payTypeLabelW - 8;
    CGFloat payTypeLabelY = leftLabelY;
    payTypeLabel.frame = CGRectMake(payTypeLabelX, payTypeLabelY, payTypeLabelW, payTypeLabelH);
    payTypeLabel.backgroundColor = [UIColor clearColor];
    payTypeLabel.font = [UIFont systemFontOfSize:14];
    payTypeLabel.textColor = [UIColor blackColor];
    payTypeLabel.textAlignment = NSTextAlignmentRight;
    
        payTypeLabel.text = @"账户余额";
   
        payTypeLabel.text = [NSString stringWithFormat:@"余额支付%.2f元", _remainderMoney];
   
    
    // 选择支付方式
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:selectBtn];
    selectBtn.frame = view.bounds;
    selectBtn.backgroundColor = [UIColor clearColor];
    selectBtn.tag = section;
    [selectBtn addTarget:self action:@selector(clickForSelectionView:) forControlEvents:UIControlEventTouchUpInside];

    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dateTimeSelectedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"SureOrderTableViewCell";
    SureOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SureOrderTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dateTimeSelectedList[indexPath.row];
    cell.leftLength.constant = 0;
    cell.rightLength.constant = 0;
    return cell;
}


- (IBAction)orderDetailClick:(id)sender
{
    if (self.orderId) {
       
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// 充值
- (void)rechargeClick:(id)sender {
    [self.appointResultView removeFromSuperview];
    
}

- (IBAction)removeResultClick:(id)sender {
    [self.appointResultView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 选择支付方式
- (IBAction)choosePayType:(UIButton *)sender {

    
    
    
    

}

// 弹出选择支付方式view
- (void)clickForSelectionView:(UIButton*)sender {
    // 根据订单配置view
    [self payTypeSelectViewConfig];
    [self.view addSubview:self.coverBgBtn];
    [self.view addSubview:self.payTypeSelectView];
    [UIView animateWithDuration:0.35 animations:^{
        self.coverBgBtn.alpha = 0.7;
        self.payTypeSelectView.frame = CGRectMake(0, (kScreen_heigth - SELVIEW_HEIGHT), kScreen_widht, SELVIEW_HEIGHT);
    }];
}
#pragma mark - 配置支付方式选择view
- (void)payTypeSelectViewConfig {
    
    
    
    [self selectButton:self.moneySelectBtn];
    _remainderMoney = 1800;
    
    [self allSelectBtnConfig];
    [self remainWealthShow];
}
// 配置所有选择按钮的状态
- (void)allSelectBtnConfig{
    
    if (_remainderCoinNum ==0 && self.coinSelectBtn.selected == NO) { // 已无小巴币
        [self invalidSelectBtn:self.coinSelectBtn];
    } else {
        [self validSelectBtn:self.coinSelectBtn];
    }
}
// 显示可用的剩余财富
- (void)remainWealthShow {
    self.remainCouponLabel.text = [NSString stringWithFormat:@"%d张可用", _remainderCouponNum];
    
    //取消混合支付
    //    if (bookOrder.payType == payTypeCoin) {
    if (_remainderCoinNum >= 1) {
        self.remainCoinLabel.text = [NSString stringWithFormat:@"%d个可用", _remainderCoinNum];

    } else {
        self.remainCoinLabel.text = [NSString stringWithFormat:@"小巴币不足"];
        [self invalidSelectBtn:self.coinSelectBtn];
    }
    NSString *remainMoneyStr = nil;
    if (_remainderMoney >= 0) { // 余额足够支付
        remainMoneyStr =  [NSString stringWithFormat:@"%d元可用", (int)_remainderMoney];
    } else { // 余额不足
        remainMoneyStr = [NSString stringWithFormat:@"余额不足，需充值"];
    }
    self.remainMoneyLabel.text = remainMoneyStr;
}
// 确认并隐藏选择支付方式view
- (IBAction)clickForHideSelectionView:(id)sender {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.coverBgBtn.alpha = 0;
        self.payTypeSelectView.frame = CGRectMake(0, kScreen_heigth, kScreen_widht, SELVIEW_HEIGHT);
    }completion:^(BOOL finished) {
        [self.coverBgBtn removeFromSuperview];
        [self.payTypeSelectView removeFromSuperview];
    }];
    
    [self.tableView reloadData];
    [self payDetailStatistics];
    
}

- (void)payDetailStatistics {

http://192.168.100.101:8080/com-zerosoft-boot-assembly-seller-local-1.0.0-SNAPSHOT/train/api/makeReservation?coachId=ef6334ff740a4d2e934b895d8a9b62dc&endTime=1504753200000&price=180&startTime=1504749600000&studentId=2543216315314435bfa72e61aa55faa3
    
     for (int i = 0; i  < self.dateTimeSelectedList.count; i ++) {
        CoachTimeListModel *model = self.dateTimeSelectedList[i];
        NSString *URL_Str = [NSString stringWithFormat:@"%@/train/api/makeReservation", kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"coachId"]=[UserDataSingleton mainSingleton].coachId;
        URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
        NSString *startTimeSp = [NSString stringWithFormat:@"%ld%@", (long)[model.startTime timeIntervalSince1970], @"000"];
        URL_Dic[@"startTime"] = startTimeSp;
        //NSDate 转 时间戳
        NSString *endTimeSp = [NSString stringWithFormat:@"%ld%@", (long)[model.endTime timeIntervalSince1970], @"000"];
        URL_Dic[@"endTime"] = endTimeSp;
        URL_Dic[@"price"] = [NSString stringWithFormat:@"%.0f", model.unitPrice];
        NSLog(@"URL_Dic%@", URL_Dic);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __weak SureOrderViewController *VC = self;
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [VC showAlert:responseObject[@"msg"] time:1.2];
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [VC.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@", error);
        }];
    }
 

}
@end
