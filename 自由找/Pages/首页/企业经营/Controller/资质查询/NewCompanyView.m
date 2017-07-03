//
//  NewCompanyView.m
//  FreeJob
//
//  Created by guojie on 16/1/7.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "NewCompanyView.h"
 static NSString *CellIdentifier = @"Cell_NewCompany";
@implementation NewCompanyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewWithArray:(NSArray *)companys delegate:(id)delegate {
    NewCompanyView *newCompany = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    newCompany.arr_company = [NSMutableArray arrayWithArray:companys];
    newCompany.delegate = delegate;
    if (newCompany.type == nil) {
        newCompany.type = @"1";
    }
    return newCompany;
}

- (void)layoutSubviews {
    if ([_type isEqualToString:@"1"]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    } else {
        self.backgroundColor = [UIColor orangeColor];
    }
}

- (void)startRuning {
    if (self.arr_company.count > 0) {
        _showCellCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollNewCompany) userInfo:nil repeats:YES];
    }
}

- (void)scrollNewCompany {
    if (_showCellCount == _arr_company.count) {
        _showCellCount = 0;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    _showCellCount ++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_showCellCount inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arr_company.count == 0) {
        return 0;
    }
    return _arr_company.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_NewCompany *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (Cell_NewCompany *)[[[NSBundle  mainBundle]  loadNibNamed:@"Cell_NewCompany" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
    }
    if (indexPath.row == _arr_company.count) {
        CompanyListDomian *domain = _arr_company[0];
        NSString *text = [NSString stringWithFormat:@"恭喜! %@认证成功", domain.CompanyName];
       cell.lb_companyName.text = text;
    } else {
        CompanyListDomian *domain = _arr_company[indexPath.row];
        NSString *text = [NSString stringWithFormat:@"恭喜! %@认证成功", domain.CompanyName];
        cell.lb_companyName.text = text;
   }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(showNewCompanyWithDomain:)]) {
        NSInteger index = indexPath.row;
        if (index == _arr_company.count) {
            index = 0;
        }
        CompanyListDomian *domain =_arr_company[index];
        [_delegate showNewCompanyWithDomain:domain];
    }
}

- (void)dealloc {
    [_timer invalidate];
}

@end
