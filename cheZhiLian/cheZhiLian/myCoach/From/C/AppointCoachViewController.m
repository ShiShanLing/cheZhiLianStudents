//
//  AppointCoachViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/23.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AppointCoachViewController.h"
#import <CoreText/CoreText.h>
#import "TQStarRatingView.h"
#import "SwipeView.h"
#import "AppDelegate.h"
#import "TimeChooseTableViewCell.h"
#import "SureOrderViewController.h"
#import "CoachTimeListModel+CoreDataProperties.h"

static  BOOL EditTime;

@interface AppointCoachViewController () <SwipeViewDelegate, SwipeViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, TimeChooseTableViewCellDelegate>
{
    float _priceSum;   // 总价
    int _timeNum;    // 时间点的数量
    bool _pageIndex;        // 切换用页(这个页面实际只有两个childViewController，index为0和1，故用此bool值来做index)
    NSUInteger _curPageNum; // 当前页
    NSDate   *currentTime;//如果是空的或者 是当天就不让操作
}

@property (weak, nonatomic) IBOutlet UIView *TimeChooseView;
@property (strong, nonatomic) IBOutlet UIScrollView *coachTimeScrollView;
@property (strong, nonatomic) IBOutlet UIButton *sureAppointBtn;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;//
@property (strong, nonatomic) IBOutlet UILabel *coachRealName;
@property (strong, nonatomic) IBOutlet UILabel *carAddress;
@property (strong, nonatomic) IBOutlet UIView *coachDetailsTopView; // 教练信息顶部view
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindTapRightSpaceCon; // 提醒教练开课按钮约束
// 陪驾是否需要用教练车
@property (strong, nonatomic) IBOutlet UIView *ifNeedCarMaskView;
@property (weak, nonatomic) IBOutlet UIView *ifNeedCarView;
@property (weak, nonatomic) IBOutlet UIButton *noNeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *needBtn;
@property (weak, nonatomic) IBOutlet UILabel *carCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *ifNeedCarSureBtn;
@property (assign, nonatomic) BOOL needCar; // 是否需要教练车
@property (assign, nonatomic) int rentalFeePerHour; // 教练车租赁费(每小时)

@property (strong, nonatomic) UIView *coachTimeContentView;
//@property (strong, nonatomic) NSMutableArray *timeMutableList;      // 时间点数据数组 用于存储各个时间点的数据 单价、科目、时间
// 你还未选择任何时间 label
@property (strong, nonatomic) IBOutlet UILabel *noTimeSelectedLabel;
// 小时数和价格label 的 view
@property (strong, nonatomic) IBOutlet UIView *timePriceView;
// 已选择的小时数量
@property (strong, nonatomic) IBOutlet UILabel *timeNumLabel;
// 总价格label
@property (strong, nonatomic) IBOutlet UILabel *priceSumLabel;
// 当前选中的日期
@property (strong, nonatomic) NSString *nowSelectedDate;
// 上方用来选择的日期的label的list
 @property (strong, nonatomic) NSMutableArray *selectDateList;
// 接口返回的dateList
@property (strong, nonatomic) NSArray *dateList;
@property (strong, nonatomic) NSMutableArray *dateLabelList;
@property (nonatomic, strong)NSMutableArray *coachTimeArray;
@property (nonatomic, strong)UITableView *tableView;
/**
 *分割好的时间数组
 */
@property (nonatomic, strong)NSMutableArray *dateArray;
@end

