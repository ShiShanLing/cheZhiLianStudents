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
    [self AnalysisUserData];
}
-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
                                         
                                         
#pragma mark - 页面设置
- (void)settingView {
    self.clickImageView = [[UIImageView alloc] init];
  self.photoView.frame  =[UIScreen mainScreen].bounds;
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
        
        [self uploadLogo:image];
        
        self.photoView.hidden = YES;
    }];
}



//上传头像
- (void)uploadLogo:(UIImage *)image{
    [self respondsToSelector:@selector(indeterminateExample)];
    NSString *URL_Str = [NSString stringWithFormat:@"%@/floor/api/fileUpload", kURL_SHY];
    //carownerapi/ save_carowner
    AFHTTPSessionManager * managerOne = [AFHTTPSessionManager manager];
    
    managerOne.requestSerializer.HTTPShouldHandleCookies = YES;
    
    managerOne.requestSerializer  = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    managerOne.responseSerializer = [AFJSONResponseSerializer serializer];
    [managerOne.requestSerializer setTimeoutInterval:20.0];
    
    //把版本号信息传导请求头中
    [managerOne.requestSerializer setValue:[NSString stringWithFormat:@"iOS-%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"MM-Version"];
    
    [managerOne.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    managerOne.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    __weak UserInfoHomeViewController *VC  = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [managerOne POST:URL_Str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSData *picData = UIImageJPEGRepresentation(image, 0.5);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png", @"id_card_front"];
        [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"file"]
                                fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            NSArray *dataArray = responseObject[@"data"];
            NSDictionary *dataDic =dataArray[0];
            NSString *image_URL = dataDic[@"URL"];
            NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/setHeadImage", kURL_SHY];
            NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
            URL_Dic[@"stuId"] = [UserDataSingleton mainSingleton].studentsId;;
            URL_Dic[@"url"] = image_URL;
            [managerOne POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"uploadProgress%@", uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject%@", responseObject);
                NSString *resultStr1 = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
                if ([resultStr1 isEqualToString:@"1"]){
                    VC.avatar = image_URL;
                    [VC.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURL_Image, image_URL]] placeholderImage:[UIImage imageNamed:@"icon_portrait_default"]];
                    [VC showAlert:@"更改成功" time:1.2];
                    [VC AnalysisUserData];
                }else {
                    [VC showAlert:responseObject[@"msg"] time:1.2];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [VC showAlert:@"更改头像网络出错!" time:1.2];
                NSLog(@"error%@", error);
            }];
        }else{
            [VC showAlert:@"图片上传失败" time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error%@", error);
        [VC showAlert:@"上传图片网络出错!" time:1.2];
        
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
    [self.view addSubview: self.photoView ];
}

- (IBAction)clickForCancelPortraitChange:(id)sender {
     [self.photoView removeFromSuperview];
}


// 拍照
- (IBAction)clickForCamera:(id)sender {
    [self.photoView removeFromSuperview];
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.allowsEditing = YES;
    self.pickPhotoController.saveToCameraRoll = NO;
    if ([CZPhotoPickerController canTakePhoto]) {
        [self.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}
// 相册
- (IBAction)clickForAlbum:(id)sender {
    [self.photoView removeFromSuperview];
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
    [self showAlert:@"该功能正在努力开发中" time:0.8 ] ;
    return;
    LearnDriveInfoViewController *targetViewController = [[LearnDriveInfoViewController alloc] initWithNibName:@"LearnDriveInfoViewController" bundle:nil];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (IBAction)clickToImproveUserInfoView:(id)sender {
    [self showAlert:@"该功能正在努力开发中" time:0.8 ] ;
    return;
    ImproveInfoViewController *targetViewController = [[ImproveInfoViewController alloc] initWithNibName:@"ImproveInfoViewController" bundle:nil];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (IBAction)handleLogOut:(UIButton *)sender {

}

- (void)dealloc {
    NSLog(@"UserInfoHomeView  dealloc");
}


- (void)AnalysisUserData{
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] =[UserDataSingleton mainSingleton].studentsId;
    NSLog(@"URL_Dic%@", URL_Dic);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __block UserInfoHomeViewController *VC = self;
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        
        if ([resultStr isEqualToString:@"0"]) {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }else {
            [VC AnalyticalData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [VC showAlert:@"请求失败请重试" time:1.0];
    }];
}
//解析的用户详情的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    NSEntityDescription *des = [NSEntityDescription entityForName:@"UserDataModel" inManagedObjectContext:self.managedContext];
    //根据描述 创建实体对象
    UserDataModel *model = [[UserDataModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *urseDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData removeAllObjects];
        for (NSString *key in urseDataDic) {
            if ([key isEqualToString:@"subState"]) {
                [UserDataSingleton mainSingleton].subState =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"stuId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"state"]) {
                
                [UserDataSingleton mainSingleton].state = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"balance"]) {
                [UserDataSingleton mainSingleton].balance = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            //    NSLog(@"key%@",key);
            [userData setObject:urseDataDic[key] forKey:key];
            [model setValue:urseDataDic[key] forKey:key];
        }
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
        //输入写入
        [userData writeToFile:filename atomically:YES];
        //那怎么证明我的数据写入了呢？读出来看看
        NSMutableDictionary *userData2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURL_Image, model.avatar]] placeholderImage:[UIImage imageNamed:@"icon_portrait_default"]];
    
}


@end
