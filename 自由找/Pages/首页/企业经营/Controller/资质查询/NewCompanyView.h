//
//  NewCompanyView.h
//  FreeJob
//
//  Created by guojie on 16/1/7.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QualificaDomian.h"
#import "Cell_NewCompany.h"
@protocol NewCompanyTopDelegate <NSObject>

- (void)showNewCompanyWithDomain:(CompanyListDomian *)domain;

@end

@interface NewCompanyView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _showCellCount;
    NSTimer *_timer;
}

@property (nonatomic, strong) NSMutableArray *arr_company;

/**
 *  新增
 *  为了区分首页和资质查询页的区别。
 *  默认  1--资质查询页，，2--首页
 */
@property (nonatomic, strong) NSString *type;

+ (instancetype)viewWithArray:(NSArray *)companys delegate:(id)delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id delegate;

- (void)startRuning;


@end
