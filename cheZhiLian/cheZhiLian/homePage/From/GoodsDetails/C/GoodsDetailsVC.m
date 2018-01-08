
//
//  GoodsDetailsVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "GoodsDetailsVC.h"
#import "GoodsIntroductionTVCell.h"
#import "GoodsPromisedTVCell.h"
#import "FeeItemizationsTVCell.h"
#import "ConfirmOrderVC.h"

@interface GoodsDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray *goodsDetailsArray;

@end

@implementation GoodsDetailsVC

- (NSMutableArray *)goodsDetailsArray {
    if (!_goodsDetailsArray) {
        _goodsDetailsArray = [NSMutableArray array];
    }
    return _goodsDetailsArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kScreen_heigth-64-77) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GoodsIntroductionTVCell" bundle:nil] forCellReuseIdentifier:@"GoodsIntroductionTVCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"GoodsPromisedTVCell" bundle:nil] forCellReuseIdentifier:@"GoodsPromisedTVCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FeeItemizationsTVCell" bundle:nil] forCellReuseIdentifier:@"FeeItemizationsTVCell"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self RequestInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学车报名";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *releaseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseButton.frame = CGRectMake(0, 0, 35, 35);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"ico_back"] forState:(UIControlStateNormal)];
    [releaseButton addTarget:self action:@selector(handleReturn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    
    [self.view addSubview:self.tableView];
    
    UIView *payView = [[UIView alloc] init];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    payView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(77);
    
    
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [payBtn setTitle:@"确认报名" forState:(UIControlStateNormal)];
    [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    payBtn.backgroundColor = MColor(255, 74, 0);
    payBtn.layer.cornerRadius = 5;
    payBtn.layer.masksToBounds = YES;
    [payBtn addTarget:self action:@selector(handlePayBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:payBtn];
    payBtn.sd_layout.leftSpaceToView(self.view, 17).rightSpaceToView(self.view, 17).bottomSpaceToView(self.view, 17).heightIs(44);
}

/**
 *请求数据
 */
- (void)RequestInterface {
    //http://106.14.158.95:8080/com-zerosoft-boot-assembly-seller-local-1.0.0-SNAPSHOT/goods/api/goodsdetail?goodsId=6d0e8b211fc943aa85b3704556dcc3b6
    NSString *URL_Str = [NSString stringWithFormat:@"%@/goods/api/goodsdetail", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"goodsId"] = self.goodsId;
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak GoodsDetailsVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [VC parsingData:responseObject[@"goods"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
    
    
}
/**
 * 解析数据
 * @param array 存储数据的数组
 */
- (void)parsingData:(NSArray *)array {
    [self.goodsDetailsArray removeAllObjects];
    
    for (NSDictionary *dataDic  in array) {
        NSEntityDescription *des = [NSEntityDescription entityForName:@"CourseDetailModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        
        CourseDetailModel *model = [[CourseDetailModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        for (NSString *key in dataDic) {
            NSLog(@"key%@",key);
            [model setValue:dataDic[key] forKey:key];
        }
        [self.goodsDetailsArray addObject:model];
    }
   // NSLog(@"self.goodsDetailsArray%@", self.goodsDetailsArray);
    [self.tableView reloadData];
    
}
//支付
- (void)handlePayBtn {
    if (self.goodsDetailsArray.count == 0) {
        
    }else {
        
        if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
            
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            UINavigationController * NALoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            NALoginVC.navigationBarHidden = YES;
            [self setHidesBottomBarWhenPushed:YES];
            [self presentViewController:NALoginVC animated:YES completion:nil];

        }else {
        
            ConfirmOrderVC *VC = [[ConfirmOrderVC alloc] init];
            VC.goodsDetailsModel = self.goodsDetailsArray[0];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
//返回上一页
- (void)handleReturn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsDetailsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsIntroductionTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsIntroductionTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.goodsDetailsArray[indexPath.section];
        return cell;
    }else if (indexPath.section == 1) {
    
        GoodsPromisedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPromisedTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        FeeItemizationsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeeItemizationsTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showAlert:[NSString stringWithFormat:@"您点击了第%ld排的第%ld个按钮", (long)indexPath.section, (long)indexPath.row] time:1.2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 148;
    }else if (indexPath.section == 1){
        return 407;
    }else {
    
        return 495;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MColor(234, 234, 234);
    if (section == 0) {
        view.frame = CGRectMake(0, 0, 0, 0);
    }else {
    
        view.frame = CGRectMake(0, 0, kScreen_widht, 10);
    }
    return view;
}
@end
