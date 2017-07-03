//
//  Cell_CSearchResult.h
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDomain.h"

@interface Cell_CSearchResult : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_call;
- (IBAction)btn_call_pressed:(id)sender;

@property (strong, nonatomic) CustomerDomain *customer;

@end
