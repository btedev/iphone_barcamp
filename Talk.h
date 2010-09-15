//
//  Talk.h
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "ASIHTTPRequest.h"

@interface Talk :  NSManagedObject {
}

@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSNumber *roomId;
@property (nonatomic, retain) NSString * speaker;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate *day;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber *serverId;
@property (nonatomic, retain) NSDate *updatedAt;

+ (void)refreshTalks;
+ (Talk *)createInstance:(NSDictionary *)dict;
- (void)populateFromDictionary:(NSDictionary *)dict;

@end



