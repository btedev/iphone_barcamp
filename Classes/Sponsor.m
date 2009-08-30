//
//  Sponsor.m
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Sponsor.h"
#import "CJSONDeserializer.h"

@implementation Sponsor

@synthesize name, level, link;

+ (NSArray *)loadSponsorsFromJsonString:(NSString *)jsonString {
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
		
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"sponsors"]) {
		NSArray *sponsors = [dictionary objectForKey:@"sponsors"];
		for (NSDictionary *sponsor in sponsors) {
			NSDictionary *innerDict = [sponsor valueForKey:@"sponsor"];
			Sponsor *s = [[Sponsor alloc] initWithDictionary:innerDict];
			[objects addObject:s];
		}
	}
	
	return objects;
}

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.name = [dict objectForKey:@"name"];
		self.level = [dict objectForKey:@"level"];
		
		
		//try to parse a URL from the link string
		NSString *urlString = [dict objectForKey:@"homepage"];		
		@try {
			self.link = [NSURL URLWithString:urlString];
		}
		@catch (NSException * e) {
			NSLog(@"Sponsor link parse error: %@",e);
		}

	}
	return self;
}

- (void)dealloc{
	[name release];
	[link release];
	[level release];
	[super dealloc];
}

@end
