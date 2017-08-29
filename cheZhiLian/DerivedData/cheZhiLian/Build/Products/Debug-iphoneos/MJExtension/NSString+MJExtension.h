//
//  NSString+MJExtension.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConst.h"

@interface NSString (MJExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *mj_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *mj_camelFromUnderline;
/**
 * 首字母变大写
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *mj_firstCharUpper;
/**
 * 首字母变小写
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *mj_firstCharLower;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL mj_isPureInt;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *mj_url;
@end

@interface NSString (MJExtensionDeprecated_v_2_5_16)
- (NSString *)underlineFromCamel MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSString *)camelFromUnderline MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSString *)firstCharUpper MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSString *)firstCharLower MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (BOOL)isPureInt MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSURL *)url MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
@end
