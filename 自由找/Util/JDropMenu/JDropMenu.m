//
//  JDropMenu.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JDropMenu.h"
#import "BaseConstants.h"
#define kJDropMenuCellHeight 50
#define kMaxScale 0.7

@interface JDropMenu ()
{
    NSArray *_arr_dataSource;
    BOOL _fromTop;
    CGFloat _margin;
    UITableView *_tableView;
    KVImageDomain *_selectData;
    CGFloat _selfY;
}

@end

@implementation JDropMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithdataSource:(NSArray<KVImageDomain *> *)dataSource fromTop:(BOOL)top margin:(CGFloat)margin {
    _selfY = margin;
    if (!top) {
        _selfY = ScreenSize.height - margin;
    }
    self = [super initWithFrame:CGRectMake(0, _selfY, ScreenSize.width, 0)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tap];
        
        _arr_dataSource = [NSArray arrayWithArray:dataSource];
        _fromTop = top;
        _margin = margin;
        
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        CGFloat tableHeight = dataSource.count * kJDropMenuCellHeight;
        if (tableHeight > ScreenSize.height * kMaxScale) {
            tableHeight = ScreenSize.height * kMaxScale;
            _tableView.scrollEnabled = YES;
        }
        CGFloat tableY = 0;
        if (!top) {
            tableY = ScreenSize.height - margin - tableHeight;
        }
        _tableView.frame = CGRectMake(0, tableY, ScreenSize.width, tableHeight);
        
        [self addSubview:_tableView];
        
    }
    return self;
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"JDropMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    KVImageDomain *kvImage = [_arr_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = kvImage.Value;
    cell.textLabel.textColor = [UIColor colorWithHex:@"333333"];
    cell.accessoryView = nil;
    if (kvImage.ImageName != nil) {
        cell.imageView.image = [UIImage imageNamed:kvImage.ImageName];
    }
    if (_selectData != nil && [_selectData.Key isEqualToString:kvImage.Key]) {
        cell.textLabel.textColor = [CommonUtil zyzOrangeColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou"]];
        if (kvImage.SelectImageName != nil) {
            cell.imageView.image = [UIImage imageNamed:kvImage.SelectImageName];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJDropMenuCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KVImageDomain *kvImage = [_arr_dataSource objectAtIndex:indexPath.row];
    self.dropData(kvImage);
    [self dismiss];
}

#pragma mark -


- (void)showInView:(UIView *)view selectData:(KVImageDomain *)selectData dropData:(void (^)(KVImageDomain *dropData)) dropData; {
    self.isShowing = YES;
    _tableView.alpha = 0;
    [view addSubview:self];
    _selectData = selectData;
    self.dropData = dropData;
    [_tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.alpha = 1;
        CGFloat y = 0;
        if (_fromTop) {
            y = _selfY;
        }
        self.frame = CGRectMake(0, y, ScreenSize.width, ScreenSize.height - _margin);
    }];
}

- (void)dismiss {
    self.isShowing = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.alpha = 0;
        if (!_fromTop) {
            _selfY = ScreenSize.height - _margin;
        }
        self.frame = CGRectMake(0, _selfY, ScreenSize.width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
