//
//  BidLetterHeaderView.h
//  zyz
//
//  Created by 郭界 on 16/11/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BidLetterHeaderCityChoiceDelegate <NSObject>

- (void)cityChoice;

@end

@interface BidLetterHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *btn_city;
- (IBAction)btn_city_pressed:(id)sender;

@property (strong, nonatomic) NSString *city;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;

@property (assign, nonatomic) id<BidLetterHeaderCityChoiceDelegate> delegate;

@end
