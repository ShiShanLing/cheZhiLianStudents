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

@end

@implementation CouponListViewController{
    NSInteger selectIndex;
    NSArray *couponList;
    NSArray *couponHisList;
    BOOL getDateSuccess;
    BOOL getHisDateSuccess;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    [self getCouponDate];
    [self getHisCouponDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求
- (void) getCouponDate{
    
    
}

- (void) backLogin{
 
}

- (void) getHisCouponDate{
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 20;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CouponTableViewCell";
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    }
    cell.couponTipView.layer.cornerRadius = 3;
    cell.couponTipView.layer.masksToBounds = YES;
    int coupontype = arc4random()%2 +1;
    if(coupontype == 1){
        cell.couponTitleLabel.text = @"小巴券－学时券";
        cell.labeltitle2.text = [NSString stringWithFormat:@"本券可以抵用%d学时学费",2];
    }else{
        cell.couponTitleLabel.text = @"小巴券－抵价券";
        cell.labeltitle2.text = [NSString stringWithFormat:@"本券可以抵用学费%d元",1000];
    }
    cell.couponPublishLabel.text = @"测试标题";
         cell.couponEndTime.text = [NSString stringWithFormat:@"有效期:%@",@"无限制"];
   
    int a = arc4random()%2 +1;
    if(a == 1){
        cell.couponTipView.hidden = YES;
    }else{
        cell.couponTipView.hidden = NO;
        cell.couponStateLabel.text = @"已使用";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

// 可用小巴券
- (IBAction)clickForTitleLeft:(id)sender {
    if(selectIndex == 1)
        return;
    self.titleImageView.image = [UIImage imageNamed:@"coupon_left_selected"];
    self.titleLeftLabel.textColor = MColor(255, 255, 255);
    self.titleRightLabel.textColor = MColor(184, 184, 184);
    selectIndex = 1;
    [self.couponTableView reloadData];
}

// 历史小巴券
- (IBAction)clickForTitleRight:(id)sender {
    if(selectIndex == 2)
        return;
    self.titleImageView.image = [UIImage imageNamed:@"coupon_right_selected"];
    self.titleLeftLabel.textColor = MColor(184, 184, 184);
    self.titleRightLabel.textColor = MColor(255, 255, 255);
    selectIndex = 2;
    [self.couponTableView reloadData];
}

@end
