//
//  Cell_LetterCompanyDesc.h
//  zyz
//
//  Created by 郭界 on 17/1/19.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellLetterCompanyDescDelegate <NSObject>

- (void)showBigImageByImageUrlString:(NSString *)imgUrl;

@end

@interface Cell_LetterCompanyDesc : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_2;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_3;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbDetail_top;

@property (assign, nonatomic) id<CellLetterCompanyDescDelegate> delegate;

@end
