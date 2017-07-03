//
//  VC_LetterPriceDetail.m
//  zyz
//
//  Created by 郭界 on 16/10/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_LetterPriceDetail.h"
#import "LetterService.h"

@interface VC_LetterPriceDetail ()
{
    LetterService *_letterService;
    NSString *_orderID;
    NSString *_jxTitle;
    NSArray *_arr_price;
    NSInteger _pageType;
}
@end

@implementation VC_LetterPriceDetail

- (void)initData {
    _letterService = [LetterService sharedService];
    _orderID = [self.parameters objectForKey:kPageDataDic];
    _jxTitle = [self.parameters objectForKey:@"JX_Title"];
    _pageType = [[self.parameters objectForKey:kPageType] integerValue];
    
    [self getPrice];
}

- (void)layoutUI {
    self.jx_title = [NSString stringWithFormat:@"%@价格明细", _jxTitle];
    [self hideTableViewFooter:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)getPrice {
    [_letterService getLetterPriceListByID:_orderID result:^(NSInteger code, NSArray<LetterPriceDomain *> *list) {
        if (code == 1) {
            _arr_price = [NSArray arrayWithArray:list];
            [_tableView reloadData];
        } else {
            [self goBack];
        }
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_price.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_LetterPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"保函金额";
        if (_pageType == 1) {
            cell.detailTextLabel.text = @"费率";
        } else {
            cell.detailTextLabel.text = @"保函价格";
        }
        cell.textLabel.textColor = [UIColor colorWithHex:@"999999"];
        cell.detailTextLabel.textColor = [UIColor colorWithHex:@"999999"];
        return cell;
    }
    cell.textLabel.textColor = [UIColor colorWithHex:@"333333"];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:@"333333"];
    LetterPriceDomain *price = [_arr_price objectAtIndex:(indexPath.row - 1)];
    cell.textLabel.text = price.SegmentTitle;
    if (_pageType == 1) {
        long double f = price.SegmentFee.floatValue * 100;
        NSString *fString = [NSString stringWithFormat:@"%Lf", f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", [CommonUtil removeFloatAllZero:fString]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元", [CommonUtil removeFloatAllZero:price.SegmentFee]];
    }
    return cell;
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
