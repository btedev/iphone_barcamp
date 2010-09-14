//
//  Sponsor.h
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObjectContext+ActiveRecord.h"
#import "ASIHTTPRequest.h"

@interface Sponsor :  NSManagedObject <ASIHTTPRequestDelegate> {
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * link;

+ (void)refreshSponsors;

@end



