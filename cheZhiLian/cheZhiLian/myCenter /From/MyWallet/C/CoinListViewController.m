//
//  CoinListViewController.m
//  guangda_student
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CoinListViewController.h"
#import "CoinListTableViewCell.h"
#import "UseRuleViewController.h"
#import <CoreText/CoreText.h>

#define ITEM_HEIGHT 48

@interface CoinListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    int _curPage;
    int _searchPage;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTableview;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *totalCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fCoinSumLabel; // 冻结学车币
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopSpace;


// 学车币可用对象列表
@property (weak, nonatomic) IBOutlet UIView *ownerListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ownerListViewHeightCon;

// 页面数据
@property (strong, nonatomic) NSArray *ownerArray; // 学车币限用对象列表
@property (strong, nonatomic) NSMutableArray *coinsArray;

@end

@implementation CoinListViewController

- (IBAction)handleReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    
    NSString *coinsum = self.coinSum;
    NSString *coinStr = [NSString stringWithFormat:@"%@ 个", coinsum];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:coinStr];
    [string3 addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:32] range:NSMakeRange(0,coinsum.length)];
    [string3 addAttribute:NSForegroundColorAttributeName value:MColor(246, 102, 93) range:NSMakeRange(0,coinsum.length)];
    self.totalCoinLabel.attributedText = string3;
    self.fCoinSumLabel.text = [NSString stringWithFormat:@"(冻结数额: %@个)", self.fCoinSum];
    
    [self postGetOwnerList];
}

- (void)ownerListViewConfig {
    int count = (int)self.ownerArray.count;
    if (count) {
        self.ownerListView.hidden = NO;
    } else {
        self.ownerListView.hidden = YES;
    }
    
    for (int i = 0; i < count; i++) {
        NSDictionary *dict = self.ownerArray[i];
        UIView *item = nil;
        if (i == count - 1) { // 最后一行不需要分隔线
            item = [self ownerItemCreate:dict index:i needLine:NO];
        } else {
            item = [self ownerItemCreate:dict index:i needLine:YES];
        }
        [self.ownerListView addSubview:item];
    }
    self.ownerListViewHeightCon.constant = ITEM_HEIGHT * count;
    
    self.headView.frame = CGRectMake(0, 64, kScreen_widht, 119 + self.ownerListViewHeightCon.constant);
    [self.view addSubview:self.headView];
    self.contentViewTopSpace.constant = self.headView.height;
}

- (UIView *)ownerItemCreate:(NSDictionary *)dict index:(int)index needLine:(BOOL)need {
    UIView *itemView = [[UIView alloc] init];
    CGFloat itemViewW = kScreen_widht;
    CGFloat itemViewH = ITEM_HEIGHT;
    CGFloat itemViewX = 0;
    CGFloat itemViewY = itemViewH * index;
    itemView.frame = CGRectMake(itemViewX, itemViewY, itemViewW, itemViewH);
    itemView.backgroundColor = [UIColor clearColor];
    
    // 学车币个数
    UILabel *numLabel = [[UILabel alloc] init];
    [itemView addSubview:numLabel];
    CGFloat numLabelW = 59;
    CGFloat numLabelH = itemViewH;
    CGFloat numLabelX = 24;
    CGFloat numLabelY = 0;
    numLabel.frame = CGRectMake(numLabelX, numLabelY, numLabelW, numLabelH);
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:16];
    NSString *num = [dict[@"coin"] description];
    NSString *numTxet = [NSString stringWithFormat:@"%@个", num];
    NSMutableAttributedString *numStr = [[NSMutableAttributedString alloc] initWithString:numTxet];
    [numStr addAttribute:NSForegroundColorAttributeName value:MColor(246, 102, 93) range:NSMakeRange(0, num.length)];
    [numStr addAttribute:NSForegroundColorAttributeName value:MColor(78, 78, 78) range:NSMakeRange(num.length, 1)];
    numLabel.attributedText = numStr;
    
    // 限用对象
    UILabel *desLabel = [[UILabel alloc] init];
    [itemView addSubview:desLabel];
    CGFloat desLabelX = CGRectGetMaxX(numLabel.frame) + 25;
    CGFloat desLabelY = 0;
    CGFloat desLabelW = kScreen_widht - desLabelX - 10;
    CGFloat desLabelH = numLabelH;
    desLabel.frame = CGRectMake(desLabelX, desLabelY, desLabelW, desLabelH);
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.font = [UIFont systemFontOfSize:15];
    desLabel.textColor = MColor(78, 78, 78);
    desLabel.text = dict[@"msg"];
    
    // 分隔线
    if (need) {
        UIView *line = [[UIView alloc] init];
        [itemView addSubview:line];
        CGFloat lineX = numLabelX;
        CGFloat lineY = ITEM_HEIGHT - 1;
        CGFloat lineW = kScreen_widht - lineX - 10;
        CGFloat lineH = 1;
        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        line.backgroundColor = MColor(223, 223, 223);
    }
    
    return itemView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"CoinListTableViewCell";
    CoinListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CoinListTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadData];
    return cell;
}

#pragma mark - 网络请求
// 获取学车币可用对象列表
- (void)postGetOwnerList {
   

}


// 获取学车币明细列表
- (void)postGetCoinList {
   
}

#pragma mark - Action
- (IBAction)useRule:(id)sender {
    UseRuleViewController *viewcontroller = [[UseRuleViewController alloc]initWithNibName:@"UseRuleViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}


@end
