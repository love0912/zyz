//
//  JXRatingView.m
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JXRatingView.h"
#import "BaseConstants.h"
#import "Masonry.h"

@interface JXRatingView ()
{
    CGFloat _cellHeight;
    CGFloat _ratingBarHeight;
    CGFloat _buttonHeight;
    CGFloat _tableHeight;
    CGFloat _buttonPaddingTop;
    
    UIView *_v_back;
    UIButton *_btn_cancel;
    UIButton *_btn_commit;
    RatingBar *_ratingBar;
    
    BOOL firstEnter;
}

@end

@implementation JXRatingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (void)showInView:(UIView *)parent reasons:(NSArray *)reasons titleText:(NSString *)titleText rattingScore:(void (^)(CGFloat score, NSString *reason))result {
    JXRatingView *v_ratting = [[JXRatingView alloc] initWithReasons:reasons];
    v_ratting.titleText = titleText;
    v_ratting.frame = parent.bounds;
    [v_ratting layoutRattingView];
    v_ratting.rattingScore = result;
    v_ratting.alpha = 0;
    [parent addSubview:v_ratting];
    [UIView animateWithDuration:0.3 animations:^{
        v_ratting.alpha = 1;
    }];
}

- (instancetype)initWithReasons:(NSArray *)reasons {
    self = [super init];
    if (self) {
        _arr_menu = [NSArray arrayWithArray:reasons];
        _score = 0;
        firstEnter = YES;
    }
    return self;
}

- (void)layoutRattingView {
    _cellHeight = 48;
    _buttonHeight = 48;
    _ratingBarHeight = 133;
    _buttonPaddingTop = 20;
    if (IS_IPHONE_5_OR_LESS) {
        _cellHeight = 44;
        _buttonHeight = 44;
    }
    
//    _arr_menu = @[
////                  @{kCellKey: }
//                  @"未主动联系报名者", @"发布的要求不完整", @"不诚信"
//                  ];
    _arr_reason = [NSMutableArray array];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _v_back = [[UIView alloc] init];
    _v_back.backgroundColor = [UIColor whiteColor];
    [self addSubview:_v_back];
    
    _ratingBar = [[RatingBar alloc] init];
    _ratingBar.titleText = _titleText != nil ? _titleText : @"请评价";
    [_v_back addSubview:_ratingBar];
    
    NSInteger count = _arr_menu.count;
    if (count > 3) {
        count = 3;
    }
    _tableHeight = _cellHeight * count;
    _tableView = [[UITableView alloc] init];
    [_v_back addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _btn_cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_cancel setTitleColor:[UIColor colorWithHex:@"666666"] forState:UIControlStateNormal];
    [_btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btn_cancel addTarget:self action:@selector(btn_cancel_pressed:) forControlEvents:UIControlEventTouchUpInside];
    [_v_back addSubview:_btn_cancel];
    
    _btn_commit = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn_commit setTitleColor:[UIColor colorWithHex:@"ff7b23"] forState:UIControlStateNormal];
    [_btn_commit setTitle:@"确定" forState:UIControlStateNormal];
    [_btn_commit addTarget:self action:@selector(btn_commit_pressed:) forControlEvents:UIControlEventTouchUpInside];
    [_v_back addSubview:_btn_commit];
    
    [self refreshUI];
    [_ratingBar setImageDeselected:@"" halfSelected:@"" fullSelected:@"" andDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Person";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    KeyValueDomain *info = _arr_menu[indexPath.row];
    cell.textLabel.text = info.Value;
    if ([_arr_reason indexOfObject:info.Key] == NSNotFound) {
        cell.accessoryView = [self noneImageView];
    } else {
        cell.accessoryView = [self selectImageView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KeyValueDomain *info = _arr_menu[indexPath.row];
    if ([_arr_reason indexOfObject:info.Key] == NSNotFound) {
        [_arr_reason addObject:info.Key];
        cell.accessoryView = [self selectImageView];
    } else {
        [_arr_reason removeObject:info.Key];
        cell.accessoryView = [self noneImageView];
    }
}

- (UIImageView *)selectImageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendmsg_sel"]];
}

- (UIImageView *)noneImageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendmsg_none"]];
}

- (void)ratingChanged:(float)newRating {
    _score = newRating;
}

- (void)finishRating {
    [UIView animateWithDuration:0.3 animations:^{
       [self refreshUI];
    }];
}

- (void)refreshUI {
    if (_score < 3) {
        _tableView.hidden = NO;
        
        _v_back.bounds = CGRectMake(0, 0, ScreenSize.width - 80, _ratingBarHeight + _tableHeight + _buttonHeight + _buttonPaddingTop);
        _v_back.center = self.center;
        _tableView.frame = CGRectMake(0, _ratingBarHeight, _v_back.width, _tableHeight);
        _btn_cancel.frame = CGRectMake(0, _ratingBarHeight + _tableHeight + _buttonPaddingTop, _v_back.width / 2, _buttonHeight);
        _btn_commit.frame = CGRectMake(_btn_cancel.width, _btn_cancel.origin.y, _btn_cancel.width, _buttonHeight);
    } else {
        [self showNoReasonView];
    }
    if (firstEnter) {
        firstEnter = NO;
        [self showNoReasonView];
    }
    
    _ratingBar.frame = CGRectMake(0, 0, _v_back.width, _ratingBarHeight);
}

- (void)showNoReasonView {
    _tableView.hidden = YES;
    _v_back.bounds = CGRectMake(0, 0, ScreenSize.width - 80, _ratingBarHeight + _buttonHeight + _buttonPaddingTop);
    _btn_cancel.frame = CGRectMake(0, _ratingBarHeight + _buttonPaddingTop, _v_back.width / 2, _buttonHeight);
    _btn_commit.frame = CGRectMake(_btn_cancel.width, _btn_cancel.origin.y, _btn_cancel.width, _buttonHeight);
}

- (void)btn_cancel_pressed:(id)sender {
    [self remove];
}

- (void)btn_commit_pressed:(id)sender {
    NSString *reason = @"";
    if (_score < 3 && _arr_reason.count == 0) {
        [ProgressHUD showInfo:@"请选择原因" withSucc:NO withDismissDelay:2];
        return;
    }
    if (_score < 3) {
        reason = [_arr_reason componentsJoinedByString:@","];
    }
    self.rattingScore(_score, reason);
    [self remove];
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