@implementation AppointCoachViewController
- (NSMutableArray *)coachTimeArray {
    if (!_coachTimeArray) {
        _coachTimeArray = [NSMutableArray array];
    }
    return _coachTimeArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray arrayWithArray:@[@[].mutableCopy, @[].mutableCopy, @[].mutableCopy]];
    }
    return _dateArray;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 350) style:(UITableViewStylePlain)];
        [_tableView registerClass:[TimeChooseTableViewCell class] forCellReuseIdentifier:@"TimeChooseTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData:currentTime];
    // 请求刷新教练日程接口
    if (!self.nowSelectedDate) {
        self.nowSelectedDate = [CommonUtil getStringForDate:[NSDate date] format:@"yyyy-MM-dd"];
    }
    [self noCarNeedClick:self.noNeedBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectDateList = [NSMutableArray array];
    self.dateLabelList = [NSMutableArray array];
    self.sureAppointBtn.enabled = NO;
    self.noTimeSelectedLabel.hidden = NO;
    self.timePriceView.hidden = YES;
    self.priceSumLabel.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPriceNumStatus) name:@"appointCoachSuccess" object:nil];
    [self viewConfig];
    [self createTableView];
    _TimeChooseView.backgroundColor = [UIColor redColor];
    NSLog(@"_TimeChooseView.height%f  _tableView.height%f", _TimeChooseView.height, _tableView.height);
}

- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

#pragma mark 请求数据
- (void)requestData:(NSDate *)date {
    NSDate *nowDate;
    NSLog(@"currentTime%@  [NSDate date] %@", currentTime, [NSDate date] );
    if (date ==nil || [self isSameDay:currentTime date2:[NSDate date] ]) {
        nowDate = [NSDate date];
        currentTime = nowDate;
        EditTime = NO;
    }else {
        nowDate = date;
        EditTime = YES;
    }
    NSTimeInterval timeIn = [nowDate timeIntervalSince1970];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeIn];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *newTime = [NSString stringWithFormat:@"%@ 00:00:00", [dateFormatter stringFromDate:detaildate]];
    
    NSString *SJCStr = [NSString stringWithFormat:@"%.0f000", [[CommonUtil getDateForString:newTime format:nil] timeIntervalSince1970]];
    //NSLog(@"最终转为字符串时间1 = %@  SJCStr%@", newTime, SJCStr);
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/train/api/coachReserveTime", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    
    if ([UserDataSingleton mainSingleton].coachId.length == 0) {
        
    }else {
        [URL_Dic setObject:[UserDataSingleton mainSingleton].coachId forKey:@"coachId"];
    }
    [URL_Dic setValue:SJCStr forKey:@"dateMillis"];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak AppointCoachViewController *VC = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   // manager.requestSerializer.timeoutInterval = 20;// 网络超时时长设置
    [manager POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@",responseObject);
        NSString *resultStr  = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
                [VC parsingCoachTimeData:responseObject];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"网络出错!!" time:1.0];
    }];
}

