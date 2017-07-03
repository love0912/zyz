//
//  VC_NewQuality.h
//  zyz
//
//  Created by 郭界 on 16/12/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_NewRadio.h"

#define kIsMatchAny @"IsMatchAny"
#define kQualityData @"Aptitudes"
#define kQualityChoiceData @"QualityChoiceData"

typedef void(^NewQualityResult)(NSMutableDictionary *resultDicInfo);

@interface VC_NewQuality : VC_Base<UITableViewDelegate, UITableViewDataSource, NewRadioChoiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_add_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;

@property (strong, nonatomic) NSMutableDictionary *dic_QualityInfo;

@property (strong, nonatomic) NewQualityResult qualityResult;

@end
