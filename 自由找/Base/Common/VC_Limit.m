//
//  VC_Limit.m
//  自由找
//
//  Created by guojie on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Limit.h"

@interface VC_Limit ()
{
    NSMutableArray *_arr_data;
}
@end

@implementation VC_Limit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择等级";
    [self zyzOringeNavigationBar];
    
    if (_arr_data == nil) {
        _arr_data = [NSMutableArray arrayWithCapacity:0];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic selectKey:(NSString *)selectKey delegate:(id)delegate {
    _dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    _arr_data = [NSMutableArray arrayWithArray:_dataDic[kNewSubCollection]];
    if (selectKey != nil) {
        _selectKey = [NSString stringWithFormat:@"%@", selectKey];
    }
    _delegate = delegate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Limit";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = _arr_data[indexPath.row];
    cell.textLabel.text = tmpDic[kCommonValue];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (_selectKey != nil && [tmpDic[kCommonKey] isEqualToString:_selectKey]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = _arr_data[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ / %@", _dataDic[kCommonValue], tmpDic[kCommonValue]];
    NSString *key = tmpDic[kCommonKey];
    NSDictionary *resultDic = @{kCommonKey: key, kCommonValue: title, kTopKey: _dataDic[kCommonKey]};
    [_delegate setChoiceResult:resultDic];
    NSLog(@"%@", self.navigationController.viewControllers);
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
    [self.navigationController popToViewController:vc animated:YES];
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