- (void)parsingCoachTimeData:(NSDictionary *)dic {
    [self.coachTimeArray removeAllObjects];
    NSArray *tempArray = dic[@"data"];
    NSDictionary *tempDic = tempArray[0];
    NSArray *dateArray = tempDic[@"result"];
    [self managedContext];
    //创建实体描述对象
    for (NSDictionary *dateDic in dateArray) {
        NSEntityDescription *des = [NSEntityDescription entityForName:@"CoachTimeListModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        CoachTimeListModel *CTLModel = [[CoachTimeListModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        [CTLModel setValue:tempDic[@"unitPrice"] forKey:@"unitPrice"];
        for (NSString *key in dateDic) {
            [CTLModel setValue:dateDic[key] forKey:key];
        }
        [self.coachTimeArray addObject:CTLModel];
    }
    [self TimeDivision];
}
//时间分割
- (void)TimeDivision {
    [self.dateArray[0] removeAllObjects];
    [self.dateArray[1] removeAllObjects];
    [self.dateArray[2] removeAllObjects];
    for (CoachTimeListModel *model in self.coachTimeArray) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH"];
        NSString *currentDateStr = [dateFormatter stringFromDate: model.endTime];
        int temeHH = currentDateStr.intValue;
        if (temeHH <=12) {
            [dateFormatter setDateFormat:@"HH:mm"];
            model.timeStr = [dateFormatter stringFromDate: model.startTime];
            model.periodStr = @"上午";
            [self.dateArray[0] addObject:model];
        }else if (temeHH <=18) {
            [dateFormatter setDateFormat:@"HH:mm"];
            model.timeStr = [dateFormatter stringFromDate: model.startTime];
            model.periodStr = @"下午";
            [self.dateArray[1] addObject:model];
        }else {
            [dateFormatter setDateFormat:@"HH:mm"];
            model.timeStr = [dateFormatter stringFromDate: model.startTime];
            model.periodStr = @"晚上";
            [self.dateArray[2] addObject:model];
        }
    }
    [self.tableView reloadData];
  //  NSLog(@"TimeDivision%@", self.dateArray);
}
//创建tableView
- (void)createTableView {
    [self.TimeChooseView addSubview:self.tableView];
    self.tableView.sd_layout.leftSpaceToView(self.TimeChooseView, 0).topSpaceToView(self.TimeChooseView, 0).rightSpaceToView(self.TimeChooseView, 0).bottomSpaceToView(self.TimeChooseView, 0);
    // 左扫手势
    UISwipeGestureRecognizer *swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //    [swipeLeftGR setCancelsTouchesInView:YES];
    [swipeLeftGR setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:swipeLeftGR];
    
    // 右扫手势
    UISwipeGestureRecognizer *swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //    [swipeRightGR setCancelsTouchesInView:YES];
    [swipeRightGR setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipeRightGR];

}
#pragma mark - 页面配置
- (void)viewConfig {
   
    [self.phoneBtn setTitle:@"13646712075" forState:UIControlStateNormal];
    
    // 教练综合评分
    TQStarRatingView *starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(10, 27, 88, 15)];
    [starView changeStarForegroundViewWithScore:5.0];
    [self.coachDetailsTopView addSubview:starView];
    
    //configure swipe view
    _swipeView.height = kFit(40);
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled = YES;
    _swipeView.wrapEnabled = NO;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    self.ifNeedCarMaskView.frame = [UIScreen mainScreen].bounds;
    self.ifNeedCarView.layer.cornerRadius = 3;
    self.ifNeedCarSureBtn.layer.cornerRadius = 3;
}
// 重新计算总价
- (void)resetPriceNumStatus {
    
    CGFloat unitPrice = 0.0;
    NSMutableArray *selectedTimeArray = [NSMutableArray array];
    for (NSArray *modelArray in self.dateArray) {
        for (CoachTimeListModel *model in modelArray) {
            if (model.state == 4) {
                unitPrice = model.unitPrice;
                [selectedTimeArray addObject:model];
            }
        }
    }
    // 控制各控件的显示/隐藏
    if (unitPrice > 0 ) {
        self.timeNumLabel.text = [NSString stringWithFormat:@"已选择%lu个小时", (unsigned long)selectedTimeArray.count];
        self.priceSumLabel.text = [NSString stringWithFormat:@"合计%.2f元", unitPrice];
        self.timePriceView.hidden = NO;
        self.noTimeSelectedLabel.hidden = YES;
        self.sureAppointBtn.enabled = YES;
        self.priceSumLabel.hidden = NO;
        
    }else{
        self.timePriceView.hidden = YES;
        self.noTimeSelectedLabel.hidden = NO;
        self.sureAppointBtn.enabled = NO;
        self.priceSumLabel.hidden = YES;
    }
}

// 提醒教练开课标签设置
- (void)remindTapConfig:(NSDictionary *)dict {
    // 教练状态 0:未开课 1:已开课
    int coachState = 1;
    // 提醒状态 1:已提醒过  0:未提醒
    int remindState = 0;
    // 非陪驾课表
    if (![self.carModelID isEqualToString:@"19"]) {
        
        if (coachState == 0 && remindState == 0) { // 提醒教练开课按钮显示
            [self remindTapShow];
        } else {
            [self remindTapHide];
        }
    }
}

