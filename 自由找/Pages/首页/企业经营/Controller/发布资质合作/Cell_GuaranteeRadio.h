//
//  Cell_GuaranteeRadio.h
//  自由找
//
//  Created by xiaoqi on 16/7/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuaranteeRadioChoiceDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param result （int） 0-不限 1- 现金 2 - 银行保函
 
 */
- (void)choiceGuaranteeRadioResult:(NSInteger)result;

@end
@interface Cell_GuaranteeRadio : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn2_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btn3_left;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

- (IBAction)btn1_pressed:(id)sender;
- (IBAction)btn2_pressed:(id)sender;
- (IBAction)btn3_pressed:(id)sender;

@property (weak, nonatomic) id<GuaranteeRadioChoiceDelegate> delegate;

@property (assign, nonatomic) NSInteger type;
@end
