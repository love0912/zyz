//
//  VC_Tech_Order.h
//  自由找
//
//  Created by guojie on 16/7/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "DOPDropDownMenu.h"
#import "Cell_Tech_SearchOrder.h"
@interface VC_Tech_Order : VC_Base<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate,SearchOrderDelegate,UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DOPDropDownMenu *dropDownMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_bottom_back;
@property (strong, nonatomic) UIImageView *iv_headerView;

/**
 *  1 -- 技术标接单, 2 -- 投标预算标接单
 */
@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSInteger pushType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableView_top;
@end
