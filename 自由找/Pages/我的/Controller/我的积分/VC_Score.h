//
//  VC_Score.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Score : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *v_header;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_score_top;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_back_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_score;
@end
