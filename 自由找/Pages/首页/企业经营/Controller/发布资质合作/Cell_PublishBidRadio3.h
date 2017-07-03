//
//  Cell_PublishBidRadio3.h
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublicBidRadio3ChoiceDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param result （int） 0-不限 1- 本地企业 2 - 外地企业
 
 */
- (void)choiceRadio3Result:(NSInteger)result;

@end

@interface Cell_PublishBidRadio3 : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn2_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn3_left;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

- (IBAction)btn1_pressed:(id)sender;
- (IBAction)btn2_pressed:(id)sender;
- (IBAction)btn3_pressed:(id)sender;

@property (weak, nonatomic) id<PublicBidRadio3ChoiceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_otherCompany;
@property (assign, nonatomic) NSInteger type;
@property(strong,nonatomic)NSDictionary *dic;
@property (assign, nonatomic) NSInteger pushType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_leading;

@property (nonatomic, strong) NSString *otherCompanyName;
@end
