//
//  Sponsor.h
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sponsor : NSObject {
	NSString *name;
	NSString *level;
	NSURL *link;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSURL *link;

+ (NSArray *)loadSponsorsFromJsonString:(NSString *)jsonString;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
