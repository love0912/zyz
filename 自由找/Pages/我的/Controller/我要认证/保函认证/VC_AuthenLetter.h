//
//  VC_AuthenLetter.h
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_AuthenLetter : VC_Base<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_next_pressed:(id)sender;
@end
