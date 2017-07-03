//
//  VC_ScanResult.h
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ScanResult : VC_Base

@property (weak, nonatomic) UIViewController *delegate;

- (IBAction)btn_return_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_return;
@property (weak, nonatomic) IBOutlet UILabel *lb_result;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@end
