//
//  TotalPriceView.h
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TotalPriceViewDelegate <NSObject>

-(void)SubmitOrders;

@end

@interface TotalPriceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


/**
 *
 */
@property (nonatomic, weak)id<TotalPriceViewDelegate>delegate;

@property (nonatomic,copy) void(^SubmitOrders)();

@end
