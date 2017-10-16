//
//  HomePageVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "HomePageVC.h"
#import "GoodsDetailsVC.h"
#import "LearnCarShowTVCell.h"
@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;


/**
 存储商品的数组
 */
@property (nonatomic, strong)NSMutableArray *goodsListArray;

@end

@implementation HomePageVC

- (NSMutableArray *)goodsListArray {
    if (!_goodsListArray) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kScreen_heigth-80) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"LearnCarShowTVCell" bundle:nil] forCellReuseIdentifier:@"LearnCarShowTVCell"];
        NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 12; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]];
            [arrayM addObject:image];
        }
        MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self RequestInterface];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        // 设置普通状态下的动画图片  -->  静止的一张图片
        NSArray * normalImagesArray = @[[UIImage imageNamed:@"1"]];
        [header setImages:normalImagesArray forState:MJRefreshStatePulling];
        // 设置即将刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStateRefreshing];
        // 设置header
        self.tableView.mj_header = header;
    }
    return _tableView;
}
/**
 *请求数据
 */
- (void)RequestInterface {
    [_tableView.mj_header endRefreshing];
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/goods/api/findCourseList", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"storeId"] = @"1";
    __weak HomePageVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [VC parsingData:responseObject[@"data"]];
        [_tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [_tableView.mj_header endRefreshing];
        [VC makeToast:@"网络超时.请重试!"];
    }];
    
    
}
/**
 * 解析数据
 * @param array 存储数据的数组
 */
- (void)parsingData:(NSArray *)array {
    [self.goodsListArray removeAllObjects];
    for (NSDictionary *dataDic  in array) {
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"CourseListModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        CourseListModel *model = [[CourseListModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        
        for (NSString *key in dataDic) {
            //   NSLog(@"key%@",key);
            [model setValue:dataDic[key] forKey:key];
        }
        [self.goodsListArray addObject:model];
    }
    
    //  NSLog(@"self.goodsListArray%@", self.goodsListArray);
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"警告!" message:@"你点我干嘛" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"我错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"我错了");
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"对不起" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"对不起");
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertV animated:YES completion:^{
        nil;
    }];

    
    [self.tableView.mj_header beginRefreshing];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LearnCarShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LearnCarShowTVCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.goodsListArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailsVC *VC = [[GoodsDetailsVC alloc] init];
    UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    CourseListModel *model = self.goodsListArray[indexPath.row];
    VC.goodsId = model.goodsId;
    [self presentViewController:NAVC animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
