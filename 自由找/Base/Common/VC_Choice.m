//
//  VC_Choice.m
//  自由找
//
//  Created by guojie on 16/7/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Choice.h"
#import "UINavigationBar+BackgroundColor.h"
@interface VC_Choice ()
{
    NSInteger selectIndex;
    BOOL checked;
    NSArray *_selectArray;
    NSDictionary *_resultDic;
    
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *_arr_search;
}
@end

@implementation VC_Choice

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    if (_nav_title == nil || [_nav_title isEmptyString]) {
        _nav_title = @"请选择";
    }
    self.jx_title = _nav_title;
    
    if (_type == nil) {
        _type = @"0";
    }
    
    _arr_search = [NSMutableArray array];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    // 添加 searchbar 到 headerview
//    _tableView.tableHeaderView = searchBar;
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
}

- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray {
    _arr_data = [NSMutableArray arrayWithArray:allArray];
    _selectArray = [NSArray arrayWithArray:selectArray];
    if (selectArray.count == 1) {
        checked = YES;
        for (int i = 0; i < _arr_data.count; i ++) {
            KeyValueDomain *keyValue = _arr_data[i];
            NSString *checkString = selectArray[0];
            NSString *tmpString = keyValue.Key;
            if ([checkString isEqualToString:tmpString]) {
                selectIndex = i;
            }
        }
    }
    
    
}
#pragma mark - search delegate


- (NSArray *)searchWithKey:(NSString *)key InQualityAll:(NSArray *)qualites {
//    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
//    for (NSArray *tmpArray in qualites) {
//        [allArray addObjectsFromArray:tmpArray];
//    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Value CONTAINS %@",key];
    NSArray *tmpArray = [qualites filteredArrayUsingPredicate:pred];
    return tmpArray;
    
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        return _arr_data.count;
    } else {
        [_arr_search setArray:[self searchWithKey:searchDisplayController.searchBar.text InQualityAll:_arr_data]];
        return _arr_search.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Choice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (tableView == _tableView) {
        KeyValueDomain *keyValue = _arr_data[indexPath.row];
        cell.textLabel.text = keyValue.Value;
        if (selectIndex == indexPath.row && _selectArray.count == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        KeyValueDomain *keyValue = _arr_search[indexPath.row];
        cell.textLabel.text = keyValue.Value;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    KeyValueDomain *keyValue;
    if (tableView == _tableView) {
        keyValue = _arr_data[indexPath.row];
        
    } else {
        keyValue = _arr_search[indexPath.row];
    }
    if ([_type isEqualToString:@"0"]) {
        self.choiceBlock([keyValue toDictionary]);
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([_type isEqualToString:@"3"]) {
//        [self.navigationController popViewControllerAnimated:NO];
        self.choiceBlock([keyValue toDictionary]);
    }else {
        _resultDic = [NSDictionary dictionaryWithDictionary:[keyValue toDictionary]];
        NSString *title = [NSString stringWithFormat:@"您选择的区域为[%@],该区域一旦选择无法更改，如果贵公司在多个区域进行经营，请通知在其它区域经营的同事注册新的帐号！", _resultDic[kCommonValue]];
        [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"重新选择" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                self.choiceBlock(_resultDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
