//
//  VC_LetterAddressList.h
//  自由找
//
//  Created by 郭界 on 16/10/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_Address.h"

@interface VC_LetterAddressList : VC_Base<UITableViewDelegate, UITableViewDataSource, CellAddressDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_add_pressed:(id)sender;

@end
