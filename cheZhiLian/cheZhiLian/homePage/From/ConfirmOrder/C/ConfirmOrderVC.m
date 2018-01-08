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
#import "UserBaseInfoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CouponListViewController.h"
@interface ConfirmOrderVC ()<UITableViewDelegate, UITableViewDataSource, TotalPriceViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)TotalPriceView *totalPriceView;


@end

@implementation ConfirmOrderVC {
    NSInteger couponsAmounte;
    NSString *couponMemberId;
    NSString *couponsType;
    NSString *realName;
    NSString *phone;
    NSString *IdNum;
    NSString *TermsPayment;//付款方式
    NSString *firstMoney;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userDic= [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"userData%@", userDic);
    
    NSArray *keyArray =[userDic allKeys];
    if (keyArray.count == 0) {
        return;
    }

    NSString * IdNumString = [userDic objectForKey:@"idCard"];
    if (IdNumString.length == 0) {
        return;
    }
    realName = [userDic objectForKey:@"realName"];
    IdNum = IdNumString;
    phone = [userDic objectForKey:@"phone"];
    [self.tableView reloadData];
}

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
    TermsPayment = @"1";
    [self.view addSubview:self.tableView];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"return" object:nil];
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
-(void)notice:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)extracted {
    return kURL_SHY;
}

/**
 *请求数据
 */
- (void)RequestInterface {
    
    if (IdNum.length == 0) {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"友情提醒!" message:@"你还没有填写真实信息!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"我再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去填写" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UserBaseInfoViewController *targetViewController = [[UserBaseInfoViewController alloc] initWithNibName:@"UserBaseInfoViewController" bundle:nil];
            [self.navigationController pushViewController:targetViewController animated:YES];

        }];
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        [alertV addAction:cancle];
        [alertV addAction:confirm];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];
        return;
    }
    
    if ([TermsPayment isEqualToString:@"0"]) {
        if (firstMoney.length == 0) {
            [self showAlert:@"首款信息获取失败,请使用全款或者稍后重试" time:1.0];
            return;
        }
    }
    
    
    
    [self performSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/order/api/saveEnrollOrder", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
    URL_Dic[@"storeId"] = [UserDataSingleton mainSingleton].kStoreId;
    URL_Dic[@"goodsId"] = _goodsDetailsModel.goodsId;
    URL_Dic[@"couponMemberId"] = couponMemberId.length == 0?@"":couponMemberId;
    URL_Dic[@"payType"] = TermsPayment;
    NSLog(@"RequestInterface%@", URL_Dic);
    __weak ConfirmOrderVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 10.0f;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"报名数据responseObject%@", responseObject);
        NSString *resultStr= [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        //[VC showAlert:responseObject[@"msg"] time:1.2];
        
        if ([resultStr isEqualToString:@"1"]) {
            NSString *price;
            NSString *subject;
            NSString *outTradeNo;
            NSString *body;
            NSArray *dataArray = responseObject[@"data"];
            NSDictionary *dataDic = dataArray[0];
            outTradeNo = dataDic[@"outTradeNo"];
            price=[NSString stringWithFormat:@"%@", dataDic[@"totalAmount"]];
            subject =dataDic[@"subject"];
            body = dataDic[@"body"];
            [self requestAliPaymentSignature:price subject:subject outTradeNo:outTradeNo body:body];
        }else {
            [self performSelector:@selector(delayMethod)];
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self performSelector:@selector(delayMethod)];
        NSLog(@"error%@", error);
    }];
}

