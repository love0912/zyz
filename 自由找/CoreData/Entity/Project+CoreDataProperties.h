//
//  Enumeration+CoreDataProperties.h
//  
//
//  Created by guojie on 16/4/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSNumber *projectId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *contact;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *openDate;
@property (nullable, nonatomic, retain) NSString *money;
@property (nullable, nonatomic, retain) NSString *remark;

@end

NS_ASSUME_NONNULL_END
