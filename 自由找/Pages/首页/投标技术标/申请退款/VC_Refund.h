//
//  VC_Refund.h
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Refund : VC_Base<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lb_tv_tips;
- (IBAction)btn_commit_pressed:(id)sender;
@end
