//
//  VC_MessageList.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MessageList.h"
#import "Cell_Message.h"
@interface VC_MessageList (){
    CGFloat _cellHeight;
}

@end

@implementation VC_MessageList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"消息";
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    [self initData];
    [self layoutUI];
}
-(void)layoutUI{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_right"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];
}
-(void)initData{
    if (IS_IPHONE_6P) {
        _cellHeight = 77;
    } else if (IS_IPHONE_4_OR_LESS) {
        _cellHeight = 50;
    } else {
        _cellHeight = 70;
    }
}
-(void)rightItem_press{
    [JAlertHelper jSheetWithTitle:nil message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:nil OtherButtonsArray:@[@"全部标记已读",@"删除所有会话"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        
    }];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellMessageIdentifier";
    
    Cell_Message*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[Cell_Message alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView

           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
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