- (void)remindTapShow {
    [UIView animateWithDuration:0.25 animations:^{
        self.remindTapRightSpaceCon.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)remindTapHide {
    [UIView animateWithDuration:0.25 animations:^{
        self.remindTapRightSpaceCon.constant = -117;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 添加横向滚动的时间选栏
- (UIView *)getTimeForSelected {
    NSDate *nowDate = [NSDate date];
//    NSString *nowDateStr = [CommonUtil getStringForDate:nowDate format:@"yyyy\nMM/dd"];
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 73*30, 40)];
    
    CGFloat _x = 0;
    for (int i = 0; i < 30; i++) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(_x, 0, 73, 40)];
        [dateView addSubview:contentView];
        
        NSString *newDateStr = [CommonUtil getStringForDate:nowDate format:@"yyyy\nMM/dd"];
        NSMutableAttributedString *attributeDateStr = [[NSMutableAttributedString alloc] initWithString:newDateStr];
        [attributeDateStr addAttribute:NSForegroundColorAttributeName value:MColor(168, 170, 179) range:NSMakeRange(0, 4)];
        [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
        [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, 6)];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 73, 40)];
        dateLabel.numberOfLines = 2;
        dateLabel.attributedText = attributeDateStr;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:dateLabel];
        [self.selectDateList addObject:dateLabel];
        
        nowDate = [[NSDate date] initWithTimeInterval:24*60*60 sinceDate:nowDate];
        _x += 73;
    }
    
    return dateView;
}

#pragma mark - Custom
- (void) backLogin {
   
}

// 左右扫动手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGR {
    //一是改变日期选择  而是改变教练的时间状态
    [self swipeView:self.swipeView didSelectItemAtIndex:_curPageNum];
}

#pragma mark - UISwipeViewDelegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return 7;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view)
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"SwipTimeView" owner:self options:nil] lastObject];
    }
    
    UILabel *label = (UILabel *)[view.subviews lastObject];
    NSDate *date = [[NSDate date] initWithTimeInterval:24*60*60*index sinceDate:[NSDate date]];
    NSString *dateStr = [CommonUtil getStringForDate:date format:@"yyyy\nMM/dd"];
    NSMutableAttributedString *attributeDateStr = [[NSMutableAttributedString alloc] initWithString:dateStr];
    [attributeDateStr addAttribute:NSForegroundColorAttributeName value:MColor(168, 170, 179) range:NSMakeRange(0, 4)];
    [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
    if (index == swipeView.currentPage) {
        [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(4, 6)];
    }else{
        [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, 6)];
    }
    
    label.attributedText = attributeDateStr;
    label.tag = index;
    [self.dateLabelList addObject:label];
    
    return view;
}
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    swipeView.currentPage = index;
    _curPageNum = index;
    NSDate *date = [[NSDate date] initWithTimeInterval:24*60*60*index sinceDate:[NSDate date]];
    currentTime =date;
    [self requestData:date];
    
    NSString *dateStr = [CommonUtil getStringForDate:date format:@"yyyy-MM-dd"];
    self.nowSelectedDate = dateStr;
    [self setDateLabelFont:index];
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView {
    int index = (int)swipeView.currentPage;
    _curPageNum = index;
    NSDate *date = [[NSDate date] initWithTimeInterval:24*60*60*index sinceDate:[NSDate date]];
    currentTime =date;
    [self requestData:date];
    NSString *dateStr = [CommonUtil getStringForDate:date format:@"yyyy-MM-dd"];
    self.nowSelectedDate = dateStr;
    [self setDateLabelFont:index];
}
// 改变相应日期的字体
- (void)setDateLabelFont:(NSInteger)index {
    
    for (UILabel *label in self.dateLabelList) {
        
        NSDate *date = [[NSDate date] initWithTimeInterval:24*60*60*label.tag sinceDate:[NSDate date]];
        
        NSString *dateStr = [CommonUtil getStringForDate:date format:@"yyyy\nMM/dd"];
        NSMutableAttributedString *attributeDateStr = [[NSMutableAttributedString alloc] initWithString:dateStr];
        [attributeDateStr addAttribute:NSForegroundColorAttributeName value:MColor(168, 170, 179) range:NSMakeRange(0, 4)];
        [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
        if (label.tag == index) {
            [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(4, 6)];
        }else{
            [attributeDateStr addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, 6)];
        }
        label.attributedText = attributeDateStr;
    }
}
#pragma mark - actions
- (IBAction)dismissViewControlClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 去支付
- (IBAction)sureAppointClick:(id)sender {
    
    CGFloat unitPrice = 0.0;
    NSMutableArray *selectedTimeArray = [NSMutableArray array];
    for (NSArray *modelArray in self.dateArray) {
        for (CoachTimeListModel *model in modelArray) {
            if (model.state == 4) {
                unitPrice = model.unitPrice;
                [selectedTimeArray addObject:model];
            }
        }
    }
    
    SureOrderViewController *VC= [[SureOrderViewController alloc] init];
    
    VC.dateTimeSelectedList = selectedTimeArray;
    VC.priceSum = [NSString stringWithFormat:@"%.2f", selectedTimeArray.count * unitPrice];
    VC.payMoney =  selectedTimeArray.count * unitPrice;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 资料不完善，前去完善
    if (buttonIndex == 1) {
    
    }
}

