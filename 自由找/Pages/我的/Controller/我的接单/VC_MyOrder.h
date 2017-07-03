//
//  VC_MyOrder.h
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_MyOrder.h"
@interface VC_MyOrder : VC_Base<MyOrderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_toast;
@property (weak, nonatomic) IBOutlet UILabel *lb_toast;
@property (weak, nonatomic) IBOutlet UIButton *btn_toast;
@property (weak, nonatomic) IBOutlet UIButton *btn_toast_budget;
- (IBAction)btn_toast_pressed:(id)sender;
- (IBAction)btn_toastBudget_pressed:(id)sender;
@end
