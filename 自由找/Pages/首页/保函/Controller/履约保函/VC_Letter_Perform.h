//
//  VC_Letter_Perform.h
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "DOPDropDownMenu.h"

@interface VC_Letter_Perform : VC_Base<UITableViewDelegate, UITableViewDataSource,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (strong, nonatomic) DOPDropDownMenu *dropDownMenu;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *v_menuBack;
- (IBAction)btn_release_pressed:(id)sender;
@end
