//
//  VC_OthersInformation.m
//  自由找
//
//  Created by xiaoqi on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_OthersInformation.h"
#import "UIImageView+WebCache.h"
#import "Cell_Resume.h"
#import "ProducerDomain.h"
#import "Cell_ProjectResume.h"

#define kHederDefaultHeight 146
static NSString *CellID1 = @"Cell_OthersInformation";
static NSString *CellID2 = @"Cell_Resume";
static NSString *CellID3 = @"cell_personalOverView";
static NSString *CellID4 = @"Cell_ProjectResume";
@interface VC_OthersInformation (){
    CGFloat _headerHeight;
    CGFloat _headerCellHeight;
    CGFloat _avaterTop;
    CGFloat _avaterWidth;
    //header 使用到的view
    UIImageView *_iv_avater;
    UIImageView *_iv_sex;
    UILabel *_lb_name;
    
    CGFloat _contentLabelHeight;
    
    ProducerDomain *_producer;
    NSMutableArray *_arr_producer;

}

@end

@implementation VC_OthersInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
-(void)initData{
    
    _producer = [self.parameters objectForKey:kPageDataDic];
    
//    _producer = [[ProducerDomain alloc] init];
//    _producer.Name = @"张小凡";
//    _producer.NickName = @"xxx";
//    _producer.Sex = @"0";
//    _producer.Birthday = @"1990-09-09";
//    KeyValueDomain *region = [[KeyValueDomain alloc] init];
//    region.Key = @"5000000";
//    region.Value = @"重庆市";
//    _producer.Region = region;
//    _producer.AuthStatus = @"USED";
//    _producer.ProductType = @"1";
//    _producer.Education = @"社会大学";
//    _producer.Description = @"三级会计工程师";
//    WorkExperienceDomain *word = [[WorkExperienceDomain alloc] init];
//    word.Organization = @"腾讯重庆分公司";
//    word.Department = @"移动开发部门";
//    word.Job = @"攻城狮";
//    word.JobDescription = @"打游戏";
//    word.StartDt = @"2016-01-01";
//    word.EndDt = @"至今";
//    word.Workmate = @"麻花疼";
//    _producer.WorkExperience = @[word];
//    
//    ProjectExperienceDomain *project = [[ProjectExperienceDomain alloc] init];
//    project.ProjectName = @"微信";
//    project.StartDt = @"2014-10-10";
//    project.EndDt = @"2016-06-06";
//    project.Workmate = @"麻花藤";
//    _producer.ProjectExperience = @[project];
    [self handleProducerInfo];
    if (IS_IPHONE_4_OR_LESS) {
        _headerHeight = 108;
        _avaterTop = 14;
        _avaterWidth = 50;
    } else if (IS_IPHONE_5) {
        _avaterTop = 20;
        _avaterWidth = 58;
        _headerHeight = 118;
    } else {
        _avaterTop = 24;
        _avaterWidth = 68;
        _headerHeight = kHederDefaultHeight;
    }
}

- (void)handleProducerInfo {
    _arr_producer = [NSMutableArray array];
    NSMutableArray *arr_1 = [NSMutableArray arrayWithCapacity:3];
    if (_producer.NickName != nil) {
        [arr_1 addObject: @{kCellKey: kNickName, kCellName: @"昵       称", kCellDefaultText: _producer.NickName}];
    }
    if (_producer.Birthday != nil) {
        [arr_1 addObject:@{kCellKey: kDateofBirth, kCellName: @"出生年月", kCellDefaultText: _producer.Birthday}];
    }
    if (_producer.Education != nil) {
        [arr_1 addObject:@{kCellKey: kGraduatedSchool, kCellName: @"毕业学校", kCellDefaultText: _producer.Education}];
    }
    
    [_arr_producer addObject:arr_1];
//    [_arr_producer addObject:_producer.WorkExperiences];
    if(_producer.ProjectExperiences!=nil&&[_producer.ProjectExperiences count]!=0){
        [_arr_producer addObject:_producer.ProjectExperiences];
    }
    NSMutableArray *arr_3 = [NSMutableArray arrayWithCapacity:0];
    if (_producer.Description != nil) {
        [arr_3 addObject:@{kCellKey: kPersonalOverView, kCellName: @"", kCellDefaultText: _producer.Description}];
    }
    [_arr_producer addObject:arr_3];
    
}

