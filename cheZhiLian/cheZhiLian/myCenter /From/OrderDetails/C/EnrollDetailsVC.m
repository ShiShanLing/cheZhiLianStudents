//
//  EnrollDetailsVC.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "EnrollDetailsVC.h"
#import <AlipaySDK/AlipaySDK.h>
@interface EnrollDetailsVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

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

@property (weak, nonatomic) IBOutlet UILabel *paymentStateLabel;

@property(nonatomic, strong)NSMutableArray *orderModelArray;

@end

@implementation EnrollDetailsVC {
    
    NSString *orderId;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataView.hidden = YES;
    [self RequestInterface];
    self.orderModelArray = [NSMutableArray array];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"return" object:nil];
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
-(void)notice:(id)sender{
    
    [self RequestInterface];
}
/**
 *请求数据
 */
- (void)RequestInterface {
    //http://106.14.158.95:8080/com-zerosoft-boot-assembly-seller-local-1.0.0-SNAPSHOT/order/api/orderlist?stuId=d30fe3ffe32c408aaa22b799f795e044&status=10&pageNo=1&pageSize=10&orderType=1
    NSString *URL_Str = [NSString stringWithFormat:@"%@/order/api/orderlist", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
 
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak EnrollDetailsVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC parsingOrderDetaillsData:responseObject[@"data"]];
        }else {
            [VC showAlert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.noDataView.hidden = NO;
        NSLog(@"error%@", error);
    }];
}

- (void)parsingOrderDetaillsData:(NSArray *)dataArray {
    if (dataArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
        self.mainScrollView.hidden = NO;
        NSDictionary *dataDic = dataArray[0];
        NSEntityDescription *des = [NSEntityDescription entityForName:@"GoodsOrderDetailsModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        GoodsOrderDetailsModel *model = [[GoodsOrderDetailsModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        model.discount = 0;
        
            NSArray *goodListArray = dataDic[@"orderGoodsList"];
            if (goodListArray.count !=0) {
                NSDictionary *goodDic = goodListArray[0];
                model.goodsId = goodDic[@"goodsId"];
                model.goodsName = goodDic[@"goodsName"];
            }
        for (NSString *key in dataDic) {
     
            [model setValue:dataDic[key] forKey:key];
        }
        [self.orderModelArray addObject:model];
        orderId = model.orderId;
        self.goodsNameLabel.text = model.storeName;
        self.orderStateLabel.text = [NSString stringWithFormat:@"订单编号:%@", model.orderSn];
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.goodsAmount];//商品价格
        self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.goodsAmount];//商品总价
        self.PreferentialPriceLabel.text =[NSString stringWithFormat:@"%d",model.discount];//优惠多少钱
        self.NeedPayPriceLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];//应该付多少钱
        if (model.orderType == 0) {
            self.paymentStateLabel.text =  @"全款";
            if (model.orderState == 10) {
                self.AmountPaidLabel.text = [NSString stringWithFormat:@"¥:%.2f", 0.0];//实付金额
                self.UnpaidAmountLabel.text = [NSString stringWithFormat:@"%.2f", model.orderAmount];
                self.cancelBtn.hidden = NO;
                self.payBtn.hidden = NO;
            }else {
                self.cancelBtn.hidden = YES;
                self.payBtn.hidden = YES;
                self.AmountPaidLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];//实付金额
                self.UnpaidAmountLabel.text = [NSString stringWithFormat:@"%.2f", 0.0];
            }
        }else {
            self.paymentStateLabel.text =  @"非全款";
            if (model.orderState == 10) {
                self.AmountPaidLabel.text = [NSString stringWithFormat:@"¥:%.2f", 0.0];//实付金额
                self.UnpaidAmountLabel.text = [NSString stringWithFormat:@"%.2f", model.orderAmount];
                self.cancelBtn.hidden = NO;
                self.payBtn.hidden = NO;
            }else {
                self.cancelBtn.hidden = YES;
                self.payBtn.hidden = YES;
                self.AmountPaidLabel.text = [NSString stringWithFormat:@"¥:%.2f", model.orderAmount];//实付金额
                self.UnpaidAmountLabel.text = [NSString stringWithFormat:@"%.2f", 0.0];
            }
        }
    }
}

- (IBAction)handlePay:(UIButton *)sender {
    
    if (self.orderModelArray.count == 0) {
        return;
    }
    GoodsOrderDetailsModel *model = self.orderModelArray[0];
    [self performSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/alipay/api/generateSignature",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"body"] = model.storeName;
    URL_Dic[@"subject"]=model.goodsName;
    URL_Dic[@"outTradeNo"]=model.orderSn;
    URL_Dic[@"totalAmount"] = [NSString stringWithFormat:@"%.2f",model.orderAmount];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block EnrollDetailsVC *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"requestPaymentSignature%@", responseObject);
        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        [VC performSelector:@selector(delayMethod)];
        if ([str isEqualToString:@"1"]) {
            NSString *signature = responseObject[@"data"];
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"chezhilianScheme";
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:signature fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSString *resultStatus = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
                NSInteger state = resultStatus.integerValue;
                [VC performSelector:@selector(delayMethod)];
                switch (state) {
                    case 9000:
                        [VC showAlert:@"订单支付成功"];
                        
                        break;
                    case 8000:
                        [VC showAlert:@"正在处理中，支付结果未知（有可能已经支付成功），请查询订单列表中订单的支付状态"];
                        
                        break;
                    case 4000:
                        [VC showAlert:@"订单支付失败"];
                        
                        break;
                    case 6001:
                        [VC showAlert:@"用户中途取消"];
                        
                        break;
                    case 6002:
                        [VC showAlert:@"网络连接出错"];
                        
                        break;
                    default:
                        break;
                }
                
                NSLog(@"DetermineBtnClick = %@",resultDic);
                NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }];
        }else {
            [VC showAlert:@"订单提交失败请重试!"];
            NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC performSelector:@selector(delayMethod)];
        [VC showAlert:@"网络出现问题.请稍后再试!" time:1.0];
        NSLog(@"%@", error);
    }];
}

- (IBAction)handleCancelOrder:(UIButton *)sender {
    
    
    
}

- (IBAction)handleContinuePay:(UIButton *)sender {
    
    
    
}
//支付宝支付
- (void)requestAliPaymentSignature:(NSString *)price subject:(NSString *)subject outTradeNo:(NSString *)outTradeNo body:(NSString *)body {
  
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
