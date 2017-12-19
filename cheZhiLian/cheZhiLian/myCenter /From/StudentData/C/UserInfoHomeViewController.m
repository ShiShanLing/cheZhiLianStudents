//
//  UserInfoHomeViewController.m
//  guangda
//
//  Created by duanjycc on 15/3/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "UserInfoHomeViewController.h"
#import "UserBaseInfoViewController.h"
#import "LearnDriveInfoViewController.h"
#import "ImproveInfoViewController.h"
#import "CZPhotoPickerController.h"
#import "UIImageView+WebCache.h"
#import "TQStarRatingView.h"
#import "LoginViewController.h"

@interface UserInfoHomeViewController () <UIImagePickerControllerDelegate, StarRatingViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) TQStarRatingView *userStarView;

// 拍照，相册
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (nonatomic, strong) CZPhotoPickerController *pickPhotoController;
@property (strong, nonatomic) UIImageView *clickImageView;//需要显示图片的imageview

- (IBAction)clickForChangePortrait:(id)sender;
- (IBAction)clickForCancelPortraitChange:(id)sender;
- (IBAction)clickForCamera:(id)sender; // 相机
- (IBAction)clickForAlbum:(id)sender; // 相册

- (IBAction)clickToUserBaseInfoView:(id)sender;
- (IBAction)clickToLearnDriveInfoView:(id)sender;
- (IBAction)clickToImproveUserInfoView:(id)sender;

@end

@implementation UserInfoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self showData];
}
-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
                                         
                                         
#pragma mark - 页面设置
- (void)settingView {
    self.clickImageView = [[UIImageView alloc] init];

    // 设置头像为圆形
    self.portraitImageView.layer.cornerRadius = self.portraitImageView.bounds.size.height/2;
    self.portraitImageView.layer.masksToBounds = YES;
    
    // 学员评分
    self.userStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(82, 46, 93, 17) numberOfStar:5];
    self.userStarView.couldClick = NO;
    self.userStarView.delegate = self;
    [self.userView addSubview:self.userStarView];
}

// 显示数据
- (void)showData {
    [self loadLocalData];
    self.nameField.text = _realname;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:_avatar] placeholderImage:[UIImage imageNamed:@"login_icon"]];
     [self.userStarView changeStarForegroundViewWithScore:self.score];
}

#pragma mark - photo
- (CZPhotoPickerController *)photoController {
    __weak typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        
        if (imagePickerController == nil || imageInfoDict == nil) {
            return;
        }
        UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
        if(!image)
            image = imageInfoDict[UIImagePickerControllerOriginalImage];
        image = [CommonUtil scaleImage:image minLength:1200];
        
        [self postChangeAvatar:image];
        
        self.photoView.hidden = YES;
    }];
}

#pragma mark - 网络请求
// 上传头像
- (void)postChangeAvatar:(UIImage *)image {
    
}

- (void) backLogin{
 
}

#pragma mark - 数据处理
// 取得输入数据
- (void)catchInputData {
}

// 数据本地化
- (void)locateData {
    [self emptyDataFun];
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    NSMutableDictionary *new_user_info = [NSMutableDictionary dictionaryWithDictionary:user_info];
    [new_user_info setObject:_avatar forKey:@"avatarurl"];
    [CommonUtil saveObjectToUD:new_user_info key:@"UserInfo"];
}

// 加载本地数据
- (void)loadLocalData {
    NSDictionary *user_info = [CommonUtil getObjectFromUD:@"UserInfo"];
    _avatar = [user_info objectForKey:@"avatarurl"];
    _realname = [user_info objectForKey:@"realname"];
    self.score = [[user_info objectForKey:@"score"] floatValue];
}

// 空数据处理
- (void)emptyDataFun {
    if ([CommonUtil isEmpty:_avatar]) {
        _avatar = @"";
    }
}

#pragma mark - 点击事件
- (IBAction)clickForChangePortrait:(id)sender {
    self.photoView.hidden = NO;
}

- (IBAction)clickForCancelPortraitChange:(id)sender {
    self.photoView.hidden = YES;
}

// 拍照
- (IBAction)clickForCamera:(id)sender {
    self.photoView.hidden = YES;
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.allowsEditing = YES;
    self.pickPhotoController.saveToCameraRoll = NO;
    if ([CZPhotoPickerController canTakePhoto]) {
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

// 相册
- (IBAction)clickForAlbum:(id)sender {
    self.photoView.hidden = YES;
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.saveToCameraRoll = NO;
    self.pickPhotoController.allowsEditing = YES;
    if ([CZPhotoPickerController canTakePhoto]) {
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (IBAction)clickToUserBaseInfoView:(id)sender {
    UserBaseInfoViewController *targetViewController = [[UserBaseInfoViewController alloc] initWithNibName:@"UserBaseInfoViewController" bundle:nil];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (IBAction)clickToLearnDriveInfoView:(id)sender {
    LearnDriveInfoViewController *targetViewController = [[LearnDriveInfoViewController alloc] initWithNibName:@"LearnDriveInfoViewController" bundle:nil];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (IBAction)clickToImproveUserInfoView:(id)sender {
    ImproveInfoViewController *targetViewController = [[ImproveInfoViewController alloc] initWithNibName:@"ImproveInfoViewController" bundle:nil];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (IBAction)handleLogOut:(UIButton *)sender {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [userData  removeAllObjects];
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
    //输入写入
    [userData writeToFile:filename atomically:YES];
    [UserDataSingleton mainSingleton].studentsId = @"";
    [UserDataSingleton mainSingleton].subState = @"";
    [UserDataSingleton mainSingleton].subState = @"20";
    [UserDataSingleton mainSingleton].coachId = @"";
    [UserDataSingleton mainSingleton].balance = @"";
    [UserDataSingleton mainSingleton].userModel =nil;
    [self showAlert:@"退出登录成功" time:1.2];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"UserInfoHomeView  dealloc");
}

@end
