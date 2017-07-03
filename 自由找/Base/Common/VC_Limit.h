//
//  VC_Limit.h
//  自由找
//
//  Created by guojie on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "VC_Quality.h"

@interface VC_Limit : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) VC_Quality *delegate;

@property (strong, nonatomic) NSString *topKey;

@property (strong, nonatomic) NSMutableDictionary *dataDic;

@property (strong, nonatomic) NSString *selectKey;

- (void)setDataDic:(NSDictionary *)dataDic selectKey:(NSString *)selectKey delegate:(id)delegate;

@end
