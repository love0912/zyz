//
//  VC_Choice.h
//  自由找
//
//  Created by guojie on 16/7/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^ChoiceBlock)(NSDictionary *resultDic);

@interface VC_Choice : VC_Base<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ChoiceBlock choiceBlock;

@property (nonatomic, strong) NSMutableArray *arr_data;

@property (nonatomic, strong) NSString *nav_title;

/**
 *  0 -- 直接选择， 1 -- 提示一次, 3 -- 不返回
 */
@property (nonatomic, strong) NSString *type;

- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray;

@end
