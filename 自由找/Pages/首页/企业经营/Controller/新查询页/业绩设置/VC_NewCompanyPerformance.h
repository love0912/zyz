//
//  VC_NewCompanyPerformance.h
//  zyz
//
//  Created by 郭界 on 16/12/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

//用于显示已选择
#define kSinceDateSelect @"SinceDateSelect"
#define kEndDateSelect @"EndDateSelect"

typedef void(^NewPerformanceResult)(NSMutableDictionary *resultDicInfo);

@interface VC_NewCompanyPerformance : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn_beginDate;
- (IBAction)btn_beginDate_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_endDate;
- (IBAction)btn_endDate_pressed:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *btn_count_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_count_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_count_3;
@property (weak, nonatomic) IBOutlet UITextField *tf_count;
@property (weak, nonatomic) IBOutlet UIButton *btn_count_4;
@property (weak, nonatomic) IBOutlet UITextField *tf_projectSize;

- (IBAction)btn_count_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_unit;
- (IBAction)btn_unit_pressed:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dic_PerformanceInfo;

@property (strong, nonatomic) NewPerformanceResult performanceResult;
- (IBAction)btn_finishSetting_pressed:(id)sender;

@end
