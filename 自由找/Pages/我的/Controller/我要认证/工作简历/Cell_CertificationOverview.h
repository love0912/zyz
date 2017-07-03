//
//  Cell_CertificationOverview.h
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CertificationOverviewDelegate <NSObject>
- (void)contentResult:(NSString *)result;
@end

@interface Cell_CertificationOverview : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@property(assign,nonatomic)id<CertificationOverviewDelegate> delegate;
@end
