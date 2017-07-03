//
//  VC_Contact.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import <AddressBook/AddressBook.h>

typedef void(^AddressBookChoice)(NSString *name, NSString *phone);

@interface VC_Contact : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AddressBookChoice addressBookChoice;

@end
