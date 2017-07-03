//
//  VC_RefundResult.h
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_RefundResult : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_tag;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@end
