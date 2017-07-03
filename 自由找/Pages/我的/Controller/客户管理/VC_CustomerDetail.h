//
//  VC_CustomerDetail.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_CustomerDetail : VC_Base<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *CustomerId;

@property (strong, nonatomic) NSString *Phone;

- (IBAction)btn_delete_pressed:(id)sender;

- (IBAction)btn_call_pressed:(id)sender;
- (IBAction)btn_edit_pressed:(id)sender;

@end
