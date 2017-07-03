//
//  VC_MainTab.m
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MainTab.h"
#import "CommonUtil.h"

#define kCountWidth 16

@interface VC_MainTab ()

@end

@implementation VC_MainTab

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1.0];
    
    [self initTabs];
    [self layoutTabs];
    
    [self.tabBar setBackgroundImage:[CommonUtil imageWithColor:[UIColor whiteColor]]];
    [self.tabBar setShadowImage:[CommonUtil imageWithColor:[UIColor whiteColor]]];
    
    [self layoutCountLabel];
}

- (void)initTabs {
    NSMutableArray *arr_vc = [NSMutableArray arrayWithCapacity:3];
    UIStoryboard *tb_home = [UIStoryboard storyboardWithName:@"TB" bundle:nil];
//    UIStoryboard *tb_1 = [UIStoryboard storyboardWithName:@"TB1" bundle:nil];
    UIStoryboard *tb_2 = [UIStoryboard storyboardWithName:@"TB1" bundle:nil];
    UIStoryboard *tb_3 = [UIStoryboard storyboardWithName:@"TB2" bundle:nil];
    UINavigationController *homeNav = [tb_home instantiateInitialViewController];
    homeNav.title = @"首页";
//    UINavigationController *tb1Nav = [tb_1 instantiateInitialViewController];
//    tb1Nav.title = @"购买服务";
    UINavigationController *tb2Nav = [tb_2 instantiateInitialViewController];
    tb2Nav.title = @"消息";
    UINavigationController *tb3Nav = [tb_3 instantiateInitialViewController];
    tb3Nav.title = @"我的";
    
    [arr_vc addObject:homeNav];
//    [arr_vc addObject:tb1Nav];
    [arr_vc addObject:tb2Nav];
    [arr_vc addObject:tb3Nav];
    [self setViewControllers:arr_vc];
}

- (void)layoutTabs {
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
//    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    [item setTitleTextAttributes:[self itemAttribute] forState:UIControlStateSelected];
    [item setImage:[[UIImage imageNamed:@"tab_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[[UIImage imageNamed:@"tab_0_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    [item1 setTitleTextAttributes:[self itemAttribute] forState:UIControlStateSelected];
//    [item1 setImage:[[UIImage imageNamed:@"tab_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item1 setSelectedImage:[[UIImage imageNamed:@"tab_1_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item2 setTitleTextAttributes:[self itemAttribute] forState:UIControlStateSelected];
    [item2 setImage:[[UIImage imageNamed:@"tab_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab_2_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item3 setTitleTextAttributes:[self itemAttribute] forState:UIControlStateSelected];
    [item3 setImage:[[UIImage imageNamed:@"tab_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"tab_3_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    /* 设置字体大小  */
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:13.0],NSFontAttributeName,nil] forState:UIControlStateHighlighted];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
}

- (void)layoutCountLabel {
    _lb_msgCount = [self setUpCountLabel];
    //四个选项卡
//    CGFloat x = ceilf(self.tabBar.bounds.size.width * 0.64);
//    CGFloat y = ceilf(self.tabBar.bounds.size.height * 0.05);
    
    //三个选项卡
    CGFloat x = ceilf(self.tabBar.bounds.size.width * 0.512);
    CGFloat y = ceilf(self.tabBar.bounds.size.height * 0.05);
//    _lb_msgCount.text = @"6";
    _lb_msgCount.frame = CGRectMake(x, y, kCountWidth, kCountWidth);
    [self.tabBar addSubview:_lb_msgCount];
    _lb_msgCount.hidden = YES;
    
    _lb_mineCount = [self setUpCountLabel];
    //四个tabbaritem
//    CGFloat x2 = ceilf(self.tabBar.bounds.size.width * 0.89);
//    CGFloat y2 = ceilf(self.tabBar.bounds.size.height * 0.05);
    
    //三个tabbaritem
    CGFloat x2 = ceilf(self.tabBar.bounds.size.width * 0.842);
    CGFloat y2 = ceilf(self.tabBar.bounds.size.height * 0.05);
//    _lb_mineCount.text = @"7";
    _lb_mineCount.frame = CGRectMake(x2, y2, 8, 8);
    _lb_mineCount.hidden = YES;
    _lb_mineCount.layer.masksToBounds = YES;
    _lb_mineCount.layer.cornerRadius = 4;
    _lb_mineCount.textColor = [UIColor redColor];
    [self.tabBar addSubview:_lb_mineCount];
    
}


- (UILabel *)setUpCountLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCountWidth, kCountWidth)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = kCountWidth / 2;
    return label;
}

- (NSDictionary *)itemAttribute {
    UIColor *selectTitleColor = [UIColor orangeColor];
    return @{NSForegroundColorAttributeName: selectTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:19]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setMsgCount:(NSInteger)msgCount {
    if (msgCount == 0) {
        _lb_msgCount.text = @"0";
        _lb_msgCount.hidden = YES;
    } else {
        _lb_msgCount.hidden = NO;
        _lb_msgCount.text = [NSString stringWithFormat:@"%ld", msgCount];
    }
}

- (void)setMineCount:(NSInteger)mineCount {
    if (mineCount == 0) {
        _lb_mineCount.text = @"0";
        _lb_mineCount.hidden = YES;
    } else {
        _lb_mineCount.hidden = NO;
        _lb_mineCount.text = [NSString stringWithFormat:@"%ld", mineCount];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
