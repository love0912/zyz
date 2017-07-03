//
//  VC_Quality.m
//  自由找
//
//  Created by guojie on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Quality.h"
#import "ChineseData.h"
#import "pinyin.h"
#import "VC_Limit.h"

@interface VC_Quality ()
{
    NSMutableArray *_arr_disabled;
    NSMutableDictionary *_dic_selected;
    UISearchDisplayController *searchDisplayController;
    BOOL _isSearching;
    NSMutableArray *_arr_search;
    UISearchBar *_searchBar;
}
@property (nonatomic, strong) NSMutableArray *arr_all;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;
@end

@implementation VC_Quality

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择资质";
    [self zyzOringeNavigationBar];
    [self hideTableViewFooter:_tableView];
    _arr_search = [NSMutableArray array];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate=self;
    // 添加 searchbar 到 headerview
    _tableView.tableHeaderView = _searchBar;
    // 并把 searchDisplayController 和当前 controller 关联起来
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
//    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
//    searchDisplayController.searchResultsDelegate = self;
//    searchDisplayController.delegate = self;
//    searchDisplayController.displaysSearchBarInNavigationBar = YES;
//    searchDisplayController.searchContentsController.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    searchDisplayController.searchResultsDelegate = self;
     _isSearching = NO;
    BOOL find = NO;
    NSInteger section = 0, row = 0;
    if (_dic_selected != nil) {
        for (int i = 0; i < _arr_all.count; i ++) {
            NSArray *tmpArray = [_arr_all objectAtIndex:i];
            for (int j = 0; j < tmpArray.count; j++) {
                NSDictionary *tmpDic = tmpArray[j];
                if ([tmpDic[kCommonKey] hasPrefix:_dic_selected[kTopKey]]) {
                    find = YES;
                    section = i;
                    row = j;
                    break;
                }
                
            }
            if (find) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
}

- (void)setDataArray:(NSArray *)allArray disabledArray:(NSArray *)disableArray selectedData:(NSDictionary *)selectedDic {
    //    NSLog(@"%@", allArray);
    _sectionHeadsKeys = [NSMutableArray array];
    _arr_all = [self getChineseStringArr:allArray];
    if (disableArray != nil) {
        _arr_disabled = [NSMutableArray arrayWithArray:disableArray];
    }
    if (selectedDic != nil) {
        _dic_selected = [NSMutableDictionary dictionaryWithDictionary:selectedDic];
    }
}

- (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    NSMutableArray *charactorArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        NSDictionary *tmpDic = arrToSort[i];
        
        ChineseData *chineseData=[[ChineseData alloc]init];
        chineseData.string=[NSString stringWithString:tmpDic[kCommonValue]];
        chineseData.dataDic = [NSDictionary dictionaryWithDictionary:tmpDic];
        if(chineseData.string==nil){
            chineseData.string=@"";
        }
        
        if(![chineseData.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseData.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseData.string characterAtIndex:j])] uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseData.pinYin = pinYinResult;
        } else {
            chineseData.pinYin = @"";
        }
        if (!_jianliFirst && [chineseData.pinYin hasPrefix:@"#"]) {
            [charactorArray addObject:chineseData];
        } else {
            [chineseStringsArray addObject:chineseData];
        }
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseData *chineseStr = (ChineseData *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            ChineseData *tmpData = [chineseStringsArray objectAtIndex:index];
            [TempArrForGrouping addObject:tmpData.dataDic];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    for (int index = 0; index < charactorArray.count; index ++) {
        ChineseData *chineseStr = (ChineseData *)[charactorArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            ChineseData *tmpData = [charactorArray objectAtIndex:index];
            [TempArrForGrouping addObject:tmpData.dataDic];
            if(checkValueAtIndex == NO)
            {
                //                if (_jianliFirst) {
                //                    [arrayForArrays insertObject:TempArrForGrouping atIndex:0];
                //                } else {
                //                    [arrayForArrays addObject:TempArrForGrouping];
                //                }
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    
    return arrayForArrays;
}


#pragma mark - search delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
         _isSearching = NO;
        [_arr_search setArray:_arr_all];
    } else {
         _isSearching = YES;
       [_arr_search setArray:[self searchWithKey:_searchBar.text InQualityAll:_arr_all]];
    }
    [_tableView reloadData];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    _isSearching = YES;
//    [_arr_search setArray:[self searchWithKey:_searchBar.text InQualityAll:_arr_all]];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        _isSearching = NO;
        [_tableView reloadData];
        //        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //        [messageTableView scrollToRowAtIndexPath:firstPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        _isSearching = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (NSArray *)searchWithKey:(NSString *)key InQualityAll:(NSArray *)qualites {
    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *tmpArray in qualites) {
        [allArray addObjectsFromArray:tmpArray];
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Value CONTAINS %@",key];
    NSArray *tmpArray = [allArray filteredArrayUsingPredicate:pred];
    return tmpArray;
    
}

- (void)setChoiceResult:(NSDictionary *)resultDic {
    self.choiceQualityBlock(resultDic);
}

#pragma mark - tableview
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearching) {
        return 1;
    }else{
        return _arr_all.count;

    }
