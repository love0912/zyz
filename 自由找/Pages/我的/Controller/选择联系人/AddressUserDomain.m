//
//  AddressUserDomain.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "AddressUserDomain.h"
#import "pinyin.h"

@implementation AddressUserDomain
@synthesize name, phones;
@synthesize sectionNum, originIndex;

- (id)init {
    self = [super init];
    if (self) {
        phones = [NSMutableArray array];
    }
    return self;
}

- (NSString *)getFirstName {
    if ([name canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
        return name;
    }
    else { //如果是非英语
        //        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])];
        
        char first=pinyinFirstLetter([name characterAtIndex:0]);
        NSString *sectionName;
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            if([self searchResult:name searchText:@"曾"])
                sectionName = @"Z";
            else if([self searchResult:name searchText:@"解"])
                sectionName = @"X";
            else if([self searchResult:name searchText:@"仇"])
                sectionName = @"Q";
            else if([self searchResult:name searchText:@"朴"])
                sectionName = @"P";
            else if([self searchResult:name searchText:@"查"])
                sectionName = @"Z";
            else if([self searchResult:name searchText:@"能"])
                sectionName = @"N";
            else if([self searchResult:name searchText:@"乐"])
                sectionName = @"Y";
            else if([self searchResult:name searchText:@"单"])
                sectionName = @"S";
            else
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])] uppercaseString];
        }
        else {
            sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        return sectionName;
    }
}

-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

@end
