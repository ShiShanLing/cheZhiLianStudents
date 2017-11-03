//
//  CouponListViewController.m
//  guangda_student
//
//  Created by guok on 15/6/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponTableViewCell.h"
#import "LoginViewController.h"

@interface CouponListViewController ()<UITabBarDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleRightLabel;
- (IBAction)clickForTitleLeft:(id)sender;
- (IBAction)clickForTitleRight:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *couponTableView;
@property (strong, nonatomic) IBOutlet UIView *noDataView; // 无数据提示页
/**
 *可变数组
 */
@property (nonatomic, strong)NSMutableArray * couponsListAray;

@end

@implementation CouponListViewController{
    NSInteger selectIndex;
    NSArray *couponList;
    NSArray *couponHisList;
    BOOL getDateSuccess;
    BOOL getHisDateSuccess;
}
- (NSMutableArray *)couponsListAray {
    if (!_couponsListAray) {
        _couponsListAray = [NSMutableArray array];
    }
    return _couponsListAray;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestData:@"0"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)handleReturn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectIndex = 1;
    couponList = [NSArray array];
    couponHisList = [NSArray array];
    getDateSuccess = NO;
    getHisDateSuccess = YES;
    self.noDataView.hidden = YES;
    
}

- (void)accessCouponsType{
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/coupon/api/getCouponClass", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    __weak  CouponListViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
- (void) requestData:(NSString *)type{
  // http://www.jxchezhilian.com/coupon/api/couponMemberList?memberId=f2356634919948448bd70064c15847e7&couponIsUsed=0
    NSString *URL_Str = [NSString stringWithFormat:@"%@/coupon/api/couponMemberList",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"memberId"] = [UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"couponIsUsed"] = type;
    __weak  CouponListViewController  *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC parsingData:responseObject];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (void)parsingData:(NSDictionary *)dataDic {
    [self.couponsListAray removeAllObjects];
    NSArray *dataArray =dataDic[@"data"];
    if (dataArray.count == 0) {
        return;
    }
    
    for (NSDictionary *modelDic in dataArray) {
        NSEntityDescription *des = [NSEntityDescription entityForName:@"CouponsModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        CouponsModel *model = [[CouponsModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        for (NSString *key in modelDic) {
            [model setValue:modelDic[key] forKey:key];
        }
        [self.couponsListAray addObject:model];
    }
    [self.couponTableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.couponsListAray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CouponTableViewCell";
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    }
    CouponsModel *model = self.couponsListAray[indexPath.row];

    cell.couponTipView.layer.cornerRadius = 3;
    cell.couponTipView.layer.masksToBounds = YES;
    int coupontype = model.couponClassId.intValue;
    if(coupontype ==0){
        cell.couponTitleLabel.text = @"满减券";
        cell.labeltitle2.text = [NSString stringWithFormat:@"满%d元抵用%d元",model.couponLimit, model.couponPrice];
      
    }else{
        cell.couponTitleLabel.text = @"学时券";
        cell.labeltitle2.text = [NSString stringWithFormat:@"本券可以抵用%d学时学费",model.couponDuration];
    }
    cell.couponPublishLabel.text = model.couponDesc;
    cell.couponEndTime.text = [NSString stringWithFormat:@"到期时间:%@",[CommonUtil getStringForDate:model.endTime]];
    cell.couponTipView.hidden = YES;
    if (model.couponIsUsed == 0) {
        cell.couponStateLabel.text = @"未使用";
    }else {
        cell.couponStateLabel.text = @"已使用";
    }
    //如果type是1 那么代表上个界面还需要看满减券 那么就把学时券黑掉
    if ([self.type isEqualToString:@"1"]) {
        if ([model.couponClassId isEqualToString:@"1"]) {
            cell.backgroundVIew.backgroundColor = MColor(200, 200, 200);
        }
    }else {
        NSLog(@"self.payAmount%f", self.payAmount);
        if (model.couponPrice > self.payAmount || model.couponLimit > self.payAmount || self.courseNum < model.couponDuration) {
            cell.backgroundVIew.backgroundColor = MColor(200, 200, 200);
        }else {
            
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CouponsModel *model = self.couponsListAray[indexPath.row];
    if ([self.type isEqualToString:@"1"]) {
        
        if ([model.couponClassId isEqualToString:@"1"]) {
            
        }else {
            NSLog(@"model.couponPrice%d model.couponLimit%d self.payAmount%f self.courseNum%d model.couponDuration%d",model.couponPrice ,model.couponLimit,self.payAmount,self.courseNum,model.couponDuration);
            if (model.couponPrice > self.payAmount || model.couponLimit > self.payAmount || self.courseNum > model.couponDuration) {
                
            }else {
                self.obtainCoupons(model.couponMemberId, model.couponPrice, model.couponClassId);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else {
        
        //如果是满减券
        if ([model.couponClassId isEqualToString:@"0"]) {
            
            if (model.couponPrice > self.payAmount || model.couponLimit > self.payAmount ) {
                
            }else {
                NSLog(@"model.couponClassId%@", model.couponClassId);
                self.obtainCoupons(model.couponMemberId, model.couponPrice, model.couponClassId);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {//否者就是学时券
            if (self.courseNum < model.couponDuration) {
                
            }else {
                self.obtainCoupons(model.couponMemberId, model.couponDuration, model.couponClassId);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)GetCoupon:(NSString *)couponId amount:(NSInteger)amount type:(NSString *)type{
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/getCouponMember", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"couponId"] = couponId;
    URL_Dic[@"memberId"] = [UserDataSingleton mainSingleton].studentsId;
    __weak  CouponListViewController *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            NSArray *couponArray = responseObject[@"data"];
            NSDictionary *couponDic = couponArray[0];
            NSString *couponMemberId = couponDic[@"couponMemberId"];
            self.obtainCoupons(couponMemberId, amount,type);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

// 可用学车券
- (IBAction)clickForTitleLeft:(id)sender {
    if(selectIndex == 1)
        return;
    self.titleImageView.image = [UIImage imageNamed:@"coupon_left_selected"];
    self.titleLeftLabel.textColor = MColor(255, 255, 255);
    self.titleRightLabel.textColor = MColor(184, 184, 184);
    selectIndex = 1;
    [self requestData:@"0"];
}

// 历史学车券
- (IBAction)clickForTitleRight:(id)sender {
    if(selectIndex == 2)
        return;
    self.titleImageView.image = [UIImage imageNamed:@"coupon_right_selected"];
    self.titleLeftLabel.textColor = MColor(184, 184, 184);
    self.titleRightLabel.textColor = MColor(255, 255, 255);
    selectIndex = 2;
    [self requestData:@"1"];
    
}

@end
