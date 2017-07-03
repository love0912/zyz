//
//  VC_Letter_Bid_New.h
//  zyz
//
//  Created by 郭界 on 16/11/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "DOPDropDownMenu.h"
#import "Cell_Letter_Bid_New.h"

@interface VC_Letter_Bid_New : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *v_menuBack;
@property (strong, nonatomic) DOPDropDownMenu *dropDownMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_region;
@property (weak, nonatomic) IBOutlet UILabel *lb_bank;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
- (IBAction)btn_region_pressed:(id)sender;
- (IBAction)btn_bank_pressed:(id)sender;
- (IBAction)btn_type_pressed:(id)sender;
@end
