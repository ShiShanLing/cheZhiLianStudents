//
//  UserDataSingleton.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/17.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject
+ (UserDataSingleton *)mainSingleton;

@property (nonatomic, copy)NSString *subState;
//暂时不知道是什么 随后更新
@property (nonatomic, copy)NSString *state;
@property (nonatomic, copy)NSString *studentsId;
@property (nonatomic, copy)NSString *coachId;
/**
 *账户余额
 */
@property (nonatomic, copy)NSString *balance;
@end
