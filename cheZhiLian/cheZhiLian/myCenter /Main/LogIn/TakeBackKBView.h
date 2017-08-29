//
//  TakeBackKBView.h
//  EntityConvenient
//
//  Created by 石山岭 on 2016/12/19.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakeBackKBViewDelegate <NSObject>

- (void)CancelKeyboard;

@end

/**
 *模仿京东键盘上方的回收键盘的view;
 */
@interface TakeBackKBView : UIView

@property (nonatomic, assign)id<TakeBackKBViewDelegate>delegate;

@end
