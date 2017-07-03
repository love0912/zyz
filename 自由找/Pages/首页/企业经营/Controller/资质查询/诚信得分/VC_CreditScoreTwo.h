//
//  VC_CreditScoreTwo.h
//  自由找
//
//  Created by xiaoqi on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_CreditScoreTwo.h"
typedef void(^ChoiceRegionBlock)(NSDictionary *resultDic);


@interface VC_CreditScoreTwo : VC_Base
@property (nonatomic, strong) ChoiceRegionBlock choiceQualityBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr_data;

- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray;
@end
