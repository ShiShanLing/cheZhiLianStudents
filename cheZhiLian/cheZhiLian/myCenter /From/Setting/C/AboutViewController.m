//
//  AboutViewController.m
//  guangda_student
//
//  Created by 吴筠秋 on 15/3/30.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (strong, nonatomic) IBOutlet UIButton *tipBtn;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipBtn.layer.cornerRadius = 3;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *VersionText = [NSString stringWithFormat:@"版本%@",app_Version];
    self.versionLabel.text = VersionText;
    
    // icon
    self.icon.layer.cornerRadius = 15;
    self.icon.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
