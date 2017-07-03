//
//  VC_FindLetterCompany.h
//  zyz
//
//  Created by 郭界 on 17/1/9.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_FindLetterCompany : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lb_scope;
- (IBAction)btn_scope_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
- (IBAction)btn_type_pressed:(id)sender;

@end
