//
//  VC_ChoiceIndex.h
//  zyz
//
//  Created by 郭界 on 17/1/17.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^ChoiceBlock)(NSDictionary *resultDic);

@interface VC_ChoiceIndex : VC_Base<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ChoiceBlock choiceBlock;

@property (nonatomic, strong) NSString *nav_title;

/**
 *  0 -- 直接选择， 1 -- 提示一次, 3 -- 不返回
 */
@property (nonatomic, strong) NSString *type;

- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray;

@end
