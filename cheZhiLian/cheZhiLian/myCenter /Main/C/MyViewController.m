//
//  MyViewController.m
//  guangda
//
//  Created by Dino on 15/3/17.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "CZPhotoPickerController.h"
#import "TQStarRatingView.h"
#import "LoginViewController.h"
#import "MyOrderViewController.h"
#import "EnrollDetailsVC.h"
#import "UserInfoHomeViewController.h"
#import "CoinListViewController.h"
#import "CouponListViewController.h"
@interface MyViewController () <UITextFieldDelegate, UIScrollViewDelegate> {
    CGRect _oldFrame1;
    CGRect _oldFrame2;
    NSString *updatePrice;
    NSString *getPrice;//取现金额
}
@property (strong, nonatomic) CZPhotoPickerController *pickPhotoController;
@property (strong, nonatomic) IBOutlet UIView *checkView;           // 验证教练资格视图
@property (strong, nonatomic) IBOutlet UIView *getMoneyView;        // 申请金额视图
@property (strong, nonatomic) IBOutlet UIView *commitView;          // 提交申请
@property (strong, nonatomic) IBOutlet UIView *successAlertView;    // 提交成功提示
/**
 *申请状态提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *applyStateLabel;

@property (strong, nonatomic) IBOutlet UIView *priceAndAddrView;    // 选择设置价格&上车地址&教学内容
@property (strong, nonatomic) IBOutlet UIView *priceAndAddrBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *priceWidthConstraint;//价格宽度约束

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITextField *moneyYuanField; // 取钱

//头像
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;//通过审核页面的头像
@property (strong, nonatomic) IBOutlet UIImageView *checkLogoImageView;//未通过审核的头像
@property (strong, nonatomic) IBOutlet UILabel *checkNameLabel;

//余额
@property (strong, nonatomic) IBOutlet UIButton *moneyBtn;//余额
@property (strong, nonatomic) IBOutlet UILabel *cashLabel;          // 保证金及冻结金额
@property (strong, nonatomic) IBOutlet UILabel *xiaobaTicketLabel;//小巴券
@property (strong, nonatomic) IBOutlet UIButton *convertButton;
@property (strong, nonatomic) IBOutlet UILabel *xiaobaCoinLabel;//小巴币
@property (strong, nonatomic) IBOutlet UIButton *coinConvertButton;
@property (strong, nonatomic) IBOutlet UIView *alertPhotoView;//弹框
@property (strong, nonatomic) IBOutlet UIView *alertDetailView;
//取钱弹框
@property (strong, nonatomic) IBOutlet UILabel *alertMoneyLabel;//余额
@property (strong, nonatomic) IBOutlet UILabel *moneyDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *rechargeView; //充值
@property (strong, nonatomic) IBOutlet UITextField *rechargeYuanTextField;
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;

//参数
@property (strong, nonatomic) UIImage *changeLogoImage;//修改后的头像

//消息条数
@property (strong, nonatomic) IBOutlet UILabel *complaintLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIView *numView;
@property (strong, nonatomic) TQStarRatingView *starView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *crashLabelWidth;

@property (strong, nonatomic) IBOutlet UIView *coinRuleView;

@property (strong, nonatomic) IBOutlet UIView *ruleBackView;

@property (strong, nonatomic) IBOutlet UIView *dataBackView;

@property (weak, nonatomic) IBOutlet UILabel *auditStateLabel;

- (IBAction)clickForRecommendPrize:(id)sender;

/**
 *存储用户信息的数组
 */
@property (nonatomic, strong)NSMutableArray *userDataArray;

@property (nonatomic, strong)NSMutableArray *viewControllerArray;



@end

@implementation MyViewController
- (void)AnalysisUserData{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"paths%@", paths);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSArray *keyArray =[userData allKeys];
    
    if (keyArray.count == 0) {
        
        
    }else {
        
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"studentId"] =userData[@"stuId"];
        NSLog(@"URL_Dic%@", URL_Dic);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __block MyViewController *VC = self;
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
    
            if ([resultStr isEqualToString:@"0"]) {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }else {
                [VC AnalyticalData:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
            [VC showAlert:@"请求失败请重试" time:1.0];
        }];
    }
}
//解析的用户详情的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    [self.userDataArray removeAllObjects];
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *urseDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"UserDataModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        UserDataModel *model = [[UserDataModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        [userData removeAllObjects];
        for (NSString *key in urseDataDic) {
            if ([key isEqualToString:@"subState"]) {
                [UserDataSingleton mainSingleton].subState =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"stuId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"state"]) {
                
                [UserDataSingleton mainSingleton].state = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"balance"]) {
                [UserDataSingleton mainSingleton].balance = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            NSLog(@"key%@",key);
            [userData setObject:urseDataDic[key] forKey:key];
            [model setValue:urseDataDic[key] forKey:key];
        }
        [self.userDataArray addObject:model];
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
        //输入写入
        [userData writeToFile:filename atomically:YES];
        //那怎么证明我的数据写入了呢？读出来看看
        NSMutableDictionary *userData2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    [self settingView];
}

