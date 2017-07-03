//
//  VC_Tech_Buy.m
//  自由找
//
//  Created by guojie on 16/7/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Tech_Buy.h"
#import "Cell_Tech_Buy.h"
#import "ProductService.h"
#import "VC_Choice.h"

#define Scale 1.307

@interface VC_Tech_Buy (){
    NSArray *_arr_cellBg;
    UICollectionViewFlowLayout * _collectionViewFlowLayout;
    ProductService *_productService;
    
    NSMutableArray *_arr_menu;
    NSDictionary *_regionDic;
}

@end

@implementation VC_Tech_Buy

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"购买";
    self.jx_navigationBar.hidden = YES;
    [self layoutUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"Notification_Refresh_Tech_Buy" object:nil];
}

- (void)refreshList:(NSNotification *)notification {
    NSDictionary *regionDic = notification.object;
    if (regionDic != nil) {
        _regionDic = regionDic;
    }
    [self getProducts];
}

-(void)layoutUI{
    _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
//    if (IS_IPHONE_5_OR_LESS) {
//        _collectionViewFlowLayout.itemSize=CGSizeMake((ScreenSize.width-28)/2,183);
//    }else{
//        _collectionViewFlowLayout.itemSize=CGSizeMake((ScreenSize.width-28)/2,220);
//    }
    CGFloat itemWidth = (ScreenSize.width - 28) / 2;
    _collectionViewFlowLayout.itemSize = CGSizeMake(itemWidth, itemWidth * Scale);
    
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView.collectionViewLayout=_collectionViewFlowLayout;
}
-(void)loadData{
    if (_type == 1) {
        _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:@"Tech_Buy"];
    } else {
        _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:@"Tech_Budget"];
    }
    
    if (_regionDic == nil) {
        _regionDic = @{kCommonKey: @"500000", kCommonValue: @"重庆市"};
    }
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        _arr_cellBg = @[@"jishu_Buy_1", @"jishu_Buy_2", @"jishu_Buy_3", @"jishu_Buy_4"];
    } else if (_type == 2) {
        //cell背景图
        _arr_cellBg=@[@"yusuan_buy_1",@"yusuan_buy_2",@"yusuan_buy_3",@"yusuan_buy_4"];
    }
    
    _productService = [ProductService sharedService];
    
    [self getProducts];
}

- (void)getProducts {
//    [_productService getProductListWithType:_type result:^(NSInteger code, NSArray<ProductDomain *> *list) {
//        if (code == 1 && list.count > 0) {
//            _arr_menu  = [NSMutableArray arrayWithArray:list];
//            [_collectionView reloadData];
//        } else {
//            [ProgressHUD showInfo:@"获取产品列表失败,请稍后再试" withSucc:NO withDismissDelay:2];
//            [self goBack];
//        }
//    }];
    [_productService getProductListWithRegion:_regionDic type:_type result:^(NSInteger code, NSArray<ProductDomain *> *list) {
        if (code == 1 && list.count > 0) {
            _arr_menu  = [NSMutableArray arrayWithArray:list];
            [_collectionView reloadData];
        } else {
            [ProgressHUD showInfo:@"获取产品列表失败,请稍后再试" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
    
}
//- (void)setType:(NSInteger)type {
//    _type = type;
//    if (type == 0) {
//        _arr_cellBg = @[@"jishu_Buy_1", @"jishu_Buy_2", @"jishu_Buy_3", @"jishu_Buy_4"];
//    } else {
//        //cell背景图
//        _arr_cellBg=@[@"yusuan_buy_1",@"yusuan_buy_2",@"yusuan_buy_3",@"yusuan_buy_4"];
//    }
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arr_menu.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell_Tech_Buy";
    Cell_Tech_Buy * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.iv_bg.image=[UIImage imageNamed:_arr_cellBg[indexPath.row]];
////    cell.backgroundColor=[UIColor colorWithHex:@"F4F4F4"];
//    [cell initView];
    
    
    ProductDomain *product = [_arr_menu objectAtIndex:indexPath.row];
    cell.product = product;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDomain *product = [_arr_menu objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_TechBuy_Desc" storyboard:Storyboard_Main parameters:@{kPageDataDic: @{@"Product": product, @"Region": _regionDic}, kPageType: @(_type)} parent:self];
    
//    [_productService getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
//        if (code != 1) {
//            return;
//        }
//        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
//        vc_choice.type = @"3";
//        vc_choice.nav_title = @"请选择您项目所在地";
//        NSMutableArray *selectArray = [NSMutableArray array];
//        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
//        KeyValueDomain *native = dataArray.firstObject;
//        if ([native.Key isEqualToString:@"0"]) {
//            [dataArray removeObjectAtIndex:0];
//        }
//        [vc_choice setDataArray:dataArray selectArray:selectArray];
//        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
//            ProductDomain *product = [_arr_menu objectAtIndex:indexPath.row];
//            [PageJumpHelper pushToVCID:@"VC_TechBuy_Desc" storyboard:Storyboard_Main parameters:@{kPageDataDic: @{@"Product": product, @"Region": resultDic}, kPageType: @(_type)} parent:self];
//            
//        };
//        [self.navigationController pushViewController:vc_choice animated:YES];
//        
//    }];
    
    
    
//    [PageJumpHelper pushToVCID:@"VC_TechBuy_Desc" storyboard:Storyboard_Main parent:self];
}
// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, (104.f / 375.f) * SCREEN_WIDTH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"TechBuyHeader" forIndexPath:indexPath];
        [reusableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWebVC)]];
        
    }
    return reusableview;
}

- (void)showWebVC {
    if (_type == 1) {
        [CommonUtil jxWebViewShowInController:self loadUrl:@"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv6.html" backTips:nil];
    } else {
        [CommonUtil jxWebViewShowInController:self loadUrl:@"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv7.html" backTips:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
