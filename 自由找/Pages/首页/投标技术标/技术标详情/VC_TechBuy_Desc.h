//
//  VC_TechBuy_Desc.h
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_Evaluate.h"

@interface VC_TechBuy_Desc : VC_Base<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, EvaluateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)btn_ordering_pressed:(id)sender;

@end
