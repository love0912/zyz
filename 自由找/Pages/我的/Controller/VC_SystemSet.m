//
//  VC_SystemSet.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_SystemSet.h"
#import "Cell_SystemSet.h"
#import "VC_ServiceCenter.h"
#import "VC_FeedBack.h"
@interface VC_SystemSet (){
    CGFloat _cellHeight;
    CGFloat _tableHeight;
    NSArray *_systemArray;
}
@end

@implementation VC_SystemSet

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"系统设置";
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];

    [self initData];
    [self layoutUI];
}
-(void)initData{
    _systemArray=@[@"客服中心",@"使用帮助",@"意见反馈",@"关于我们"];

    _cellHeight = 48;

    _tableHeight=_cellHeight*_systemArray.count;
}
-(void)layoutUI{
    _layout_tableHeight.constant=_tableHeight;
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _systemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SystemSetIdentifier";
    
    Cell_SystemSet*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[Cell_SystemSet alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell systemIndex:indexPath.row andsystemtitle:_systemArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [PageJumpHelper pushToVCID:@"VC_ServiceCenter" storyboard:Storyboard_Mine parent:self];
        
    } else if (indexPath.row == 1) {
      [PageJumpHelper pushToVCID:@"VC_Help" storyboard:Storyboard_Mine parent:self];  
    } else if (indexPath.row==2){
        [PageJumpHelper pushToVCID:@"VC_FeedBack" storyboard:Storyboard_Mine parent:self];
    }else if (indexPath.row==3){
        [PageJumpHelper pushToVCID:@"VC_AboutUs" storyboard:Storyboard_Mine parent:self];
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
