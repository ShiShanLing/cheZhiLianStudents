//
//  CoachDetailViewController.m
//  guangda_student
//
//  Created by Dino on 15/4/24.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CoachDetailViewController.h"
#import "TQStarRatingView.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommentListViewController.h"
#import "DSPullToRefreshManager.h"
#import "DSBottomPullToMoreManager.h"
#import "AppointCoachViewController.h"
#import "NoCoachView.h"
#define COACH_DETAILVIEW_HEIGHT 280
@interface CoachDetailViewController ()<DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient,UIScrollViewDelegate> {
    int _curPage;
    int _searchPage;
}

@property (strong, nonatomic) DSPullToRefreshManager *pullToRefresh;    // 下拉刷新
@property (strong, nonatomic) DSBottomPullToMoreManager *pullToMore;    // 上拉加载
/**
 *
 */
@property (nonatomic, strong)NoCoachView * noCoachView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIView *coachInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCon;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderViewWidthCon;
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;
@property (weak, nonatomic) IBOutlet UIImageView *starcoachIcon;
@property (strong, nonatomic) TQStarRatingView *starView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *appointBtn;
/* courseView内部控件的屏幕适配 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con4;

@property (weak, nonatomic) IBOutlet UIView *freeCourseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseViewHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *commentSelfLabel;
@property (assign, nonatomic) int studentNum; // 评论人数
@property (assign, nonatomic) int count; // 总条数
@property (strong, nonatomic) NSString *phone;//教练电话

//教练详情页广告
@property (strong, nonatomic) IBOutlet UIScrollView *ADScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *ADBottomView;
@property (strong,nonatomic) NSTimer *timer;
@property (nonatomic) int ADIndex;
@property (strong,nonatomic) UIImageView *centerImageView;
@property (strong,nonatomic) UIImageView *leftImageView;
@property (strong,nonatomic) UIImageView *rightImageView;

// 页面数据
@property (strong, nonatomic) NSDictionary *coachInfoDict;
@property (strong, nonatomic) NSMutableArray *commentArray;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * coachDetailsArray;

@end

@implementation CoachDetailViewController

- (NSMutableArray *)coachDetailsArray {
    if (!_coachDetailsArray) {
        _coachDetailsArray = [NSMutableArray array];
    }
   return  _coachDetailsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];
    [self pullToRefreshTriggered:self.pullToRefresh];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"NoCoachView" owner:self options:nil];
    //得到第一个UIView
    self.noCoachView = [nib objectAtIndex:0];
    //获得屏幕的Frame
    self.noCoachView.frame = self.view.bounds;
   [self.view addSubview:_noCoachView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setHidesBottomBarWhenPushed:NO];
    [self requestGetAD];
    
    if ([UserDataSingleton mainSingleton].coachId.length == 0) {
        self.noCoachView.titleLabel.text =  @"您还没有分配教练!";
        self.noCoachView.hidden = NO;
    }else {
        
      self.noCoachView.hidden = YES;
    }
    self.navigationController.navigationBarHidden =YES;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewConfig {
    self.detailsView.frame = CGRectMake(0, 0, kScreen_widht, COACH_DETAILVIEW_HEIGHT);
    self.mainTableView.tableHeaderView = self.detailsView;
    self.appointBtn.layer.cornerRadius = 3;
    self.genderView.layer.cornerRadius = 2;
    // 头像
    self.portrait.layer.cornerRadius = self.portrait.width/2;
    self.portrait.layer.masksToBounds = YES;
    // 星级
    self.starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.name.x, 40, 58, 10)];
    [self.coachInfoView addSubview:self.starView];
    // 评分
    UILabel *scoreLabel = [[UILabel alloc] init];
    self.scoreLabel = scoreLabel;
    [self.coachInfoView addSubview:scoreLabel];
    scoreLabel.width = 30;
    scoreLabel.height = 12;
    scoreLabel.x = self.starView.right + 6;
    scoreLabel.centerY = self.starView.centerY;
    scoreLabel.font = [UIFont systemFontOfSize:10];
    scoreLabel.textColor = MColor(102, 102, 102);
    
    //刷新加载
    self.pullToRefresh = [[DSPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0 tableView:self.mainTableView withClient:self];
    self.pullToMore = [[DSBottomPullToMoreManager alloc] initWithPullToMoreViewHeight:60.0 tableView:self.mainTableView withClient:self];
    [self.pullToMore setPullToMoreViewVisible:NO]; //隐藏加载更多
    
    // 屏幕适配
    
    CGFloat ratio = kScreen_widht / 320.0;
    self.con1.constant *= ratio;
    self.con2.constant *= ratio;
    self.con3.constant *= ratio;
    self.con4.constant *= ratio;
}
//加载广告视图
-(void)loadADview{

}

#pragma mark - 接口请求
-(void)requestGetAD {
    

    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/myCoach", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];

    URL_Dic[@"coachId"] = [UserDataSingleton mainSingleton].coachId;
    NSLog(@"URL_Dic%@", URL_Dic);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak CoachDetailViewController *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [VC.pullToRefresh setPullToRefreshViewVisible:NO];
        [VC requestGetCoachDetail:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (void)requestGetCoachDetail:(NSArray *)dataArray {
    
    if (dataArray.count != 0) {
        for (NSDictionary *dataDic in dataArray) {
            NSEntityDescription *des = [NSEntityDescription entityForName:@"CoachDetailsModel" inManagedObjectContext:self.managedContext];
            //根据描述 创建实体对象
            CoachDetailsModel *model = [[CoachDetailsModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
            for (NSString *key in dataDic) {
                [model setValue:dataDic[key] forKey:key];
            }
            [self.coachDetailsArray addObject:model];
            [self showData:model];
        }
    }
    [self.mainTableView reloadData];
}

// 获取评论列表
-(void) getComments{
    
    
}

#pragma mark - DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pullToRefresh tableViewScrolled];
    
    [_pullToMore relocatePullToMoreView];    // 重置加载更多控件位置
    [_pullToMore tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pullToRefresh tableViewReleased];
    [_pullToMore tableViewReleased];
}

/* 刷新处理 */
- (void)pullToRefreshTriggered:(DSPullToRefreshManager *)manager {
    _curPage = 0;
    _searchPage = 0;
    [self getComments];
}

