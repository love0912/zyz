//
//  VC_ReleaseLetterPerform.h
//  自由找
//
//  Created by 郭界 on 16/10/17.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ReleaseLetterPerform : VC_Base<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_commit_pressed:(id)sender;

@end
