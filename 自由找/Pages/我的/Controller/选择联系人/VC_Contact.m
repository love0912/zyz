//
//  VC_Contact.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Contact.h"
#import "AddressUserDomain.h"
#import "VC_Phone.h"
#import <ContactsUI/ContactsUI.h>

@interface VC_Contact ()<UISearchControllerDelegate>
{
    NSMutableArray *_arr_all_person;
    NSMutableArray *_arr_sections;
    NSMutableArray *_arr_search;
    BOOL _isSearching;
    NSInteger _index;
    NSMutableArray *_arr_phones;
    NSString *_name;
    
    UISearchDisplayController *searchDisplayController;
}
@end

@implementation VC_Contact

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择联系人";
    [self zyzOringeNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choicePhoneSuccess:) name:@"CHOICE_PHONE_SUCCESS" object:nil];
    
    [ProgressHUD hideProgressHUD];
    [self initData];
    _index = 0;
    _arr_phones = [NSMutableArray arrayWithCapacity:0];
    _arr_search = [NSMutableArray array];
    _isSearching = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    // 添加 searchbar 到 headerview
    _tableView.tableHeaderView = searchBar;
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}

- (void)initData {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef friendList = ABAddressBookCopyArrayOfAllPeople(addressBook);
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];//这个是建立索引的核心
    
    _arr_all_person = [NSMutableArray arrayWithCapacity:1];
    long friendsCount = CFArrayGetCount(friendList);
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < friendsCount; i++) {
        AddressUserDomain *user = [[AddressUserDomain alloc] init];
        ABRecordRef record = CFArrayGetValueAtIndex(friendList, i);
        NSString *personname = (NSString *)CFBridgingRelease(ABRecordCopyCompositeName(record));
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            NSRange range=NSMakeRange(0,3);
            NSString *str=[personPhone substringWithRange:range];
            if ([str isEqualToString:@"+86"]) {
                personPhone=[personPhone substringFromIndex:3];
            }
            [user.phones addObject:personPhone];
        }
        user.name = personname;
        user.originIndex = i;
        [temp addObject:user];
    }
    
    for (AddressUserDomain *user in temp) {
        NSInteger sect = [theCollation sectionForObject:user collationStringSelector:@selector(getFirstName)];
        user.sectionNum = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        
        [sectionArrays addObject:sectionArray];
    }
    for (AddressUserDomain *user in temp) {
        [sectionArrays[user.sectionNum] addObject:user];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getFirstName)];
        [_arr_all_person addObject:sortedSection];
    }
    
    _arr_sections = [NSMutableArray array];
    for (int i = 0; i < 26; i ++) {
        NSString *tmpString = [NSString stringWithFormat:@"%c",'A'+i];
        [_arr_sections addObject:tmpString];
    }
    [_arr_sections addObject:[NSString stringWithFormat:@"%c",'#']];
    NSMutableArray *zero_count = [NSMutableArray array];
    for (int i = 0; i < _arr_all_person.count; i++) {
        NSArray *tmpArray = _arr_all_person[i];
        if (tmpArray.count == 0) {
            [zero_count insertObject:@(i) atIndex:0];
        }
    }
    
    for (int i = 0; i < zero_count.count; i++) {
        NSInteger index = [zero_count[i] integerValue];
        [_arr_all_person removeObjectAtIndex:index];
        [_arr_sections removeObjectAtIndex:index];
    }
}

- (void)backPressed {
    if (_index == 1) {
        _index = 0;
        [_tableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableView 
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return _arr_sections;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == _tableView) {
        return [_arr_sections indexOfObject:title];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return _arr_sections.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        NSArray *tmpArray = _arr_all_person[section];
        return tmpArray.count;
    } else {
        [_arr_search setArray:[self searchWithKey:searchDisplayController.searchBar.text InAddressArray:_arr_all_person]];
        return _arr_search.count;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return _arr_sections[section];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_Contact";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == _tableView) {
        AddressUserDomain *user = _arr_all_person[indexPath.section][indexPath.row];
        cell.textLabel.text = user.name;
    } else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        AddressUserDomain *user = _arr_search[indexPath.row];
        cell.textLabel.text = user.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressUserDomain *user;
    if (tableView == _tableView) {
        user = _arr_all_person[indexPath.section][indexPath.row];
    } else {
        user = _arr_search[indexPath.row];
    }
    
    if (user.phones.count == 0) {
        _addressBookChoice(user.name, @"");
        [self.navigationController popViewControllerAnimated:NO];
    } else if (user.phones.count == 1) {
        _addressBookChoice(user.name, user.phones.firstObject);
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        _name = user.name;
        [_arr_phones removeAllObjects];
        [_arr_phones addObjectsFromArray:user.phones];
        [self performSegueWithIdentifier:@"PhoneViewSegue" sender:_arr_phones];
    }
}

#pragma mark - search bar delegate
- (NSArray *)searchWithKey:(NSString *)key InAddressArray:(NSArray *)address {
    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *tmpArray in address) {
        [allArray addObjectsFromArray:tmpArray];
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS %@",key];
    NSArray *tmpArray = [allArray filteredArrayUsingPredicate:pred];
    return tmpArray;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)choicePhoneSuccess:(NSNotification *)notification {
    NSString *phone = notification.object;
    _addressBookChoice(_name, phone);
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PhoneViewSegue"]) {
        VC_Phone *aPhone_vc = segue.destinationViewController;
        aPhone_vc.arr_phone = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
