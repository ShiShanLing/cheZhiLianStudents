//
//  FloorVIew.h
//  EntityConvenient
//
//  Created by 石山岭 on 2016/11/29.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FloorVIewDelegate <NSObject>


- (void)DataOrIntegral:(NSInteger)index;

@end


/**
 *用户信息展示view
 */
@interface FloorVIew : UIView

@property (nonatomic, strong)UILabel *nameLabel;//用户名
@property (nonatomic, strong)UIImageView *TextImage;//测试用
@property (nonatomic, assign)id<FloorVIewDelegate>delegate;
@end
