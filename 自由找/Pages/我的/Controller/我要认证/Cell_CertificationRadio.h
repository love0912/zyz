//
//  Cell_CertificationRadio.h
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CertificationRadioDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param result （int） 0 男 1女
 *  @param result （int） 0 技术标方案 1投标预算
 
 */
- (void)choiceSexRadioResult:(NSInteger)result;
- (void)choiceOrderRadioResult:(NSInteger)result;

@end
@interface Cell_CertificationRadio : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_radio1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_radio2_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_radio1;
@property (weak, nonatomic) IBOutlet UILabel *lb_radio2;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIButton *btn_radio1;
@property (weak, nonatomic) IBOutlet UIButton *btn_radio2;
- (IBAction)btn_radio1_pressed:(id)sender;
- (IBAction)btn_radio2_pressed:(id)sender;

@property (weak, nonatomic) id<CertificationRadioDelegate> delegate;

@property (assign, nonatomic) NSInteger type;
/**
 *  <#Description#>
 *
 *  @param result （int） 0 性别 1接单类型
 
 */
@property (assign, nonatomic) NSInteger cellType;
@end
