//
//  VC_ViewCompany.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_ViewCompany.h"

@interface VC_ViewCompany : VC_Base<UITableViewDelegate, UITableViewDataSource, ViewCompanyClickDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_top;

@property (weak, nonatomic) IBOutlet UIView *v_new;
@property (weak, nonatomic) IBOutlet UIView *v_agree;
@property (weak, nonatomic) IBOutlet UIView *v_disagree;
@property (weak, nonatomic) IBOutlet UIView *v_return;
@property (weak, nonatomic) IBOutlet UILabel *lb_new;
@property (weak, nonatomic) IBOutlet UILabel *lb_agree;
@property (weak, nonatomic) IBOutlet UILabel *lb_disagree;
@property (weak, nonatomic) IBOutlet UILabel *lb_return;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_seperate_centerX;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
