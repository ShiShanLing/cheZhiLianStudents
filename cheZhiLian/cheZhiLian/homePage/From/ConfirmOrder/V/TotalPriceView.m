//
//  TotalPriceView.m
//  cheZhiLian
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "TotalPriceView.h"

@implementation TotalPriceView


- (IBAction)handleSubmitOrders:(id)sender {
    self.SubmitOrders();
    if ([_delegate respondsToSelector:@selector(SubmitOrders)]) {
        [_delegate SubmitOrders];
    }
    
}

@end
