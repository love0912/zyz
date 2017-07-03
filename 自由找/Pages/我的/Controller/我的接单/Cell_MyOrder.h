//
//  Cell_MyOrder.h
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OurProjectOrderDomain.h"
@protocol MyOrderDelegate <NSObject>
- (void)clickPhoneResult:(NSString *)resultPhone;
- (void)clickChatResult:(NSString *)resultChatID;
- (void)clickAddendumResult:(NSString *)resultAddendum;
- (void)clickMoneyResult:(WalletRecordDomain *)resultMoney;
@end

@interface Cell_MyOrder : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_projectName;
@property (weak, nonatomic) IBOutlet UIButton *projectType;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
- (IBAction)btn_phoneLabel_pressed:(id)sender;

- (IBAction)btn_phone_press:(id)sender;
- (IBAction)btn_chat_press:(id)sender;
- (IBAction)btn_seeaddendum_press:(id)sender;
- (IBAction)btn_seeMoney_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_seeMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnWidth;
@property (weak, nonatomic) IBOutlet UIButton *btn_seeaddenum;
@property (weak, nonatomic) IBOutlet UIImageView *iv_chatRed;
@property (weak, nonatomic) IBOutlet UIImageView *iv_addendumRed;
@property (weak, nonatomic) IBOutlet UIImageView *iv_moneyRed;
@property (weak, nonatomic) id<MyOrderDelegate> delegate;
@property (strong, nonatomic) OurProjectOrderDomain *myorder;
@property (strong, nonatomic)WalletRecordDomain *walletRecord;
@property (weak, nonatomic) IBOutlet UILabel *lb_productTypeCount;
@end
