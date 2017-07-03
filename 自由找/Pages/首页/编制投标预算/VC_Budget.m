//
//  VC_Budget.m
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Budget.h"
#import "NinaPagerView.h"
#import "ScrollView.h"
#import "VC_Tech_Buy.h"
#import "VC_Tech_Order.h"
#import "BidService.h"
#import "VC_Choice.h"

@interface VC_Budget ()<seletedControllerDelegate,UIScrollViewDelegate>
{
    ScrollView *titleScroll;
    UIScrollView *mainScroll;
    VC_Tech_Buy *_vc_buy;
    VC_Tech_Order *_vc_order;
    NSDictionary *_regionDic;
}
@end

@implementation VC_Budget

- (void)layoutUI {
    //创建头部视图(滑动视图)
    titleScroll= [[ScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    NSArray *mu = @[@"购买方案",@"编制接单"];
    
    titleScroll.headArray = mu.mutableCopy;
    
    //设置代理
    titleScroll.SeletedDelegate = self;
    //添加
    [self.view addSubview:titleScroll];
    
    //创建一个滑动视图用来滑动Viewcontroller
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    //设置代理
    mainScroll.delegate = self;
    //设置滑动区域
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH*mu.count, 0) ;
    //打开分页功能
    mainScroll.pagingEnabled = YES;
    //设置背景颜色
    mainScroll.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:mainScroll];
    //设置当前子控制器
    _vc_buy = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Buy"];
    _vc_buy.type = 2;
    _vc_buy.parameters = @{kPageType: @2};
    [self addChildViewController:_vc_buy];
    _vc_buy.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
    //将当前的子视图控制器的view添加到主滑动视图上
    [mainScroll addSubview:_vc_buy.view];
}

- (void)viewWillAppear:(BOOL)animated {
    //    [mainScroll scrollRectToVisible:CGRectMake(ScreenSize.width, 0, SCREEN_WIDTH, SCREEN_HEIGHT) animated:YES];
    //    [mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    if (self.parameters != nil) {
        if ([[self.parameters objectForKey:kPageType] integerValue] == 1) {
            UIButton *btn = [titleScroll viewWithTag:1001];
            if (btn != nil) {
                [self seletedControllerWith:btn];
            }
        }
    }
}

- (void)initData {
    _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:@"Tech_Budget"];
    if (_regionDic == nil) {
        _regionDic = @{kCommonKey: @"500000", kCommonValue: @"重庆市"};
        [self saveRegion];
    }
}

- (void)saveRegion {
    [CommonUtil saveObject:_regionDic forUserDefaultsKey:@"Tech_Budget"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"编制投标预算";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self showAreaItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeArea:) name:@"Tech_Buy_Change_Area" object:nil];
    
}

- (void)changeArea:(NSNotification *)notification {
    _regionDic = notification.object;
    [self saveRegion];
    UIBarButtonItem *rightItem = self.jx_navigationBar.items.firstObject.rightBarButtonItems.lastObject;
    rightItem.title = [NSString stringWithFormat:@"%@▼", _regionDic[kCommonValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_Tech_Buy" object:_regionDic];
}

- (void)showAreaItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@▼", _regionDic[kCommonValue]] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)hideAreaItem {
    [self setNavigationBarRightItem:nil];
}

- (void)rightItemPressed {
    [[BidService sharedService] getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        [selectArray addObject:_regionDic[kCommonKey]];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            _regionDic = resultDic;
            [self saveRegion];
            UIBarButtonItem *rightItem = self.jx_navigationBar.items.firstObject.rightBarButtonItems.lastObject;
            rightItem.title = [NSString stringWithFormat:@"%@▼", resultDic[kCommonValue]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_Tech_Buy" object:resultDic];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

-(void)backPressed{
    if ([[self.parameters objectForKey:@"pushType"]integerValue]==3) {
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_OurOrder_Refresh object:nil];
    }
    [self goBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (mainScroll.contentOffset.x < SCREEN_WIDTH) {
        if (_vc_order == nil) {
            _vc_order = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
            _vc_order.parameters = @{kPageType: @2};
            [self addChildViewController:_vc_order];
            _vc_order.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
            [mainScroll addSubview:_vc_order.view];
            _vc_order.type = 2;
        }
    }
    [titleScroll changeBtntitleColorWith:scrollView.contentOffset.x/SCREEN_WIDTH+1000];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [titleScroll changeBtntitleColorWith:scrollView.contentOffset.x/SCREEN_WIDTH+1000];
    [self changeAreaStatusWithScrollView:scrollView];
}

- (void)changeAreaStatusWithScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self hideAreaItem];
    } else {
        [self showAreaItem];
    }
}

#pragma mark -头部scrollView的代理方法的实现
-(void)seletedControllerWith:(UIButton *)btn{
    
    mainScroll.contentOffset = CGPointMake(SCREEN_WIDTH*(btn.tag - 1000), 0);
    
    if (mainScroll.contentOffset.x == SCREEN_WIDTH) {
        if (_vc_order == nil) {
            _vc_order = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
            _vc_order.parameters = @{kPageType: @2};
            [self addChildViewController:_vc_order];
            _vc_order.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [mainScroll addSubview:_vc_order.view];
            _vc_order.type = 2;
        }
    }
    [self changeAreaStatusWithScrollView:mainScroll];
    [titleScroll changeBtntitleColorWith:mainScroll.contentOffset.x/SCREEN_WIDTH+1000];
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
