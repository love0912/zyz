//
//  VC_QueryQualification.h
//  自由找
//
//  Created by xiaoqi on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_PublishBidRadio.h"
#import "Cell_QueryCompanyName.h"
#import "Cell_QueryOtherAttribute.h"
#import "QualificaService.h"
#import "NewCompanyView.h"
#import "Cell_PublishBidRadio3.h"
@interface VC_QueryQualification : VC_Base<NewCompanyTopDelegate,PublicBidRadioChoiceDelegate,UITableViewDataSource, UITableViewDelegate,PublicBidRadio3ChoiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnBottom;
@property (weak, nonatomic) IBOutlet UITextField *tf_companyName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_companyHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)btn_query_press:(id)sender;
@end
