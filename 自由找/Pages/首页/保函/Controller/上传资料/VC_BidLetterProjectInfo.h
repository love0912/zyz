//
//  VC_BidLetterProjectInfo.h
//  zyz
//
//  Created by 郭界 on 16/11/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_BidLetterProjectInfo : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_next_pressed:(id)sender;
@end
