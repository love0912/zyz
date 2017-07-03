//
//  VC_NewQuery.h
//  zyz
//
//  Created by 郭界 on 16/12/21.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_PublishBidRadio3.h"

@interface VC_NewQuery : VC_Base<UITableViewDelegate, UITableViewDataSource, PublicBidRadio3ChoiceDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_menu;


/**
 建造师查询
 */
@property (weak, nonatomic) IBOutlet UIView *v_person;
@property (weak, nonatomic) IBOutlet UITextField *tf_personName;
@property (weak, nonatomic) IBOutlet UIButton *btn_searchType;
- (IBAction)btn_searchType_pressed:(id)sender;


/**
 企业查询
 */
@property (weak, nonatomic) IBOutlet UIView *v_company;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_serachButton_top;

@property (weak, nonatomic) IBOutlet UITextField *tf_companyName;
@end
