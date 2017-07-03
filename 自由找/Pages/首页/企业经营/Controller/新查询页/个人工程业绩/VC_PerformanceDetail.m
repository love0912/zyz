//
//  VC_PerformanceDetail.m
//  zyz
//
//  Created by 郭界 on 17/1/6.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_PerformanceDetail.h"
#import "PerformanceDoamin.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "Cell_PerformanceDetail.h"

@interface VC_PerformanceDetail ()
{
    NSMutableArray *_arr_input;
    
    NSInteger _queryType;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation VC_PerformanceDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"业绩详情";
    [self hideTableViewFooter:_tableView];
    _arr_input = [NSMutableArray array];
    _queryType = [[self.parameters objectForKey:kPageType] integerValue];
    PerformanceDoamin *performance = [self.parameters objectForKey:kPageDataDic];
    [self addInputByName:@"项目名称" detailText:performance.ProjectName];
    [self addInputByName:@"项目编码" detailText:performance.ProjectNo];
    [self addInputByName:@"项目类别" detailText:performance.ProjectCategory];
    [self addInputByName:@"工程用途" detailText:performance.ProjectApplication];
    [self addInputByName:@"建设规模" detailText:performance.ProjectSize];
//    if (_queryType == 1) {
        [self addInputByName:@"建设单位" detailText:performance.BuilderCompany];
        [self addInputByName:@"中标单位" detailText:performance.WinningCompany];
//    }
    [self addInputByName:@"中标金额" detailText:performance.WinningAmount];
    [self addInputByName:@"中标日期" detailText:performance.WinningDt];
    [self addInputByName:@"竣工日期" detailText:performance.ProjectDeliverDt];
//    if (_queryType == 1) {
        [self addInputByName:@"建造师" detailText:performance.BuildEngineer];
//    }
    [self addInputByName:@"技术负责人" detailText:performance.TechLeader];
    
}

- (void)addInputByName:(NSString *)name detailText:(NSString *)detailText {
    [_arr_input addObject:@{kCellName: name, kCellDefaultText:(detailText == nil ? @"": detailText)}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_PerformanceDetail";
    Cell_PerformanceDetail *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    cell.dataDic = tmpDic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"Cell_PerformanceDetail" cacheByIndexPath:indexPath configuration:^(Cell_PerformanceDetail *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    if (height < 48) {
        height = 48;
    }
    return height;
}

- (void)configureCell:(Cell_PerformanceDetail *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    cell.dataDic = tmpDic;
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
