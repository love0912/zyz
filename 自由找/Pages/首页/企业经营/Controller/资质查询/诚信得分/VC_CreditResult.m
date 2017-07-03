//
//  VC_CreditResult.m
//  自由找
//
//  Created by guojie on 16/7/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CreditResult.h"

@interface VC_CreditResult ()
{
    NSArray *_arr_input;
    NSString *_selectKey;
}
@end

@implementation VC_CreditResult

- (void)initData {

}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)rightItemPressed {
    self.creditChoice(nil);
    [self goBack];
}

- (void)setInputArray:(NSArray *)inputArray selectKey:(NSString *)selectKey {
    _arr_input = [NSArray arrayWithArray:inputArray];
    _selectKey = selectKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择诚信得分";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_CreditResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    UIColor *textColor = [UIColor colorWithHex:@"333333"];
    cell.accessoryView = nil;
    if ([_selectKey isEqualToString:tmpDic[kCommonKey]]) {
        textColor = [CommonUtil zyzOrangeColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou"]];
    }
    cell.textLabel.text = tmpDic[kCommonValue];
    cell.textLabel.textColor = textColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    self.creditChoice(tmpDic);
    [self goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
