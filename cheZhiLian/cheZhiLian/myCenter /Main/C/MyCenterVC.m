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
    }else {
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
        [UserDataSingleton mainSingleton].memberId = @"";
        [UserDataSingleton mainSingleton].studentsId = @"";
        [UserDataSingleton mainSingleton].subState = @"";
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
            cell.floorView.nameLabel.text = @"未登录";
            cell.floorView.TextImage.image = [UIImage imageNamed:@"logo.jpg"];
            cell.subjectsShow.text = @"";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        ServiceDisplayTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDisplayTVCell" forIndexPath:indexPath];
        NSString *subState;
        if ([UserDataSingleton mainSingleton].subState.length == 0) {
            subState = @"预约考试";
        }
        switch ([UserDataSingleton mainSingleton].subState.intValue) {
            case 0:
                subState = @"预约科一考试";
                break;
            case 1:
                subState = @"预约科二考试";
                break;
            case 2:
                subState = @"预约科三考试";
                break;
            case 3:
                subState = @"预约科四考试";
                break;
            case 4:
                subState = @"科四考试已经通过";
                break;
            default:
                break;
        }
        NSArray *array = @[@"学车订单", @"报名订单", subState];
        cell.titleLabel.text = array[indexPath.section-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        MyOrderViewController *MyOrderVC = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
        UINavigationController * NAMyOrderVC = [[UINavigationController alloc] initWithRootViewController:MyOrderVC];
        NAMyOrderVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NAMyOrderVC animated:YES completion:nil];
    }
    if (indexPath.section == 2) {
        EnrollDetailsVC *VC = [[EnrollDetailsVC alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NAVC animated:YES completion:nil];
    }
    if (indexPath.section == 3) {
        
        NSString *URL_Str = [NSString stringWithFormat:@"%@/exam/api/appointment",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
        NSLog(@"URL_Dic%@", URL_Dic);
        __weak MyCenterVC *VC = self;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [VC showAlert:@"预约成功" time:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@", error);
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
    view.frame = CGRectMake(0, 0, kScreen_widht, 10);
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

    NSString *URL_Str = [NSString stringWithFormat:@"%@/member/api/studentDetail", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"memberId"] =userData[@"memberId"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block MyCenterVC *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [_tableView.mj_header endRefreshing];
        if ([resultStr isEqualToString:@"0"]) {
            
            
        }else {
            [VC AnalyticalData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_tableView.mj_header endRefreshing];
        [VC showAlert:@"请求失败请重试" time:1.0];
    }];
    }
}
//解析的登录过后的数据
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
            if ([key isEqualToString:@"studentId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"memberId"]) {
                [UserDataSingleton mainSingleton].memberId =urseDataDic[key];
            }
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
    
    NSLog(@"userDataArray%@", self.userDataArray);
    [self.tableView reloadData];
    
}



@end
