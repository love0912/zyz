//
//  VC_AddendumNotice.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddendumNotice.h"
static NSString *cellID=@"Cell_AddendumNotice";
#import "SupplementDomain.h"
@interface VC_AddendumNotice (){
    NSArray *_arr_Input;
    CGFloat _contentLabelHeight;
    SupplementDomain *_endumNotice;
}
@end

@implementation VC_AddendumNotice

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"补遗通知";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
}
-(void)loadData{
//    _arr_Input = @[
//                   @{kCellKey: kAdditionalContent, kCellName: @"补遗具体内容", kCellDefaultText: @"白纸脱胎换骨的基本表现就在于能跳出空白格，成为名著经典万人成诵的书，成为大富大贵价值连城的画。作为一张不值一文的白纸都有了奋发拼搏的斗志，那你还有理由嘲笑世界及其万物不择手段地跳出空白格的行为吗？白纸的初衷并非如厕所用，那样只是强其所难的应用方式，它与生俱来是为了有思想的文字准备的，为了妙不可言的图画准备的……它从未卑微小看过自己，在最大意义上存在着，骄傲地存在着。"},
//                   @{kCellKey: kAdditionalDownloadUrl, kCellName: @"文件下载地址", kCellDefaultText: @"1888-08"},
//                   @{kCellKey: kAdditionalAccessCode, kCellName: @"文件提取码", kCellDefaultText: @"XXXXXX"}
//                 ];
    _endumNotice=[self.parameters objectForKey:@"endumcontent"];
    self.jx_title = _endumNotice.Title;
    _arr_Input = @[
                   @{kCellKey: kAdditionalContent, kCellName: @"补遗具体内容", kCellDefaultText:_endumNotice.Content == nil ? @"" : _endumNotice.Content},
                   @{kCellKey: kAdditionalDownloadUrl, kCellName: @"文件下载地址", kCellDefaultText: _endumNotice.DownloadUrl == nil ? @"" : _endumNotice.DownloadUrl},
                   @{kCellKey: kAdditionalAccessCode, kCellName: @"文件提取码", kCellDefaultText: _endumNotice.AccessCode == nil ? @"" : _endumNotice.AccessCode}
                 ];
    
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *name = dic_input[kCellName];
    NSString *text = dic_input[kCellDefaultText];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
    cell.textLabel.text = name;
    cell.detailTextLabel.text = text;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_contentLabelHeight>44) {
        return _contentLabelHeight+70;
    }else{
        return 44;
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0){
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0){
    return YES;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0){
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *text = dic_input[kCellDefaultText];
    if(action == @selector(copy:)){
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = text;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
