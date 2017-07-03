//
//  Cell_Address.h
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterAddressDomain.h"

@protocol CellAddressDelegate <NSObject>


/**
 按钮点击事件回调

 @param type 1 -- 编辑, 2 -- 删除, 3 -- 设为默认
 */
- (void)handleWithAddress:(LetterAddressDomain *)address type:(NSInteger)type;

@end

@interface Cell_Address : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

- (IBAction)btn_edit_pressed:(id)sender;
- (IBAction)btn_delete_pressed:(id)sender;
- (IBAction)btn_select_pressed:(id)sender;

@property (weak, nonatomic) id<CellAddressDelegate> delegate;

@property (strong, nonatomic) LetterAddressDomain *address;

@end
