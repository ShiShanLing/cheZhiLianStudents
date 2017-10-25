//
//  MyCenterVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/11.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "MyCenterVC.h"
#import "ServiceDisplayTVCell.h"
#import "MyOrderViewController.h"
#import "EnrollDetailsVC.h"
#import "MyOrderCViewCell.h"
#import "LogInViewController.h"

@interface MyCenterVC ()<UITableViewDelegate, UITableViewDataSource, MyOrderCViewCellDelegate>

@property (nonatomic, strong)UITableView *tableView;


/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray * userDataArray;;
@property (nonatomic,strong)NSMutableArray *viewControllerArray;
@end

@implementation MyCenterVC

- (NSMutableArray *)userDataArray {
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }
    return _userDataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.userDataArray removeAllObjects];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kScreen_heigth-80) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ServiceDisplayTVCell" bundle:nil] forCellReuseIdentifier:@"ServiceDisplayTVCell"];
        [_tableView registerClass:[MyOrderCViewCell class] forCellReuseIdentifier:@"MyOrderCViewCell"];
        NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 12; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]];
            [arrayM addObject:image];
        }
        
        MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self AnalysisUserData];
            
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        // 设置普通状态下的动画图片  -->  静止的一张图片
        NSArray * normalImagesArray = @[[UIImage imageNamed:@"1"]];
        [header setImages:normalImagesArray forState:MJRefreshStateRefreshing];
        
        // 设置即将刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStatePulling];
        
        // 设置正在刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStateRefreshing];
        
        // 设置header
        self.tableView.mj_header = header;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"学车服务";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *releaseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseButton.frame = CGRectMake(0, 0, 70, 50);
    [releaseButton setImage:[UIImage imageNamed:@"ic_menu"] forState:(UIControlStateNormal)];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:17];
    UIEdgeInsets  edgeInsets = releaseButton.imageEdgeInsets;
    edgeInsets.left = -50;
    releaseButton.imageEdgeInsets = edgeInsets;
    
    [releaseButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [releaseButton addTarget:self action:@selector(RegisteredAccount) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;

}
    - (void)RegisteredAccount {
        
        [self XYSideOpenVC];
    }
//返回上一页
- (void)handleReturn {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (void)MyOrderChoose:(int)index {

    if (self.userDataArray.count == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        UINavigationController * NALoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        NALoginVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NALoginVC animated:YES completion:nil];
    }else{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData  removeAllObjects];
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
        //输入写入
        [userData writeToFile:filename atomically:YES];
        [UserDataSingleton mainSingleton].studentsId = @"";
        [UserDataSingleton mainSingleton].subState = @"";
        [UserDataSingleton mainSingleton].subState = @"20";
        [self showAlert:@"退出登录成功" time:1.2];
        [self.userDataArray removeAllObjects];
        [self.tableView reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyOrderCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (self.userDataArray.count != 0) {
            cell.model = self.userDataArray[0];
        }else {
            [UserDataSingleton mainSingleton].studentsId = @"";
            [UserDataSingleton mainSingleton].subState = @"";
            [UserDataSingleton mainSingleton].subState = @"20";
            cell.floorView.nameLabel.text = @"未登录";
            cell.floorView.TextImage.image = [UIImage imageNamed:@"logo.jpg"];
            cell.subjectsShow.text = @"";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        ServiceDisplayTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDisplayTVCell" forIndexPath:indexPath];
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
        NSArray *array1 = @[@"学车订单", @"报名订单", subState];
        NSArray *array2 = @[@"学车时间的预约订单", @"报名课程的订单", subState];
        cell.titleLabel.text = array1[indexPath.section-1];
        cell.introduceLabel.text = array2[indexPath.section - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        
        for (int i = 1; i <= 5; i++) {
             MyOrderViewController *MyOrderVC = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
            MyOrderVC.index = i;
            [_viewControllerArray addObject:MyOrderVC];
        }
        
    }
    return _viewControllerArray;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        ///(0:未完成,1:已完结,2:取消中,3:已拒绝,4:已取消,5:申诉中,6:已关闭)
        FYLPageViewController *FYLPageVC =[[FYLPageViewController alloc]initWithTitles:@[@"未完成",@"已完成",@"取消中",@"已取消",@"申诉中"] viewControllers:self.viewControllerArray];
        

        UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
        //NAVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NAVC animated:YES completion:nil];
    }
    if (indexPath.section == 2) {
        EnrollDetailsVC *VC = [[EnrollDetailsVC alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NAVC animated:YES completion:nil];
    }
    if (indexPath.section == 3) {
        
        __weak MyCenterVC *VC = self;
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kFit(180);
    }else {
        return 88;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return 0.01;
    }else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MColor(234, 234, 234);
    view.frame = CGRectMake(0, 0, kScreen_widht, 0.01);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MColor(234, 234, 234);
    view.frame = CGRectMake(0, 0, kScreen_widht, 0.01);
    return view;
    
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
        
        [_tableView.mj_header endRefreshing];
        
    }else {

    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] =userData[@"stuId"];
        NSLog(@"URL_Dic%@", URL_Dic);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block MyCenterVC *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [_tableView.mj_header endRefreshing];
        if ([resultStr isEqualToString:@"0"]) {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }else {
            [VC AnalyticalData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_tableView.mj_header endRefreshing];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangesData" object:nil];
    }
    
    NSLog(@"userDataArray%@", self.userDataArray);
    [self.tableView reloadData];
}



@end