//    if (tableView == _tableView) {
//            }
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView == _tableView) {
//        return [[_arr_all objectAtIndex:section] count];
//    } else {
//        [_arr_search setArray:[self searchWithKey:searchDisplayController.searchBar.text InQualityAll:_arr_all]];
//        return _arr_search.count;
//    }
    if (_isSearching) {
        [_arr_search setArray:[self searchWithKey:_searchBar.text InQualityAll:_arr_all]];
        return _arr_search.count;
    }else{
        return [[_arr_all objectAtIndex:section] count];

    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (tableView == _tableView) {
//        return [_sectionHeadsKeys objectAtIndex:section];
//    } else {
//        return @"";
//    }
    if (_isSearching) {
        return @"";

    }else{
        return [_sectionHeadsKeys objectAtIndex:section];

        
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (tableView == _tableView) {
//        return self.sectionHeadsKeys;
//    }
//    return 0;
    if (_isSearching) {
        return 0;
    }else{
        return self.sectionHeadsKeys;
        
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Quality";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic;
//    if (tableView == _tableView) {
//        //        cell.contentView.backgroundColor = [UIColor whiteColor];
//        //        cell.textLabel.backgroundColor = [UIColor whiteColor];
//        cell.accessoryView = nil;
//        tmpDic = _arr_all[indexPath.section][indexPath.row];
//        cell.textLabel.text = tmpDic[kCommonValue];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//    } else {
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        //        cell.contentView.backgroundColor = [UIColor whiteColor];
//        //        cell.textLabel.backgroundColor = [UIColor whiteColor];
//        cell.accessoryView = nil;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        tmpDic = _arr_search[indexPath.row];
//        cell.textLabel.text = tmpDic[kCommonValue];
//    }
    if (_isSearching) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //        cell.contentView.backgroundColor = [UIColor whiteColor];
        //        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tmpDic = _arr_search[indexPath.row];
        cell.textLabel.text = tmpDic[kCommonValue];

    }else{
        cell.accessoryView = nil;
        tmpDic = _arr_all[indexPath.section][indexPath.row];
        cell.textLabel.text = tmpDic[kCommonValue];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    if (_arr_disabled != nil && _arr_disabled.count > 0) {
        if ([self hasDisabledEnum:tmpDic[kCommonKey]]) {
            //            cell.contentView.backgroundColor = [UIColor lightGrayColor];
            //            cell.textLabel.backgroundColor = [UIColor lightGrayColor];
            UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quality_selected"]];
            cell.accessoryView = v;
        }
    }
    if (_dic_selected != nil) {
        NSString *key = _dic_selected[kTopKey];
        //        if ([key isEqualToString:tmpDic[kNewEnunKey]]) {
        //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //        }
        if ([tmpDic[kCommonKey] hasPrefix:key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (BOOL)hasDisabledEnum:(NSString *)key {
    BOOL disabled = NO;
    for (NSString *tmpKey in _arr_disabled) {
        if ([key hasPrefix:tmpKey]) {
            disabled = YES;
            break;
        }
    }
    
    //    if ([_arr_disabled indexOfObject:key] != NSNotFound) {
    //        return YES;
    //    }
    return disabled;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isSearching)  {
                NSDictionary *tmpDic = _arr_search[indexPath.row];
                if (_arr_disabled != nil && [self hasDisabledEnum:tmpDic[kCommonKey]]) {
                    return;
                }
                NSArray *tmpArray = tmpDic[kNewSubCollection];
                NSDictionary *subDic = tmpArray[0];
                NSString *value = subDic[kCommonValue];
                if ([value isEqualToString:@""]) {
                    //直接返回
                    NSString *title =tmpDic[kCommonValue];
                    NSDictionary *resultDic = @{kCommonKey: subDic[kCommonKey], kCommonValue: title ,kTopKey: tmpDic[kCommonKey]};
                    self.choiceQualityBlock(resultDic);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self performSegueWithIdentifier:@"Segue_Quality_Limit" sender:tmpDic];
                }

            } else {
                NSDictionary *tmpDic = _arr_all[indexPath.section][indexPath.row];
                if (_arr_disabled != nil && [self hasDisabledEnum:tmpDic[kCommonKey]]) {
                    return;
                }
                NSArray *tmpArray = tmpDic[kNewSubCollection];
                NSDictionary *subDic = tmpArray[0];
                NSString *value = subDic[kCommonValue];
                if ([value isEqualToString:@""]) {
                    //直接返回
                    NSString *title =tmpDic[kCommonValue];
                    NSDictionary *resultDic = @{kCommonKey: subDic[kCommonKey], kCommonValue: title ,kTopKey: tmpDic[kCommonKey]};
                    self.choiceQualityBlock(resultDic);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self performSegueWithIdentifier:@"Segue_Quality_Limit" sender:tmpDic];
                }

           }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_Quality_Limit"]) {
        VC_Limit *qualityLimit_vc = segue.destinationViewController;
        NSDictionary *tmpDic = sender;
        if (_dic_selected != nil) {
            [qualityLimit_vc setDataDic:tmpDic selectKey:_dic_selected[kLimitKey] delegate:self];
        } else {
            [qualityLimit_vc setDataDic:tmpDic selectKey:nil delegate:self];
        }
        
    }
}

@end