/* 加载更多 */
- (void)bottomPullToMoreTriggered:(DSBottomPullToMoreManager *)manager {
    _searchPage = _curPage + 1;
    [self getComments];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.coachDetailsArray.count == 0) {
        return 0;
    }else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indefinder = @"CommentTableViewCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefinder];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:indefinder];
        cell = [tableView dequeueReusableCellWithIdentifier:indefinder];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.avatar.layer.cornerRadius = 12.5;
    cell.avatar.layer.masksToBounds = YES;
    cell.avatar.image = [UIImage imageNamed:@"hashiqi"];
    cell.time.text = @"2017-08-17";
    cell.content.text =@"千年一遇的好教练,长得也很帅!";
    cell.nick.text = @"石山岭";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 34.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33.0, kScreen_widht, 1)];
    bottomLine.backgroundColor = MColor(223, 223, 223);
    [headerView.contentView addSubview:bottomLine];
    
    if(self.commentArray.count != 0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, kScreen_widht, headerView.height)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = MColor(153, 153, 153);
        label.text = @"该教练暂无评价～";
        [headerView.contentView addSubview:label];
    }
    else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 45, headerView.height)];
        [headerView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = MColor(153, 153, 153);
        titleLabel.text = @"学员评价";
        
        // 人数
        UILabel *countLabel = [[UILabel alloc] init];
        [headerView addSubview:countLabel];
        countLabel.width = 100;
        countLabel.height = headerView.height;
        countLabel.x = titleLabel.right + 3;
        countLabel.y = 0;
        countLabel.font = [UIFont systemFontOfSize:10];
        countLabel.textColor = MColor(170, 170, 170);
        countLabel.text = [NSString stringWithFormat:@"(%d人评论)", 12];
        
        // 箭头
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_widht - 20, 12, 5.5, 9)];
        arrow.image = [UIImage imageNamed:@"ic_arrow_right"];
        [headerView.contentView addSubview:arrow];
        
        // 共几条
        CGSize size = [CommonUtil sizeWithString:[NSString stringWithFormat:@"共%d条",12] fontSize:10.0 sizewidth:CGFLOAT_MAX sizeheight:25.0];
        UILabel *label = [[UILabel alloc] init];
        label.width = size.width;
        label.height = 12;
        label.right = arrow.left - 10;
        label.centerY = headerView.height / 2;
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = MColor(170, 170, 170);
        label.text = [NSString stringWithFormat:@"共%d条",12];
        [headerView.contentView addSubview:label];
    }
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [headerView addGestureRecognizer:singleRecognizer];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark - private
- (void)showData:(CoachDetailsModel *)model{
    {
        // 头像
        self.portrait.image = [UIImage imageNamed:@"hashiqi"];
        // 姓名
        self.name.text = model.realName;
        CGFloat nameStrWidth = [CommonUtil sizeWithString: @"石山岭" fontSize:16 sizewidth:150 sizeheight:20].width;
        self.nameWidthCon.constant = nameStrWidth;
        // 性别
        switch (1) {
            case 1:
                self.genderView.backgroundColor = MColor(120, 190, 245);
                self.genderIcon.image = [UIImage imageNamed:@"ic_male"];
                break;
            case 2:
                self.genderView.backgroundColor = MColor(245, 135, 176);
                self.genderIcon.image = [UIImage imageNamed:@"ic_female"];
                break;
            default:
                self.genderView.backgroundColor = MColor(120, 190, 245);
                self.genderIcon.image = [UIImage imageNamed:@"ic_male"];
                break;
        }
        // 年龄
        if ([CommonUtil isEmpty:@"23"]) {
            self.age.hidden = YES;
            self.genderViewWidthCon.constant = 12;
        } else {
            self.age.text = @"23";
            self.age.hidden = NO;
            self.genderViewWidthCon.constant = 26;
        }
    }
    // 明星教练
    int signState = 1;
    if (signState == 1) {
        self.starcoachIcon.hidden = NO;
    } else {
        self.starcoachIcon.hidden = YES;
    }
    // 评分
    CGFloat score = 5.0;
    [self.starView changeStarForegroundViewWithScore:score];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", score];
    
    // 预约次数
    NSString *count = model.reservationNum;
    self.countLabel.text = [NSString stringWithFormat:@"%@", count];
    self.countDesLabel.text = @"预约次数";
    // 准教车型
    self.carType.text = [NSString stringWithFormat:@"准教车型：%@", model.carTypeName];
    // 体验课
    self.ADBottomView.hidden = NO;
    self.pageControl.hidden = NO;
    NSInteger h = kScreen_widht/150*29;
    self.freeCourseView.hidden = NO;
    self.courseViewHeightCon.constant = 99;
    self.detailsView.height = COACH_DETAILVIEW_HEIGHT + h + 10;
    
    // 电话
    self.phone = model.phone;
    // 练车地址
    self.address.text = model.address;
    // 自我评价
    self.commentSelfLabel.text = @"自我感觉非常良好,让你欲罢不能!";
    
    self.mainTableView.tableHeaderView = self.detailsView;
}

