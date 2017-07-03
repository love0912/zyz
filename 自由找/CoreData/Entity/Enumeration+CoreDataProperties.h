//
//  Enumeration+CoreDataProperties.h
//  FreeJob
//
//  Created by guojie on 15/11/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Enumeration.h"

NS_ASSUME_NONNULL_BEGIN

@interface Enumeration (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSString *key;
@property (nullable, nonatomic, retain) NSString *enumtype;

@end

NS_ASSUME_NONNULL_END
