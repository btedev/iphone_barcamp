//
//  ActiveRecordHelpers.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActiveRecordHelpers : NSObject {

}

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;

+ (void) setupDefaultCoreDataStack;
+ (void) setupDefaultCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

+ (void) migrateStoreIfNeeded:(NSString *) storeName;

@end