- (NSString *)isEmpty:(NSString *)string
{
    if ([CommonUtil isEmpty:string]) {
        return @"暂无";
    }
    return string;
}

#pragma mark - 广告处理

-(void)action{
   
}

#pragma mark - 点击事件
- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)phoneCallClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *phoneNum = nil;
    
    if (button.tag == 0) {
        if (self.phone.length > 3) {
            
            
            phoneNum = [NSString stringWithFormat:@"telprompt:%@", self.phone];
        }else{
            [self makeToast:@"该教练暂无电话"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    }else{
        if (self.phone.length > 3) {
            phoneNum = [NSString stringWithFormat:@"sms://%@", self.phone];
        }else{
            [self makeToast:@"该教练暂无电话"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    }
}

- (IBAction)appointClick:(id)sender {
    NSLog(@"预约");
    AppointCoachViewController *nextController = [[AppointCoachViewController alloc] initWithNibName:@"AppointCoachViewController" bundle:nil];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:nextController];
    navigationController.navigationBarHidden = YES;
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)singleTap:(UITapGestureRecognizer*)recognizer
{
    CommentListViewController *nextController = [[CommentListViewController alloc] initWithNibName:@"CommentListViewController" bundle:nil];
    nextController.coachid = self.coachId;
    nextController.type = 1;
    [self.navigationController pushViewController:nextController animated:YES];
}
- (IBAction)leftItemClick:(id)sender {
    
  [self XYSideOpenVC];
}


@end
