//
//  MyOrderEvaluationViewController.m
//  guangda_student
//
//  Created by duanjycc on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "MyOrderEvaluationViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TQStarRatingView.h"
#import "LoginViewController.h"

@interface MyOrderEvaluationViewController () <UITextViewDelegate, StarRatingViewDelegate>
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UITextView *evaluationTextView;
@property (strong, nonatomic) IBOutlet UILabel *evaluationPlaceholderLabel;

@property (strong, nonatomic) TQStarRatingView *teachMannerStarView;
@property (strong, nonatomic) TQStarRatingView *teachQualityStarView;
@property (strong, nonatomic) TQStarRatingView *carQualityStarView;

@property (strong, nonatomic) NSDictionary *orderInfoDic;       // 订单信息



- (IBAction)clickForCommit:(id)sender;
@end


@implementation MyOrderEvaluationViewController
- (IBAction)return:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [self.mainScrollView contentSizeToFit];
    [super viewDidLoad];
    [self settingView];
    [self postGetOrderDetail];
}

#pragma mark - 页面设置
- (void)settingView {
    // 教学态度
    self.teachMannerStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(89, 0, 93, 17) numberOfStar:5];
    self.teachMannerStarView.couldClick = YES;
    self.teachMannerStarView.delegate = self;
    [self.teachMannerView addSubview:self.teachMannerStarView];
    [self.teachMannerStarView changeStarForegroundViewWithScore:4.0];
    _teachMannerScoreStr = [NSString stringWithFormat:@"%0.1f", 4.0];
    
    // 教学质量
    self.teachQualityStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(89, 0, 93, 17) numberOfStar:5];
    self.teachQualityStarView.couldClick = YES;
    self.teachQualityStarView.delegate = self;
    [self.teachQualityView addSubview:self.teachQualityStarView];
    [self.teachQualityStarView changeStarForegroundViewWithScore:4.0];
    _teachQualityScoreStr = [NSString stringWithFormat:@"%0.1f", 4.0];
    
    // 车容车貌
    self.carQualityStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(89, 0, 93, 17) numberOfStar:5];
    self.carQualityStarView.couldClick = YES;
    self.carQualityStarView.delegate = self;
    [self.carQualityView addSubview:self.carQualityStarView];
    [self.carQualityStarView changeStarForegroundViewWithScore:4.0];
    _carQualityScoreStr = [NSString stringWithFormat:@"%0.1f", 4.0];
    
    [self keyboardHiddenFun];
}

- (void)showData {
  
    //self.orderTimeLabel.text = [NSString stringWithFormat:@"%@ %@~%@", startDateStr, startTimeStr, endTimeStr];
    // 计算预约地址文字高度
   // CGFloat addrStrHeight =  [CommonUtil sizeWithString:self.order.detailAddr fontSize:13 sizewidth:_screenWidth - 105 sizeheight:MAXFLOAT].height;
   // self.orderAddrLabelHeightCon.constant = addrStrHeight;
}

#pragma mark - 网络请求
// test
- (void)printDic:(NSDictionary *)responseObject withTitle:(NSString *)title {
    NSLog(@"%@", [NSString stringWithFormat:@"**************%@**************", title]);
    NSLog(@"response ===== %@", responseObject);
    NSLog(@"code = %@",  responseObject[@"code"]);
    NSLog(@"message = %@", responseObject[@"message"]);
}

// 订单详细
- (void)postGetOrderDetail {
   
    
    
}

- (void) backLogin{
  
}

// 提交评价
- (void)postEvaluationTask {
    [self catchInputData];
   
    
}

#pragma mark - StarRatingViewDelegate
-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    if ([view isEqual:self.teachMannerStarView]) {
        _teachMannerScoreStr = [NSString stringWithFormat:@"%0.1f", score * 5];
        self.teachMannerScoreLabel.text = [NSString stringWithFormat:@"%@分", _teachMannerScoreStr];
    }
    if ([view isEqual:self.teachQualityStarView]) {
        _teachQualityScoreStr = [NSString stringWithFormat:@"%0.1f", score * 5];
        self.teachQualityScoreLabel.text = [NSString stringWithFormat:@"%@分", _teachQualityScoreStr];
    }
    if ([view isEqual:self.carQualityStarView]) {
        _carQualityScoreStr = [NSString stringWithFormat:@"%0.1f", score * 5];
        self.carQualityScoreLabel.text = [NSString stringWithFormat:@"%@分", _carQualityScoreStr];
    }
}

#pragma mark - Custom
// 点击背景退出键盘
- (void)keyboardHiddenFun {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backupgroupTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   // 只需要点击非文字输入区域就会响应
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}
-(void)backupgroupTap:(id)sender {
    [self.evaluationTextView resignFirstResponder];
}

// 模拟placeholder
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.evaluationPlaceholderLabel.hidden = NO;
    }else{
        self.evaluationPlaceholderLabel.hidden = YES;
    }
}

#pragma mark - 数据处理
// 取得输入数据
- (void)catchInputData {
}

- (void)loadData {

    
}

#pragma mark - 点击事件
- (IBAction)clickForCommit:(id)sender {
//    if ([CommonUtil isEmpty:self.evaluationTextView.text]) {
//        [self makeToast:@"请输入评论"];
//        return;
//    }
    [self postEvaluationTask];
}
@end
