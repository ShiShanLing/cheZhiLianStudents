//
//  ConfirmOrderVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "confirmGoodsTVCell.h"
#import "ConfirmBuyersTVCell.h"
#import "CouponChooseTVCell.h"
#import "TotalPriceView.h"
@interface ConfirmOrderVC ()<UITableViewDelegate, UITableViewDataSource, TotalPriceViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)TotalPriceView *totalPriceView;
@end

@implementation ConfirmOrderVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kScreen_heigth-64-46) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"confirmGoodsTVCell" bundle:nil] forCellReuseIdentifier:@"confirmGoodsTVCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ConfirmBuyersTVCell" bundle:nil] forCellReuseIdentifier:@"ConfirmBuyersTVCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CouponChooseTVCell" bundle:nil] forCellReuseIdentifier:@"CouponChooseTVCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createReturnBtn];
    [self.view addSubview:self.tableView];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TotalPriceView" owner:self options:nil];
    self.totalPriceView = [nib objectAtIndex:0];
    _totalPriceView.delegate = self;
    __weak ConfirmOrderVC *VC = self;
    _totalPriceView.SubmitOrders = ^{
        [VC RequestInterface];
    };
    [self.view addSubview:_totalPriceView];
    _totalPriceView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(46);
}

/**
 *请求数据
 */
- (void)RequestInterface {
    NSString *URL_Str = [NSString stringWithFormat:@"%@/order/api/saveReservationOrder", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"memberId"] = [UserDataSingleton mainSingleton].memberId;
    URL_Dic[@"storeId"] = kStoreId;
    URL_Dic[@"goodsId"] = _goodsDetailsModel.goodsId;
    __weak ConfirmOrderVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"报名数据responseObject%@", responseObject);
        NSString *resultStr= [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC showAlert:responseObject[@"msg"] time:1.2];
        if ([resultStr isEqualToString:@"1"]) {
            [VC.navigationController popViewControllerAnimated:YES];
        }else {
            [VC.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        confirmGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmGoodsTVCell" forIndexPath:indexPath];
        _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"需付款:¥ %.2f", _goodsDetailsModel.goodsStorePrice];
        cell.model = self.goodsDetailsModel;
        return cell;
    }else if(indexPath.section == 1){
    
        ConfirmBuyersTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmBuyersTVCell" forIndexPath:indexPath];
        return cell;
    }else  {
        CouponChooseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponChooseTVCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.titleNameLabel.text = @"付款方式";
            cell.ContentNameLabel.text = @"全款";
        }
        if (indexPath.row == 0) {
            cell.titleNameLabel.text = @"优惠券";
            cell.ContentNameLabel.text = @"你还没有优惠券";
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 106;
    }else if (indexPath.section == 1) {
    
        return 95;
    }else  {
        return 54;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 10)];
    view.backgroundColor = MColor(234, 234, 234);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 0.01)];
    view.backgroundColor = MColor(234, 234, 234);
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
