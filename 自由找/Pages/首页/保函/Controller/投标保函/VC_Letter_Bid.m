//
//  VC_Letter_Bid.m
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Letter_Bid.h"
#import "Cell_Letter_Bid.h"
#import "BidLetterDomain.h"
#import "LetterService.h"
#import "BidLetterHeaderView.h"
#import "JHHeaderFlowLayout.h"

#import "BidService.h"
#import "VC_Choice.h"
#define Scale 1.307

@interface VC_Letter_Bid ()<BidLetterHeaderCityChoiceDelegate>
{
    JHHeaderFlowLayout * _collectionViewFlowLayout;
    NSMutableArray *_arr_menu;
    LetterService *_letterService;
    NSInteger _page;
    NSDictionary *_regionDic;
    BidLetterHeaderView *_headerView;
}
@end

@implementation VC_Letter_Bid

- (void)initData {
    _letterService = [LetterService sharedService];
    _arr_menu = [NSMutableArray arrayWithCapacity:0];
    _regionDic = @{kCommonKey: @"", kCommonValue:@"选择省市"};
//    [self getBidLetters];
}

- (void)getBidLetters {
    [_letterService getBidLetterListByRegion:_regionDic page:_page result:^(NSInteger code, NSArray<BidLetterDomain *> *list) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (code == 1) {
            if (_page == 1) {
                [_arr_menu removeAllObjects];
            }
            [_arr_menu addObjectsFromArray:list];
            [_collectionView reloadData];
            if (list.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (void)layoutUI {
    _collectionViewFlowLayout = [[JHHeaderFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWidth = (ScreenSize.width - 28) / 2;
    _collectionViewFlowLayout.itemSize = CGSizeMake(itemWidth, itemWidth * Scale);
    
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView.collectionViewLayout=_collectionViewFlowLayout;
    
    [self downRefresh];
    [self upRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"投标保函";
    self.jx_navigationBar.hidden = YES;
    [self initData];
    [self layoutUI];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_collectionView.mj_footer resetNoMoreData];
        _page = 1;
        [self getBidLetters];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getBidLetters];
    }];
}

#pragma mark - collection deletate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arr_menu.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell_Letter_Bid";
    Cell_Letter_Bid * cell  =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    BidLetterDomain *bidLetter = [_arr_menu objectAtIndex:indexPath.row];
    cell.bidLetter = bidLetter;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BidLetterDomain *bidLetter = [_arr_menu objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_Letter_Detail" storyboard:Storyboard_Main parameters:@{kPageDataDic: bidLetter} parent:self];
    
//    [PageJumpHelper pushToVCID:@"VC_Letter_Detail" storyboard:Storyboard_Main parent:self];
    
}
// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"BidLetterHeaderView" forIndexPath:indexPath];
        _headerView.delegate = self;
        _headerView.city = _regionDic[kCommonValue];
        reusableview = _headerView;
    }
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, (104.f / 375.f) * SCREEN_WIDTH);
}

#pragma mark - city choice
- (void)cityChoice {
    [[BidService sharedService] getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        [selectArray addObject:_regionDic[kCommonKey]];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        KeyValueDomain *native = dataArray.firstObject;
        if ([native.Key isEqualToString:@"0"]) {
            native.Value = @"最优惠";
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            _regionDic = resultDic;
//            _headerView.city = resultDic[kCommonValue];
            [self.collectionView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_backToTop_pressed:(id)sender {
    [_collectionView scrollRectToVisible:CGRectMake(0, -_headerView.height, SCREEN_WIDTH, SCREEN_HEIGHT) animated:YES];
}
@end