-(NSMutableArray *)userDataArray {
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }

    return _userDataArray;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.mainScrollView.contentSize = CGSizeMake(0, self.dataBackView.height + self.dataBackView.y - 60);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AnalysisUserData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogOut:) name:@"LogOut" object:nil];
    
    // 点击背景退出键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backupgroupTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   // 只需要点击非文字输入区域就会响应
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    [self registerForKeyboardNotifications];
    
    //设置圆角
    self.alertDetailView.layer.cornerRadius = 4;
    self.alertDetailView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageCount) name:@"ReceiveTopMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAlert) name:@"openAlert" object:nil];
    
    self.moneyYuanField.delegate = self;
    
    //圆角
    self.rechargeBtn.layer.cornerRadius = 4;
    self.rechargeBtn.layer.masksToBounds = YES;
    self.convertButton.layer.cornerRadius = 2;
    self.convertButton.layer.masksToBounds = YES;
    self.coinConvertButton.layer.cornerRadius = 2;
    self.coinConvertButton.layer.masksToBounds = YES;
    
    self.ruleBackView.layer.cornerRadius = 3;
    self.ruleBackView.layer.masksToBounds = YES;
}

- (void)changeMessageCount {
    
}

-(void)backupgroupTap:(id)sender{
    [self.moneyYuanField resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)updateLogoImage:(UIImageView *)imageView{

}

- (void)settingView {
    
    self.getMoneyView.frame = [UIScreen mainScreen].bounds;
    
    //判断该用户是否通过审核
    NSDictionary *userInfo = [CommonUtil getObjectFromUD:@"userInfo"];
    NSString *state = [userInfo[@"state"] description];//2:通过审核
    NSString *logoUrl = userInfo[@"avatarurl"];//头像
    NSString *name = userInfo[@"realname"];
    NSString *phone = userInfo[@"phone"];//手机号
    NSString *signstate = [userInfo[@"signstate"] description];
    if ([signstate intValue]==1) {
        self.starImageView.hidden = NO;
    }else{
        self.starImageView.hidden = YES;
    }
    //培训时长
    NSString *totalTime = [userInfo[@"totaltime"] description];
    totalTime = [CommonUtil isEmpty:totalTime]?@"0":totalTime;
    state = @"2";//全部显示的为已经通过审核的UI
    

        self.dataView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)+80);
        [self.mainScrollView addSubview:self.dataView];
        self.mainScrollView.userInteractionEnabled=YES;
        NSString *money = [userInfo[@"money"] description];//余额
        //昵称
        if (name.length == 0) {
           self.nameLabel.text = @"未设置";
        }else{
           self.nameLabel.text = name;
        }
        
        self.phoneLabel.text = phone;
        [self.trainTimeButton setTitle:[NSString stringWithFormat:@"   已累计培训%@学时",totalTime] forState:UIControlStateNormal];
        //余额
        if ([CommonUtil isEmpty:money]) {
            money = @"0";
        }
        self.cashLabel.text = [NSString stringWithFormat:@"%@",money];
        //学车券时间
        int couponhour = [userInfo[@"couponhour"] intValue];
         self.xiaobaTicketLabel.text = [NSString stringWithFormat:@"%d",couponhour];
        //学车币个数
        NSString *coinnum = [userInfo[@"coinnum"] description];
        self.xiaobaCoinLabel.text = coinnum;
        
        float score = [userInfo[@"score"] floatValue];
        UILabel *label1 = [UILabel new];
        label1.text = self.nameLabel.text;
        label1.font =  [UIFont systemFontOfSize:20];
        label1.numberOfLines = 0;        // 设置无限换行
        
        CGRect rect = self.priceAndAddrBar.bounds;
        rect.origin.y = 3;
        rect.size.height = 15;
        rect.size.width = 103;
        self.starView = [[TQStarRatingView alloc] initWithFrame:rect numberOfStar:5];
        [self.priceAndAddrBar addSubview:self.starView];
        [self.starView changeStarForegroundViewWithScore:score];
    
    
}
//显示设置地址价格的弹框
- (void)openAlert{
    self.priceAndAddrView.frame = self.view.frame;
    [self.view addSubview:self.priceAndAddrView];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)dealloc {
    self.mainScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}
