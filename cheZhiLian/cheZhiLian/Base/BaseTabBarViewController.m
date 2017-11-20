//
//  BaseTabBarViewController.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/11.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "HomePageVC.h"
#import "CoachDetailViewController.h"
#import "MyCenterVC.h"
#import "TestLibraryVC.h"
#import "StudentsCenterVC.h"
#import "AppDelegate.h"
@interface BaseTabBarViewController ()<TabBarViewDelegate>
@property (strong, nonatomic)AppDelegate *AppDelegate;
@property (nonatomic, strong)NSManagedObjectContext *managedContext;
@end

@implementation BaseTabBarViewController
- (NSManagedObjectContext *)managedContext {
    if (!_managedContext) {
        //获取Appdelegate对象
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.managedContext = delegate.managedObjectContext;
    }
    return _managedContext;
}
- (AppDelegate *)AppDelegate {
    if (!_AppDelegate) {
        self.AppDelegate = [[AppDelegate alloc] init];
    }
    return _AppDelegate;
}
- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 80;
    tabFrame.origin.y = self.view.frame.size.height - 80;
    self.tabBar.frame = tabFrame;
    
    TabBarView *tabBarView = [[TabBarView alloc]init];
    tabBarView.width = kScreen_widht;
    tabBarView.height = 80;
    tabBarView.x = 0;
    tabBarView.y = 0;
    tabBarView.backgroundColor = MColor(249, 249, 249);
    tabBarView.delegate = self;
    tabBarView.itemsCount = 4;
    [self.tabBar addSubview:tabBarView];
    
    UIView *topLine = [[UIView alloc] init];
    [tabBarView addSubview:topLine];
    topLine.width = kScreen_widht;
    topLine.height = 1;
    topLine.x = 0;
    topLine.y = 0;
    topLine.backgroundColor = MColor(214, 214, 214);
    [tabBarView itemsTitleConfig:@[@"知识", @"学车", @"预约", @"我的"]];
    
}
- (void)itemClick:(NSUInteger)itemIndex {
    
    [self setSelectedIndex:itemIndex];//默认显示的界面
    
    
}
// 添加tabBar
- (void)addTabBarView{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AnalysisUserData];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName, kOrange_Color,NSForegroundColorAttributeName, nil];
    
    TestLibraryVC *TLVC = [[TestLibraryVC alloc] init];
    UINavigationController *NATLVC = [[UINavigationController alloc] initWithRootViewController:TLVC];
    TLVC.tabBarItem.title =@"ti";
    TLVC.tabBarItem.image= [UIImage imageNamed:@"shouye"];
    TLVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    HomePageVC *homePageVC =[[HomePageVC alloc] init];
    UINavigationController *NAHomePageVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    NAHomePageVC.tabBarItem.title =@"主页";
    [NAHomePageVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kOrange_Color} forState:UIControlStateSelected];
    [NAHomePageVC.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    NAHomePageVC.tabBarItem.image= [UIImage imageNamed:@"shouye"];
    NAHomePageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CoachDetailViewController *dailyStudyVC = [[CoachDetailViewController alloc] init];
    UINavigationController *NADailyStudyVC = [[UINavigationController alloc] initWithRootViewController:dailyStudyVC];
    NADailyStudyVC.tabBarItem.title = @"预约学车";
    [NADailyStudyVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kOrange_Color} forState:UIControlStateSelected];
    [NADailyStudyVC.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    NADailyStudyVC.tabBarItem.image = [UIImage imageNamed:@"jinrixuexi"];
    NADailyStudyVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"jinrixuexi-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    StudentsCenterVC *CenterVC = [[StudentsCenterVC alloc] init];
    UINavigationController *NACenterVC = [[UINavigationController alloc] initWithRootViewController:CenterVC];
    NACenterVC.tabBarItem.title = @"我的界面";
    [NACenterVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kOrange_Color} forState:UIControlStateSelected];
    [NACenterVC.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    NACenterVC.tabBarItem.image = [UIImage imageNamed:@"gwc-1"];
    NACenterVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"gwc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //1.配置所管理的多个视图控制器
    self.viewControllers = @[NATLVC, NAHomePageVC, NADailyStudyVC, NACenterVC];//里面放的是控制器
    [self setSelectedIndex:1];//默认显示的界面
    
    
    
}


- (void)AnalysisUserData{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    // NSLog(@"paths%@", paths);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"userData%@", userData);
    NSArray *keyArray =[userData allKeys];
    if (keyArray.count == 0) {
        return;
    }
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] =userData[@"stuId"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block BaseTabBarViewController *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"0"]) {
        }else {
            [VC AnalyticalData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"请求失败请重试" time:1.0];
    }];
    
}

//解析的登录过后的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *userDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData removeAllObjects];
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"UserDataModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        UserDataModel *model = [[UserDataModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        
        for (NSString *key in userDataDic) {
            [model setValue:userDataDic[key] forKey:key];
            if ([key isEqualToString:@"subState"]) {
                [UserDataSingleton mainSingleton].subState =[NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"stuId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"state"]) {
                [UserDataSingleton mainSingleton].state = [NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            if ([key isEqualToString:@"balance"]) {
                [UserDataSingleton mainSingleton].balance = [NSString stringWithFormat:@"%@", userDataDic[key]];
            }
            [userData setObject:userDataDic[key] forKey:key];
        }
        [UserDataSingleton mainSingleton].userModel = model;
        NSLog(@"[UserDataSingleton mainSingleton].studentsId%@", [UserDataSingleton mainSingleton].studentsId);
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
    
}


@end
