//
//  VC_Technology.m
//  自由找
//
//  Created by guojie on 16/7/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Technology.h"
#import "NinaPagerView.h"
#import "ScrollView.h"
#import "VC_Tech_Buy.h"
#import "VC_Tech_Order.h"
#import "BidService.h"
#import "VC_Choice.h"

@interface VC_Technology ()<seletedControllerDelegate,UIScrollViewDelegate>
{
    ScrollView *titleScroll;
    UIScrollView *mainScroll;
    VC_Tech_Buy *_vc_buy;
    VC_Tech_Order *_vc_order;
    NSDictionary *_regionDic;
}

@end

@implementation VC_Technology

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
    _vc_buy.type = 1;
    _vc_buy.parameters = @{kPageType: @1};
    [self addChildViewController:_vc_buy];
    _vc_buy.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
    //将当前的子视图控制器的view添加到主滑动视图上
    [mainScroll addSubview:_vc_buy.view];
}


- (void)initData {
    _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:@"Tech_Buy"];
    if (_regionDic == nil) {
        _regionDic = @{kCommonKey: @"500000", kCommonValue: @"重庆市"};
        [self saveRegion:_regionDic];
    }
}

- (void)saveRegion:(NSDictionary *)regionDic {
    [CommonUtil saveObject:regionDic forUserDefaultsKey:@"Tech_Buy"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"工程技术标方案";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self showAreaItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeArea:) name:@"Tech_Buy_Change_Area" object:nil];
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

- (void)changeArea:(NSNotification *)notification {
    _regionDic = notification.object;
    [self saveRegion:_regionDic];
    UIBarButtonItem *rightItem = self.jx_navigationBar.items.firstObject.rightBarButtonItems.lastObject;
    rightItem.title = [NSString stringWithFormat:@"%@▼", _regionDic[kCommonValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_Tech_Buy" object:_regionDic];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.jx_title = @"投标技术标方案";
//    [self zyzOringeNavigationBar];
//    [self layoutUI];
//    
//    /**<  上方显示标题，如果您只传入  Titles showing on the topTab   **/
//    NSArray *titleArray =   @[
//                              @"购买方案",
//                              @"编制接单"
//                              ];
//    /**< 每个标题下对应的控制器，只需将您创建的控制器类名加入下列数组即可(注意:数量应与上方的titles数量保持一致，若少于titles数量，下方会打印您缺少相应的控制器，同时默认设置的最大控制器数量为10=。=)  。
//     ViewControllers to the titles on the topTab.Just add your VCs' Class Name to the array. Wanning:the number of ViewControllers should equal to the titles.Meanwhile,default max VC number is 10.
//     **/
//    NSArray *vcsArray = @[
//                          @"VC_Tech_Buy",
//                          @"VC_Tech_Order"
//                          ];
//    /**< 您可以选择是否要改变标题选中的颜色(默认为黑色)、未选中的颜色(默认为灰色)或者下划线的颜色(默认为色值是ff6262)。如果传入颜色数量不够，则按顺序给相应的部分添加颜色。
//     You can choose whether change your titles' selectColor(default is black),unselectColor(default is gray) and underline color(default is Color value ff6262).**/
//    NSArray *colorArray = @[
//                            [CommonUtil zyzOrangeColor], /**< 选中的标题颜色 Title SelectColor  **/
//                            [UIColor colorWithHex:@"666666"], /**< 未选中的标题颜色  Title UnselectColor **/
//                            [CommonUtil zyzOrangeColor], /**< 下划线颜色 Underline Color   **/
//                            ];
//    /**< 创建ninaPagerView，控制器第一次是根据您划的位置进行相应的添加的，类似网易新闻虎扑看球等的效果，后面再滑动到相应位置时不再重新添加，如果想刷新数据，您可以在相应的控制器里加入刷新功能，低耦合。需要注意的是，在创建您的控制器时，设置的frame为FUll_CONTENT_HEIGHT，即全屏高减去导航栏高度再减去Tabbar的高度，如果这个高度不是您想要的，您可以去UIParameter.h中进行设置XD。
//     A tip you should know is that when init the VCs frames,the default frame i set is FUll_CONTENT_HEIGHT,it means fullscreen height - NavigationHeight - TabbarHeight.If the frame is not what you want,just go to UIParameter.h to change it!XD**/
//    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray controllers:self isType:1];
////    NSLog(@"%@", ninaPagerView.parentViewController.childViewControllers);
//    
//    [self.view addSubview:ninaPagerView];
//}

- (void)showAreaItem {
    NSString *title = [NSString stringWithFormat:@"%@▼", _regionDic[kCommonValue]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
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
            [self saveRegion:_regionDic];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (mainScroll.contentOffset.x < SCREEN_WIDTH) {
        if (_vc_order == nil) {
            _vc_order = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
            _vc_order.parameters = @{kPageType: @1};
            [self addChildViewController:_vc_order];
            _vc_order.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
            [mainScroll addSubview:_vc_order.view];
            _vc_order.type = 1;
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
            _vc_order.parameters = @{kPageType: @1};
            [self addChildViewController:_vc_order];
            _vc_order.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
            [mainScroll addSubview:_vc_order.view];
            _vc_order.type = 1;
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