-(void)layoutUI{
    _tableView.sectionFooterHeight=10;
    //去除navigabar底部的横线
    NSArray *list=self.jx_navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=YES;
        }
    }
    [self layoutHeaderView];
}
- (void)layoutHeaderView {
    self.mineHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, _headerHeight)];
    self.mineHeaderView.userInteractionEnabled = YES;
    self.mineHeaderView.backgroundColor = [CommonUtil zyzOrangeColor];
    [self.tableView addSubview:self.mineHeaderView];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.mineHeaderView.bounds];
    self.tableView.tableHeaderView = backView;
    backView.hidden = YES;
    _iv_avater = [[UIImageView alloc] init];
    _iv_avater.translatesAutoresizingMaskIntoConstraints = NO;
    _iv_avater.layer.masksToBounds = YES;
    _iv_avater.layer.cornerRadius = _avaterWidth / 2;
    
    [_mineHeaderView addSubview:_iv_avater];
    [_iv_avater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_avaterWidth);
        make.height.mas_equalTo(_avaterWidth);
        make.centerX.equalTo(_mineHeaderView.mas_centerX);
        make.top.equalTo(_mineHeaderView.mas_top).with.offset(_avaterTop);
    }];
    _iv_sex=[[UIImageView alloc] init];
    _iv_sex.translatesAutoresizingMaskIntoConstraints = NO;
    [_mineHeaderView addSubview:_iv_sex];
    [_iv_sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_iv_avater.mas_right).with.offset(0);
        make.bottom.equalTo(_iv_avater.mas_bottom).with.offset(0);
    }];

    _lb_name = [[UILabel alloc] init];
    _lb_name.font = [UIFont systemFontOfSize:16];
    _lb_name.textColor = [UIColor whiteColor];
    _lb_name.translatesAutoresizingMaskIntoConstraints = NO;
    [_mineHeaderView addSubview:_lb_name];
    [_lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iv_avater.mas_bottom).with.offset(15);
        make.centerX.equalTo(_mineHeaderView.mas_centerX).with.offset(0);
    }];
    
    
    NSString *name = [NSString stringWithFormat:@"%@ * *", [_producer.Name substringToIndex:1]];
    _lb_name.text = name;
    [_iv_avater sd_setImageWithURL:[NSURL URLWithString:_producer.HeadImgUrl] placeholderImage:DEFAULTAVATER];
    if ([_producer.Sex isEqualToString:@"1"]) {
        _iv_sex.image=[UIImage imageNamed:@"boy"];
    } else if ([_producer.Sex isEqualToString:@"0"]) {
        _iv_sex.image = [UIImage imageNamed:@"girl"];
    }
    
    
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_producer.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_producer objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 || indexPath.section == 3) {
    if (_arr_producer.count==2) {
        NSDictionary *dic_input = [[_arr_producer objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *name = dic_input[kCellName];
        NSString *text = dic_input[kCellDefaultText];
        if (indexPath.section == 0) {
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellID1];
            UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
            cell1.textLabel.text = name;
            cell1.detailTextLabel.textColor = detailTextColor;
            cell1.detailTextLabel.text = text;
            return cell1;
        } else {
            UITableViewCell *cell_personalOver = [tableView dequeueReusableCellWithIdentifier:CellID3];
            CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
            _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
            cell_personalOver.textLabel.text = text;
            return cell_personalOver;
        }
    }else{
        if (indexPath.section == 0 || indexPath.section == 2) {
            NSDictionary *dic_input = [[_arr_producer objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *name = dic_input[kCellName];
            NSString *text = dic_input[kCellDefaultText];
            if (indexPath.section == 0) {
                UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellID1];
                UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
                cell1.textLabel.text = name;
                cell1.detailTextLabel.textColor = detailTextColor;
                cell1.detailTextLabel.text = text;
                return cell1;
            } else {
                UITableViewCell *cell_personalOver = [tableView dequeueReusableCellWithIdentifier:CellID3];
                CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
                _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
                cell_personalOver.textLabel.text = text;
                return cell_personalOver;
            }
        }
    //    else if(indexPath.section == 1){
    //        Cell_Resume *cell_Resume=[tableView dequeueReusableCellWithIdentifier:CellID2];
    //        WorkExperienceDomain *work = [[_arr_producer objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //            cell_Resume.work = work;
    //        return cell_Resume;
    //    }
        else{
            Cell_ProjectResume *cell_projectResume=[tableView dequeueReusableCellWithIdentifier:CellID4];
            ProjectExperienceDomain *project = [[_arr_producer objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell_projectResume.project = project;
            return cell_projectResume;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44.0)];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithHex:@"999999"];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.frame = CGRectMake(15.0, 0.0, SCREEN_WIDTH, 44.0);
    
//    if (section == 0) {
//        headerLabel.text =  @"";
//    }else if (section == 1){
//        headerLabel.text = @"工作简历";
//    }else if (section == 2){
//        headerLabel.text = @"项目简历";
//    }else if (section == 3){
//        headerLabel.text = @"个人概述";
//    }
    if (_arr_producer.count==2) {
        if (section == 0) {
            headerLabel.text =  @"";
        }else{
            headerLabel.text = @"个人概述";
        }
    }else{
        if (section == 0) {
            headerLabel.text =  @"";
        }else if (section == 1){
            headerLabel.text = @"项目简历";
        }else if (section == 2){
            headerLabel.text = @"个人概述";
        }
    }
    [customView addSubview:headerLabel];
    
    return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return 44;
//    }else if (indexPath.section==3){
//        return _contentLabelHeight;
//    }else{
//        return 70;
//    }
    if (_arr_producer.count==2) {
        if (indexPath.section==0) {
            return 44;
        }else{
            return _contentLabelHeight;
        }
    }else{
        if (indexPath.section==0) {
            return 44;
        }else if (indexPath.section==2){
            return _contentLabelHeight;
        }else{
            return 70;
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前活动的tableview
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        _mineHeaderView.frame = CGRectMake(offsetY/2, offsetY, ScreenSize.width - offsetY, _headerHeight - offsetY);  // 修改头部的frame值就行了
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
