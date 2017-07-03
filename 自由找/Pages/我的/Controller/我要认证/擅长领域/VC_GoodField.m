//
//  VC_GoodField.m
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_GoodField.h"
static NSString *cellID=@"Cell_Goodfield";
@interface VC_GoodField (){
    NSInteger selectIndex;
    BOOL checked;
}
@end

@implementation VC_GoodField

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择擅长领域";
    [self zyzOringeNavigationBar];
    [self layoutUI];
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];
}
-(void)rightItem_press{
    self.filedchoiceBlock(_selectArray);
    [self goBack];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    KeyValueDomain *goodkeyValue = _allArray[indexPath.row];
    cell.textLabel.text =goodkeyValue.Value;
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (int j = 0; j < _selectArray.count; j ++) {
        NSString *checkkeyString = _selectArray[j];
        if ([checkkeyString isEqualToString:goodkeyValue.Key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}
#pragma mark 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueDomain *keyValue = [_allArray objectAtIndex:indexPath.row];
    if (![_selectArray containsObject:keyValue.Key]) {
        [_selectArray addObject:keyValue.Key];
    }else{
        [_selectArray removeObject:keyValue.Key];
    }
    [self reloadIndexPath:indexPath];
}
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
