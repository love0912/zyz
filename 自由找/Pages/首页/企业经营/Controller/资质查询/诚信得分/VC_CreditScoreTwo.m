//
//  VC_CreditScoreTwo.m
//  自由找
//
//  Created by xiaoqi on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CreditScoreTwo.h"
static NSString *CellID = @"Cell_CreditScoreTwo";
@interface VC_CreditScoreTwo (){
    NSArray *_arr_Input;
    KeyValueDomain *keyValue;
     BOOL checked;
     NSArray *_selectArray;
     NSInteger selectIndex;
}
 @end

@implementation VC_CreditScoreTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"诚信得分";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];

}
-(void)initData{
    
    checked = NO;
    _tableView.rowHeight=48;
}
- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray {
    _arr_data = [NSMutableArray arrayWithArray:allArray];
    _selectArray = [NSArray arrayWithArray:selectArray];
    if (selectArray.count == 1) {
        checked = YES;
        for (int i = 0; i < _arr_data.count; i ++) {
            keyValue = _arr_data[i];
            NSString *checkString = selectArray[0];
            NSString *tmpString = keyValue.Value;
            if ([checkString isEqualToString:tmpString]) {
                selectIndex = i;
            }
        }
    }
    
    
}
-(void)rightItem_press{
    keyValue=_arr_data[selectIndex];
    self.choiceQualityBlock([keyValue toDictionary]);
    [self goBack];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     keyValue = _arr_data[indexPath.row];
    Cell_CreditScoreTwo *cell_creditscore = [tableView dequeueReusableCellWithIdentifier:CellID];
    UIColor *scoreTextColor = [UIColor colorWithHex:@"333333"];
    cell_creditscore.lb_score.text=keyValue.Value;
    cell_creditscore.lb_score.textColor = scoreTextColor;
    if(selectIndex != indexPath.row && _selectArray.count == 1){
       cell_creditscore.iv_checkmark.hidden=YES;
    }else{
        cell_creditscore.iv_checkmark.hidden=NO;
        cell_creditscore.lb_score.textColor = [UIColor colorWithHex:@"ff7b23"];
    }
    return cell_creditscore;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取当前选择的行
    selectIndex=indexPath.row;
    [_tableView reloadData];

    
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
