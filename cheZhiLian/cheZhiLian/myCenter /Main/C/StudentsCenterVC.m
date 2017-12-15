//
//  StudentsCenterVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/11/7.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "StudentsCenterVC.h"
#import "EnrollDetailsVC.h"
#import "MyOrderViewController.h"
#import "UserInfoHomeViewController.h"
#import "SettingViewController.h"
#import "CouponListViewController.h"
#import "AccountViewController.h"
@interface StudentsCenterVC ()
@property (nonatomic, strong)NSMutableArray *viewControllerArray;
@property (weak, nonatomic) IBOutlet UILabel *testScheduleLabel;

@property (weak, nonatomic) IBOutlet UILabel *studentDriverStateLabel;

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;
/**
 学车币
 */
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
/**
 优惠券
 */
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
/**
 消息展示view
 */
@property (weak, nonatomic) IBOutlet UIView *messagesNumView;
/**
 消息数量
 */
@property (weak, nonatomic) IBOutlet UILabel *messagesLabel;
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *HeadPortraitImageView;
/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**
 电话
 */
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@end

@implementation StudentsCenterVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setHidesBottomBarWhenPushed:NO];
    
    self.navigationController.navigationBar.hidden = YES;
    self.userNameLabel.text = @"未登录";
    self.userPhoneLabel.text = @"";
    self.BalanceLabel.text = @"0";
    self.couponsLabel.text = @"0";
    self.currencyLabel.text = @"0";
    [self AnalysisUserData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setHidesBottomBarWhenPushed:YES];
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
//学车订单
- (IBAction)handleStudentDriverOrder:(UIButton *)sender {
    FYLPageViewController *FYLPageVC =[[FYLPageViewController alloc]initWithTitles:@[@"未完成",@"已完成",@"取消中",@"已取消",@"申诉中",@"已关闭"] viewControllers:self.viewControllerArray];
    UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
    //NAVC.navigationBarHidden = YES;
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//报名订单
- (IBAction)handleSignUpOrder:(UIButton *)sender {
    EnrollDetailsVC *VC = [[EnrollDetailsVC alloc] init];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//预约考试
- (IBAction)handleReservationTest:(UIButton *)sender {
    __weak StudentsCenterVC *VC = self;
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
            //    [VC AnalysisUserData];
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
//分享注册
- (IBAction)handleShareRegistered:(UIButton *)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon"]];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/share/to_jump?share_type_id=2&school_id=%@&stu_id=%@",kURL_SHY,kStoreId,[UserDataSingleton mainSingleton].studentsId]]
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
- (IBAction)handleMyData:(UIButton *)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        UINavigationController * NALoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        NALoginVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NALoginVC animated:YES completion:nil];
        return;
    }
    UserInfoHomeViewController *viewController = [[UserInfoHomeViewController alloc] initWithNibName:@"UserInfoHomeViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (IBAction)handleMySetUp:(UIButton *)sender {
    
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//查看余额
- (IBAction)handleCheckBalance:(UIButton *)sender {
    AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//查看积分
- (IBAction)handleCheckIntegral:(UIButton *)sender {
    
}
//查看优惠券
- (IBAction)handleCheckCoupons:(UIButton *)sender {
    CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




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
        __block StudentsCenterVC *VC = self;
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
    NSEntityDescription *des = [NSEntityDescription entityForName:@"UserDataModel" inManagedObjectContext:self.managedContext];
    //根据描述 创建实体对象
    UserDataModel *model = [[UserDataModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *urseDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
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
    self.userNameLabel.text = model.userName.length?@"未设置":model.userName;
    self.userPhoneLabel.text = model.phone;
    self.BalanceLabel.text = [NSString stringWithFormat:@"%d",model.balance];
    self.couponsLabel.text = [NSString stringWithFormat:@"%d",model.ticket];
    self.currencyLabel.text = [NSString stringWithFormat:@"%ld",model.points];
    NSString *subState;
    /**
     *  `sub_state` tinyint(1) DEFAULT '0' COMMENT '科目状态(0:未参加科目考试1:科目一已通过2:科目二已通过3:科目三已通过4:科目四已通过)',
     `state` tinyint(1) DEFAULT '0' COMMENT '预约考试状态(0:未预约1:待审批2:审批通过3:审批未通过)',
     
     */
    if ([UserDataSingleton mainSingleton].subState.intValue == 20 || [UserDataSingleton mainSingleton].subState.length == 0) {
        subState = @"预约考试";
    }
    switch ([UserDataSingleton mainSingleton].subState.intValue) {
        case 0:
            switch ([UserDataSingleton mainSingleton].state.intValue) {
                case 0:
                    subState = @"预约科一考试";
                    break;
                case 1:
                    subState = @"科一预约等待审核";
                    break;
                case 2:
                    subState = @"科一考试预约成功,等待考试!";
                    break;
                case 3:
                    subState = @"预约科一考试";
                    break;
                default:
                    break;
            }
            
            break;
        case 1:
            switch ([UserDataSingleton mainSingleton].state.intValue) {
                case 0:
                    subState = @"预约科二考试";
                    break;
                case 1:
                    subState = @"科二预约等待审核";
                    break;
                case 2:
                    subState = @"科二考试预约成功,等待考试!";
                    break;
                case 3:
                    subState = @"预约科二考试";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([UserDataSingleton mainSingleton].state.intValue) {
                case 0:
                    subState = @"预约科三考试";
                    break;
                case 1:
                    subState = @"科三预约等待审核";
                    break;
                case 2:
                    subState = @"科三考试预约成功,等待考试!";
                    break;
                case 3:
                    subState = @"预约科三考试";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch ([UserDataSingleton mainSingleton].state.intValue) {
                case 0:
                    subState = @"预约科四考试";
                    break;
                case 1:
                    subState = @"科四预约等待审核";
                    break;
                case 2:
                    subState = @"科四考试预约成功,等待考试!";
                    break;
                case 3:
                    subState = @"预约科四考试";
                    break;
                default:
                    break;
            }
            break;
        case 4:
            subState = @"科四考试已经通过";
            break;
        default:
            break;
    }
    self.testScheduleLabel.text = subState;
}

@end