//支付宝支付
- (void)requestAliPaymentSignature:(NSString *)price subject:(NSString *)subject outTradeNo:(NSString *)outTradeNo body:(NSString *)body {
    NSString *URL_Str = [NSString stringWithFormat:@"%@/alipay/api/generateSignature",kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"body"] = body;
    URL_Dic[@"subject"]=subject;
    URL_Dic[@"outTradeNo"]=outTradeNo;
    URL_Dic[@"totalAmount"] = price;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block ConfirmOrderVC *VC = self;
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
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 8000:
                        [VC showAlert:@"正在处理中，支付结果未知（有可能已经支付成功），请查询订单列表中订单的支付状态"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 4000:
                        [VC showAlert:@"订单支付失败"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 6001:
                        [VC showAlert:@"用户中途取消"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    case 6002:
                        [VC showAlert:@"网络连接出错"];
                        [VC.navigationController popViewControllerAnimated:YES];
                        break;
                    default:
                        break;
                }
                
                NSLog(@"DetermineBtnClick = %@",resultDic);
          
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

        if ([TermsPayment isEqualToString:@"0"]) {//如果是首款
            if (firstMoney.length != 0) {//如果首款获取成功
                if (firstMoney.floatValue<couponsAmounte) {//如果要付的金额没有优惠券金额大
                    couponMemberId = @"";
                    //那就直接不使用优惠券 付原款
                    _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"需付款:¥ %@",firstMoney];
                }else {
                    //否者吧要付的金额减去优惠券金额
                    _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"需付款:¥ %.f",firstMoney.floatValue-couponsAmounte];
                    
                }
            }else {//否者首款获取失败
                _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"首款信息获取失败.请使用全款支付,获取稍后再试"];
            }
        }else {//否者是全款
            if (_goodsDetailsModel.goodsStorePrice<couponsAmounte) {//如果付的金额没有优惠券金额大
                //那就付原款
                couponMemberId = @"";
                _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"需付款:¥ %.2f", _goodsDetailsModel.goodsStorePrice];
            }else {//否者吧要付的金额减去优惠券金额
            _totalPriceView.priceLabel.text = [NSString stringWithFormat:@"需付款:¥ %.2f", _goodsDetailsModel.goodsStorePrice-couponsAmounte];
            }
        }
        cell.model = self.goodsDetailsModel;
        return cell;
    }else if(indexPath.section == 1){
        ConfirmBuyersTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmBuyersTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (IdNum.length != 0) {
            cell.showBtnTwo.hidden = YES;
            cell.noRealLabel.hidden = YES;
            cell.realNameLabel.text = [NSString stringWithFormat:@"姓  名:%@",realName];
            cell.phoneLabel.text =[NSString stringWithFormat:@"手机号:%@", phone];
            cell.IdNumberLabel.text =[NSString stringWithFormat:@"身份证:%@", IdNum];
        }
        return cell;
    }else  {
        CouponChooseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponChooseTVCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleNameLabel.text = @"付款方式";
            cell.ContentNameLabel.text = [TermsPayment isEqualToString:@"1"]?@"全款":@"首款";
        }
        if (indexPath.row == 1) {
            cell.titleNameLabel.text = @"优惠券";
            if (_goodsDetailsModel.goodsStorePrice<couponsAmounte) {
                cell.ContentNameLabel.text = @"优惠券金额大于实付金额";
            }else {
                NSLog(@"couponsID%@", couponMemberId);
                  cell.ContentNameLabel.text = couponMemberId.length == 0?@"你还没有优惠券":[NSString stringWithFormat:@"优惠金额%ld", (long)couponsAmounte];
            }
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak  ConfirmOrderVC *self_VC = self;
    if (indexPath.section == 1) {
        UserBaseInfoViewController *VC = [[UserBaseInfoViewController alloc] initWithNibName:@"UserBaseInfoViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            CouponListViewController *VC = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
            VC.type = @"1";
            NSLog(@"firstMoney%@", firstMoney);
            VC.payAmount = _goodsDetailsModel.goodsStorePrice;
             VC.obtainCoupons = ^(NSString *couponsID, NSInteger amount,NSString *type) {
                NSLog(@"couponsID%@ amount%d type%@", couponsID, amount, type);
                couponMemberId = couponsID;
                couponsAmounte = amount;
                couponsType = type;
                [self_VC.tableView reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"" message:@"请选择付款方式" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"全款" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                couponsAmounte = 0;
                couponMemberId = @"";
                couponsType = @"";
                TermsPayment = @"1";
                firstMoney= @"";
                [self_VC.tableView reloadData];
            }];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"首款" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self_VC respondsToSelector:@selector(indeterminateExample)];
                couponsAmounte = 0;
                couponMemberId = @"";
                couponsType = @"";
                TermsPayment = @"0";
                NSString *URL_Str = [NSString stringWithFormat:@"%@/store/api/getFirstAmount",kURL_SHY];
                NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
                URL_Dic[@"schoolId"] = [UserDataSingleton mainSingleton].kStoreId;
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"uploadProgress%@", uploadProgress);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject%@", responseObject);
                    [self_VC respondsToSelector:@selector(delayMethod)];
                    NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
                    if ([resultStr isEqualToString:@"1"]) {
                        
                        NSArray *dataArray =responseObject[@"data"];
                        if (dataArray.count !=0) {
                            firstMoney=[NSString stringWithFormat:@"%@",  dataArray[0]];
                            [self_VC.tableView reloadData];
                        }
                    }else {
                        [self_VC showAlert:responseObject[@"msg"] time:1.2];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self_VC respondsToSelector:@selector(delayMethod)];
                    [self_VC showAlert:@"网络超时,请重试!" time:1.0];
                }];
                
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
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
@end
