//
//  VC_APList.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^APListChoiceBlock)(NSArray *resultArray);

@interface VC_APList : VC_Base<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_tips;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;

- (IBAction)btn_add_pressed:(id)sender;

@property (strong, nonatomic) NSMutableArray *arr_quality;

@property (nonatomic, strong) APListChoiceBlock multiQuality;
@end
