//
//  JAddressPicker.h
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JAddressPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,copy) void (^completion)(NSString *provinceName,NSString *cityName,NSString *countyName);

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName;//显示 省 市 县名

@end
