//
//  VC_ChoiceIndex.m
//  zyz
//
//  Created by 郭界 on 17/1/17.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_ChoiceIndex.h"
#import "ChineseData.h"
#import "pinyin.h"

@interface VC_ChoiceIndex ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *_arr_disabled;
    NSMutableDictionary *_dic_selected;
    UISearchDisplayController *searchDisplayController;
    BOOL _isSearching;
    NSMutableArray *_arr_search;
    UISearchBar *_searchBar;
    NSArray *_selectArray;
    BOOL checked;
    NSInteger selectIndex;
    NSDictionary *_resultDic;
    
    NSString *_selectKey;
}

@property (nonatomic, strong) NSMutableArray *arr_all;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;

@end

@implementation VC_ChoiceIndex

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    if (_nav_title == nil || [_nav_title isEmptyString]) {
        _nav_title = @"请选择";
    }
    self.jx_title = _nav_title;
    
    if (_type == nil) {
        _type = @"0";
    }
    [self hideTableViewFooter:_tableView];
    _arr_search = [NSMutableArray array];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate=self;
    // 添加 searchbar 到 headerview
    _tableView.tableHeaderView = _searchBar;
    _isSearching = NO;
    
    BOOL find = NO;
    NSInteger section = 0, row = 0;
    if (_selectKey != nil) {
        for (int i = 0; i < _arr_all.count; i ++) {
            NSArray *tmpArray = [_arr_all objectAtIndex:i];
            for (int j = 0; j < tmpArray.count; j++) {
                NSDictionary *tmpDic = tmpArray[j];
                if ([tmpDic[kCommonKey] isEqualToString:_selectKey]) {
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

- (void)setDataArray:(NSArray *)allArray selectArray:(NSArray *)selectArray {
    _sectionHeadsKeys = [NSMutableArray array];
    _arr_all = [self getChineseStringArr:allArray];
    _selectArray = [NSArray arrayWithArray:selectArray];
//    if (selectArray.count == 1) {
//        checked = YES;
//        for (int i = 0; i < _arr_all.count; i ++) {
//            NSDictionary *keyValue = _arr_all[i];
//            NSString *checkString = selectArray[0];
//            NSString *tmpString = keyValue[kCommonKey];
//            if ([checkString isEqualToString:tmpString]) {
//                selectIndex = i;
//            }
//        }
//    }
    if (selectArray.count > 0) {
        _selectKey = selectArray.firstObject;
    }
    
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
    _isSearching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        _isSearching = NO;
        [_tableView reloadData];
        //        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //        [messageTableView scrollToRowAtIndexPath:firstPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    self.choiceBlock(resultDic);
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearching) {
        return 1;
    }else{
        return _arr_all.count;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
        NSDictionary *keyValue = _arr_all[indexPath.section][indexPath.row];
        cell.textLabel.text = keyValue[kCommonValue];
        if ([keyValue[kCommonKey] isEqualToString:_selectKey]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tmpDic;
    if (_isSearching)  {
        tmpDic = _arr_search[indexPath.row];
    } else {
        tmpDic = _arr_all[indexPath.section][indexPath.row];
    }
    self.choiceBlock(tmpDic);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

#pragma mark - 
- (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    NSMutableArray *charactorArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        NSDictionary *tmpDic = [arrToSort[i] toDictionary];
        
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
//        if (!_jianliFirst && [chineseData.pinYin hasPrefix:@"#"]) {
//            [charactorArray addObject:chineseData];
//        } else {
//            
//        }
        [chineseStringsArray addObject:chineseData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
