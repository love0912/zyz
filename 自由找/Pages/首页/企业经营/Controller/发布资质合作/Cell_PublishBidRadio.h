//
//  Cell_PublishBidRadio.h
//  自由找
//
//  Created by guojie on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublicBidRadioChoiceDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param result （int） 1 满足任意个 0同时具备

 */
- (void)choiceRadioResult:(NSInteger)result;

@end

@interface Cell_PublishBidRadio : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_radio1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_radio2_left;

@property (weak, nonatomic) IBOutlet UIButton *btn_radio1;
@property (weak, nonatomic) IBOutlet UIButton *btn_radio2;
- (IBAction)btn_radio1_pressed:(id)sender;
- (IBAction)btn_radio2_pressed:(id)sender;

@property (weak, nonatomic) id<PublicBidRadioChoiceDelegate> delegate;

@property (assign, nonatomic) NSInteger type;

@end
