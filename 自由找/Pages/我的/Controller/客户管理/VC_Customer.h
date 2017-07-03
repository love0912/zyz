//
//  VC_Customer.h
//  自由找
//
//  Created by guojie on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Customer : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_tips;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips2;
- (IBAction)btn_add_pressed:(id)sender;


@end
