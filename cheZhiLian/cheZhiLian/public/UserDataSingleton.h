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
@property (nonatomic, copy)NSString *studentsId;
@property (nonatomic, copy)NSString *memberId;
@property (nonatomic, copy)NSString *coachId;
@end
