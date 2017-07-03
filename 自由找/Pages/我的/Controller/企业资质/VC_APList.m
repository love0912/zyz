//
//  VC_APList.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_APList.h"
#import "BidService.h"
#import "VC_Quality.h"

@interface VC_APList ()
{
    NSMutableArray *_arr_qualitySelected;
    BidService *_bidService;
}
@end

@implementation VC_APList

- (void)initData {    
    _arr_qualitySelected = [NSMutableArray array];
    if (_arr_quality == nil) {
        _arr_quality = [NSMutableArray arrayWithCapacity:0];
    }
    [self handleSelectedQuality];
    _bidService = [BidService sharedService];
}

- (void)layoutUI {
    [self layoutEnterButton];
    if (_arr_quality.count == 0) {
        _tableView.hidden = YES;
    }
    [self hideTableViewFooter:_tableView];
}

- (void)layoutEnterButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btn_commit_pressed)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)btn_commit_pressed {
    self.multiQuality(_arr_quality);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"企业资质";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_quality.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_APList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_quality objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCommonValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = _arr_quality[indexPath.row];
        NSString *limitKey = dic[kCommonKey];
        for (NSDictionary *tmpDic in _arr_qualitySelected) {
            if ([limitKey isEqualToString:tmpDic[kLimitKey]]) {
                [_arr_qualitySelected removeObject:tmpDic];
                break;
            }
        }

        [_arr_quality removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
//         self.multiQuality(_arr_quality);
    }
    if (_arr_quality.count == 0) {
        _tableView.hidden = YES;
    }
}

- (void) handleSelectedQuality {
    for (NSDictionary *tmpDic in _arr_quality) {
        NSString *limitKey = tmpDic[kCommonKey];
        NSString *topKey = @"";
        NSRange range = [limitKey rangeOfString:@"lv"];
        if (range.location != NSNotFound) {
            topKey = [limitKey substringToIndex:range.location];
        }
        if ([limitKey hasPrefix:@"gljtgc"]) {
            topKey = [topKey substringToIndex:topKey.length-2];
        }
        [_arr_qualitySelected addObject:@{kTopKey: topKey, kLimitKey: limitKey}];
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

- (IBAction)btn_add_pressed:(id)sender {
    [_bidService getQualitificationWithType:0 result:^(NSArray *qualityList, NSInteger code) {
        if (code != 1) {
            return ;
        }
        VC_Quality *vc_quality = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Quality"];
        if (_arr_qualitySelected.count == 0) {
            [vc_quality setDataArray:qualityList disabledArray:nil selectedData:nil];
        } else {
            NSMutableArray *disabledArray = [NSMutableArray arrayWithCapacity:_arr_qualitySelected.count];
            for (NSDictionary *tmpDic in _arr_qualitySelected) {
                [disabledArray addObject:tmpDic[kTopKey]];
            }
            [vc_quality setDataArray:qualityList disabledArray:disabledArray selectedData:nil];
        }
        [self.navigationController pushViewController:vc_quality animated:YES];
        vc_quality.choiceQualityBlock = ^(NSDictionary * dic) {
            if (_arr_quality.count == 0) {
                _tableView.hidden = NO;
            }
            [_arr_quality insertObject:dic atIndex:0];
            [_arr_qualitySelected addObject:@{kTopKey: dic[kTopKey], kLimitKey: dic[kCommonKey]}];
            [_tableView reloadData];
        };
    }];
}

@end
