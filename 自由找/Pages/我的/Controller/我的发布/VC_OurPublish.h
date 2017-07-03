//
//  VC_OurPublish.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_OurPublish.h"
#import "Cell_OurPublisLetterPerform.h"

@interface VC_OurPublish : VC_Base<UITableViewDelegate, UITableViewDataSource, OurPublishClickDelegate, OurPublisLetterPerformClickDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@property (weak, nonatomic) IBOutlet UIImageView *image_none;
@end
