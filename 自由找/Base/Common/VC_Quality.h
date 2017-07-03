//
//  VC_Quality.h
//  自由找
//
//  Created by guojie on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^ChoiceQualityBlock)(NSDictionary *resultDic);

@interface VC_Quality : VC_Base<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ChoiceQualityBlock choiceQualityBlock;

- (void)setDataArray:(NSArray *)allArray disabledArray:(NSArray *)disableArray selectedData:(NSDictionary *)selectedDic;

- (void)setChoiceResult:(NSDictionary *)resultDic;

/**
 *  监理资质是否排在最前面
 */
@property (assign, nonatomic) BOOL jianliFirst;

@end