#pragma mark - 键盘遮挡输入框处理
// 监听键盘弹出通知
- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
// 键盘弹出，控件偏移
- (void) keyboardWillShow:(NSNotification *) notification {
    _oldFrame1 = self.commitView.frame;
    
//    UIView *priceCommitView = [self.setPriceView viewWithTag:100];
//    _oldFrame2 = priceCommitView.frame;

    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    CGFloat offset = CGRectGetMaxY(self.commitView.frame) - keyboardTop + 10;

    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.commitView.frame = CGRectMake(_oldFrame1.origin.x, _oldFrame1.origin.y - offset, _oldFrame1.size.width, _oldFrame1.size.height);
//    priceCommitView.frame = CGRectMake(_oldFrame2.origin.x, _oldFrame2.origin.y - offset, _oldFrame2.size.width, _oldFrame2.size.height);
    [UIView commitAnimations];

}
// 键盘收回，控件恢复原位
- (void) keyboardWillHidden:(NSNotification *) notif {
    self.commitView.frame = _oldFrame1;
//    UIView *priceCommitView = [self.setPriceView viewWithTag:100];
//    priceCommitView.frame = _oldFrame2;
}
#pragma mark - 拍照
- (CZPhotoPickerController *)photoController {
    typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        
        if (imagePickerController == nil || imageInfoDict == nil) {
            return;
        }
        
        UIImage *image = imageInfoDict[UIImagePickerControllerOriginalImage];
        if (image != nil) {
        //在这里获取图片
            
        }
        
        [self.alertPhotoView removeFromSuperview];
    }];
}
#pragma mark - 按钮方法
// 通过审核
- (IBAction)clickForPass:(id)sender {
    self.hasChecked = 1;
    [self.checkView removeFromSuperview];
}

- (IBAction)closeRuleView:(id)sender {
    [self.coinRuleView removeFromSuperview];
}
// 查看学车币/券规则
- (IBAction)clickForCoinRuleView:(id)sender {
    
}
// 更改头像
- (IBAction)clickForChangePortrait:(id)sender {
//    self.photoView.hidden = NO;
    self.alertPhotoView.frame = self.view.frame;
    [self.view addSubview:self.alertPhotoView];
}


// 进入优惠券界面
- (IBAction)clickForConvertTicket:(id)sender {
    CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
//查看学车币详情
- (IBAction)clickForCoinDetail:(id)sender {
    CoinListViewController *viewController = [[CoinListViewController alloc] initWithNibName:@"CoinListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
//查看收支详细
- (IBAction)lookDetail:(id)sender {

}

// 点击预约考试
- (IBAction)clickToMyComplainView:(id)sender {
    __weak MyViewController *VC = self;
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提醒!" message:@"是否进行预约?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSString *URL_Str = [NSString stringWithFormat:@"%@/exam/api/appointment",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"stuId"] = [UserDataSingleton mainSingleton].studentsId;
        NSLog(@"URL_Dic%@", URL_Dic);
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [VC showAlert:responseObject[@"msg"] time:1.2];
                [VC AnalysisUserData];
            }else {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@", error);
        }];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"对不起");
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertV animated:YES completion:^{
        nil;
    }];
    
}
// 分享注册链接
- (IBAction)clickToMyEvaluateView:(id)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon"]];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/share/to_jump?share_type_id=2&school_id=1&stu_id=%@",kURL_SHY,[UserDataSingleton mainSingleton].studentsId]]
                                      title:@"分享注册"
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}
// 我的通知
- (IBAction)clickToMyMessageView:(id)sender {

}
// 进入我的资料
- (IBAction)clickToMyInfoView:(id)sender {

}
//我的报名订单
- (IBAction)clickForSendCoupon:(id)sender {
    EnrollDetailsVC *VC = [[EnrollDetailsVC alloc] init];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:NAVC animated:YES completion:nil];
    
}

// 进入设置界面
- (IBAction)clickToSetting:(id)sender {
    UserInfoHomeViewController *viewController = [[UserInfoHomeViewController alloc] initWithNibName:@"UserInfoHomeViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//实现消息通知方法
- (void)LogOut:(NSNotification *)notification{
    LogInViewController *viewController = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
   
}

- (IBAction)clickForCoachMsg:(id)sender {

    
}
- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        for (int i = 0; i <= 5; i++) {
            MyOrderViewController *MyOrderVC = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
            MyOrderVC.index = i;
            [_viewControllerArray addObject:MyOrderVC];
        }
    }
    return _viewControllerArray;
}

//我的预约订单
 - (IBAction)clickForChongzhi:(id)sender {
     FYLPageViewController *FYLPageVC =[[FYLPageViewController alloc]initWithTitles:@[@"未完成",@"已完成",@"取消中",@"已取消",@"申诉中",@"已关闭"] viewControllers:self.viewControllerArray];
     UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
     //NAVC.navigationBarHidden = YES;
     [self setHidesBottomBarWhenPushed:YES];
     [self presentViewController:NAVC animated:YES completion:nil];
     
}

- (IBAction)removeChongzhi:(id)sender {
    [self.rechargeView removeFromSuperview];
}


- (IBAction)clickForCloseKeyboard:(id)sender {
    [self.rechargeYuanTextField resignFirstResponder];
}

#pragma mark - private
- (void)alipayForPartner:(NSString *)partner seller:(NSString *)seller privateKey:(NSString *)privateKey
                 tradeNO:(NSString *)tradeNO subject:(NSString *)subject body:(NSString *)body
                   price:(NSString *)price notifyURL:(NSString *)notifyURL{
   


}
- (IBAction)clickForChangeInfo:(id)sender {
  
}


- (IBAction)clickForRecommendPrize:(id)sender {
    
    
}



   

@end
