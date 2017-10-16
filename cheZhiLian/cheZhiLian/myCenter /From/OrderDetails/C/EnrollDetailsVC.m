//
//  EnrollDetailsVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "EnrollDetailsVC.h"

@interface EnrollDetailsVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

/**
 订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
/**
 订单成交时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
/**
 商品名字
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

/**
 学车地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
/**
 商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
/**
 订单总价
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
/**
 订单优惠金额
 */
@property (weak, nonatomic) IBOutlet UILabel *PreferentialPriceLabel;
/**
 订单应付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *NeedPayPriceLabel;
/**
 已付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *AmountPaidLabel;
/**
 未付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *UnpaidAmountLabel;


@end

@implementation EnrollDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.payBtn.hidden = YES;
    [self RequestInterface];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *releaseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseButton.frame = CGRectMake(0, 0, 35, 35);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"ico_back"] forState:(UIControlStateNormal)];
    [releaseButton addTarget:self action:@selector(handleReturn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = MColor(245, 245, 245);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.bounces = NO;
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
}
- (void)handleReturn {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *请求数据
 */
- (void)RequestInterface {
    //http://106.14.158.95:8080/com-zerosoft-boot-assembly-seller-local-1.0.0-SNAPSHOT/order/api/orderlist?stuId=d30fe3ffe32c408aaa22b799f795e044&status=10&pageNo=1&pageSize=10&orderType=1
    NSString *URL_Str = [NSString stringWithFormat:@"%@/order/api/orderlist", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"status"] = @"10";
    URL_Dic[@"pageNo"] = @"1";
    URL_Dic[@"pageSize"] = @"10";
    URL_Dic[@"orderType"] = @"1";
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak EnrollDetailsVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [VC parsingOrderDetaillsData:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (void)parsingOrderDetaillsData:(NSArray *)dataArray {
    if (dataArray.count == 0) {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提醒!" message:@"你好没有订单,请先下单" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertV addAction:cancle];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];
    }else {
        self.mainScrollView.hidden = NO;
        NSDictionary *dataDic = dataArray[0];
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"GoodsOrderDetailsModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        GoodsOrderDetailsModel *model = [[GoodsOrderDetailsModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        
        for (NSString *key in dataDic) {
            [model setValue:dataDic[key] forKey:key];
        }
        self.goodsNameLabel.text = model.storeName;
        self.orderStateLabel.text = [NSString stringWithFormat:@"订单编号:%@", model.orderSn];
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.goodsAmount];
        self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];
        self.PreferentialPriceLabel.text = @"- 0";
        self.NeedPayPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];
        self.AmountPaidLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];
        self.UnpaidAmountLabel.text = @"0";
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
