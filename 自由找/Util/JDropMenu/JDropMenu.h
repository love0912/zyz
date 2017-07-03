//
//  JDropMenu.h
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVImageDomain.h"


typedef void(^DropData)(KVImageDomain *dropData);

@interface JDropMenu : UIView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DropData dropData;

@property (assign, nonatomic) BOOL isShowing;

- (instancetype)initWithdataSource:(NSArray<KVImageDomain *> *)dataSource fromTop:(BOOL)top margin:(CGFloat)margin;

- (void)showInView:(UIView *)view selectData:(KVImageDomain *)selectData dropData:(void (^)(KVImageDomain *dropData)) dropData;

- (void)dismiss;

@end