- (IBAction)phoneCallClick:(id)sender {
    NSString *phoneNum = [NSString stringWithFormat:@"telprompt:%@", @"13646712075"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}
// 提醒教练开课
- (IBAction)remindCoachClick:(id)sender {
    
    
    
}
// 选择不需要教练车
- (IBAction)noCarNeedClick:(UIButton *)sender {
    if (sender.selected) return;
    self.noNeedBtn.selected = YES;
    self.needBtn.selected = NO;
    self.needCar = NO;
}
// 选择需要教练车
- (IBAction)needCarClick:(UIButton *)sender {
    if (sender.selected) return;
    self.needBtn.selected = YES;
    self.noNeedBtn.selected = NO;
    self.needCar = YES;
}
// 确定是否需要教练车
- (IBAction)ifNeedCarSureClick:(id)sender {
    
}

- (IBAction)closeIfNeedCarViewClick:(id)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeChooseTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataArray = _dateArray[indexPath.section];
    cell.cellSection = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
//时间点击时间
- (void)ClickIndex:(NSIndexPath *)indexPath {
    if (!EditTime) {
        [self showAlert:@"不能预约当天时间!" time:1.2];
        return;
    }
    NSMutableArray *tempArray = self.dateArray[indexPath.section];
    CoachTimeListModel *model = tempArray[indexPath.row];
        if (model.openCourse == 0) {//如果没有开课
        }else if(model.openCourse == 1){//如果开课了
                if (model.state == 0 ) {//如果没有被预约
                    model.state = 4;
                }else if(model.state == 4) {
                    model.state = 0;
                }
        }
    NSLog(@"self.dateArray%@", self.dateArray);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appointCoachSuccess" object:nil];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempArray = self.dateArray[indexPath.section];
    int number = tempArray.count;
    
    //排数 = number/4 + number%4?1:0
    //cell的高度  =  82.5 * 排数 + (排数 - 1) * 5
    
    if (number == 0) {
        return 0;
    }else if (number <=4){
        return kFit(82.5) + kFit(5);
    }else {
        int row = (number/4) + (number%4?1:0);
        return row *kFit(82.5)+(row-1)*kFit(5);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25;
    }else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 30)];
        view.backgroundColor = MColor(255, 255, 255);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 30)];
        titleLabel.textAlignment = 1;
        titleLabel.textColor =  MColor(203, 203, 203);
        titleLabel.text = @"您预约的时间是指.预约后的一个小时";
        titleLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:titleLabel];
        return view;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 30)];
        view.backgroundColor = MColor(255, 255, 255);
        return view;
    }
    
}

@end
