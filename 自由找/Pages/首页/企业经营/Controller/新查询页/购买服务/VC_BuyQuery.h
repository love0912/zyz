//
//  VC_BuyQuery.h
//  zyz
//
//  Created by 郭界 on 17/1/11.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_BuyQuery : VC_Base

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lb_payMoney;
- (IBAction)btn_buy_pressed:(id)sender;
@end
