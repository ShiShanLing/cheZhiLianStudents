//
//  LearnDriveInfoViewController.h
//  guangda_student
//
//  Created by duanjycc on 15/3/27.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"

typedef enum {
    idCardFront = 1, // 身份证正面
    idCardBack,
    licenseFront,   // 学员证正面
    licenseBack
} photoType;

@interface LearnDriveInfoViewController : GreyTopViewController

// 学员证号
@property (strong, nonatomic) IBOutlet UITextField *stuCardIdField;
@property (strong, nonatomic) IBOutlet UIImageView *stuCardIdPencilImage;
@property (copy, nonatomic) NSString *student_cardnum;

// 制证时间
@property (strong, nonatomic) IBOutlet UITextField *madeTimeField;
@property (copy, nonatomic) NSString *student_card_creat;

// 身份证号码
@property (strong, nonatomic) IBOutlet UITextField *idCardField;
@property (strong, nonatomic) IBOutlet UIImageView *idCardPencilImage;
@property (copy, nonatomic) NSString *id_cardnum;

// 身份证正面照
@property (strong, nonatomic) IBOutlet UIImageView *idCardFrontImageView;
@property (strong, nonatomic) IBOutlet UIButton *idCardFrontBtn;
@property (strong, nonatomic) IBOutlet UIView *idCardFrontView;
@property (strong, nonatomic) IBOutlet UILabel *idCardFrontLabel;
@property (copy, nonatomic) NSString *id_cardpicfurl;

// 身份证反面照
@property (strong, nonatomic) IBOutlet UIImageView *idCardBackImageView;
@property (strong, nonatomic) IBOutlet UIButton *idCardBackBtn;
@property (strong, nonatomic) IBOutlet UIView *idCardBackView;
@property (strong, nonatomic) IBOutlet UILabel *idCardBackLabel;
@property (copy, nonatomic) NSString *id_cardpicburl;

// 学员证或驾驶证正面照
@property (strong, nonatomic) IBOutlet UIImageView *licenseFrontImageView;
@property (strong, nonatomic) IBOutlet UIButton *licenseFrontBtn;
@property (strong, nonatomic) IBOutlet UIView *licenseFrontView;
@property (strong, nonatomic) IBOutlet UILabel *licenseFrontLabel;
@property (copy, nonatomic) NSString *student_cardpicfurl;


// 学员证或驾驶证反面照
@property (strong, nonatomic) IBOutlet UIImageView *licenseBackImageView;
@property (strong, nonatomic) IBOutlet UIButton *licenseBackBtn;
@property (strong, nonatomic) IBOutlet UIView *licenseBackView;
@property (strong, nonatomic) IBOutlet UILabel *licenseBackLabel;
@property (copy, nonatomic) NSString *student_cardpicburl;

// 拍照
@property (strong, nonatomic) IBOutlet UIView *photoView;

// 是否可以 跳过
@property (strong, nonatomic) NSString *isSkip;
@end
