//
//  VC_MineOrders.h
//  自由找
//
//  Created by xiaoqi on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_MineOrders : VC_Base
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_toast;
@property (weak, nonatomic) IBOutlet UILabel *lb_toast;
@property (weak, nonatomic) IBOutlet UIButton *btn_toast_technology;
@property (weak, nonatomic) IBOutlet UIButton *btn_toast_budget;
- (IBAction)btn_toastTechnology_pressed:(id)sender;
- (IBAction)btn_toastBudge_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_toast_letter;
- (IBAction)btn_toastLetter_pressed:(id)sender;
@end
