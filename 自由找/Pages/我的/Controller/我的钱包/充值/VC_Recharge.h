//
//  VC_Recharge.h
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Recharge : VC_Base

@property (weak, nonatomic) IBOutlet UITextField *tf_money;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
- (IBAction)btn_next_pressed:(id)sender;
@end
