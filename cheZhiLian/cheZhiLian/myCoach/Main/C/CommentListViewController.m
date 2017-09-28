//
//  CommentListViewController.m
//  guangda_student
//
//  Created by guok on 15/5/28.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "CommentListViewController.h"
#import "DSPullToRefreshManager.h"
#import "DSBottomPullToMoreManager.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface CommentListViewController ()<DSPullToRefreshManagerClient, DSBottomPullToMoreManagerClient> {
    int _curPage;
    int _searchPage;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (assign, nonatomic) int count;//总条数
@property (strong, nonatomic) DSPullToRefreshManager *pullToRefresh;    // 下拉刷新
@property (strong, nonatomic) DSBottomPullToMoreManager *pullToMore;    // 上拉加载

@end

@implementation CommentListViewController
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
    
    self.pullToRefresh = [[DSPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0 tableView:self.tableView withClient:self];
    
    //加载更多
    self.pullToMore = [[DSBottomPullToMoreManager alloc] initWithPullToMoreViewHeight:60.0 tableView:self.tableView withClient:self];
    
    [self pullToRefreshTriggered:self.pullToRefresh];
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
    if (self.type == 1) {
       
    }
    else {
       
    }
}

/* 加载更多 */
- (void)bottomPullToMoreTriggered:(DSBottomPullToMoreManager *)manager {
    _searchPage = _curPage + 1;
    if (self.type == 1) {
       
    }
    else {
       
    }
}

#pragma mark - 网络请求

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
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
    
        if (self.type == 1) {
        cell.type = CommentCellTypeUniversal;
    } else {
        cell.type = CommentCellTypePersonal;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}

@end
