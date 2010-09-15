// 
//  Talk.m
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import "Talk.h"
#import "BarCampAppDelegate.h"
#import "CJSONDeserializer.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation Talk 

@dynamic roomName;
@dynamic roomId;
@dynamic speaker;
@dynamic endTime;
@dynamic notes;
@dynamic title;
@dynamic day;
@dynamic startTime;
@dynamic serverId;
@dynamic updatedAt;

+ (void)refreshTalks {
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",delegate.baseUrlStr,@"talks.json"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

+ (void)requestFinished:(ASIHTTPRequest *)request {
	NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
	NSString *responseString = [request responseString];
	DDLogVerbose(@"%@",responseString);
		
	NSData *jsonData = [responseString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
		
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"talks"]) {
		NSArray *talks = [dictionary objectForKey:@"talks"];
		for (NSDictionary *talk in talks) {			
			NSDictionary *innerDict = [talk valueForKey:@"talk"];
			
			//check for existing talk with same serverId
			NSNumber *serverId = [innerDict objectForKey:@"id"];
			Talk *tTest = [Talk findFirstByAttribute:@"serverId" withValue:serverId];
			
			if (!tTest) {
				@try {
					[Talk createInstance:innerDict];
				}
				@catch (NSException * e) {
					DDLogError(@"Error creating talk: %@",innerDict);
				}				
									
			}//existing Talk test
		}//talks loop
	}//json sanity test
	
	if ([context hasChanges]) {
		if(![context save:&error]) {
			DDLogError(@"Failed to save talk to data store: %@", [error localizedDescription]);
		}
	}
}

+ (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	DDLogVerbose(@"Talk request failed: %@",[error localizedDescription]);
}

//Create Talk instance from a NSDictionary
+ (Talk *)createInstance:(NSDictionary *)dict {
	DDLogInfo(@"Adding talk %@",[dict objectForKey:@"name"]);
	Talk *talk = [NSEntityDescription insertNewObjectForEntityForName:@"Talk" 
											   inManagedObjectContext:[NSManagedObjectContext defaultContext]];
	
	[talk populateFromDictionary:dict];	
	return talk;
}

//populate attributes from a dictionary 
- (void)populateFromDictionary:(NSDictionary *)dict {
	self.serverId = [dict objectForKey:@"id"];
	self.title = [dict objectForKey:@"name"];
	
	if ([dict objectForKey:@"room_id"] != [NSNull null]) {
		self.roomId = [dict objectForKey:@"room_id"];
	}
	
	if ([dict objectForKey:@"room_name"] != [NSNull null]) {
		self.roomName = [dict objectForKey:@"room_name"];	
	}
	
	if ([dict objectForKey:@"who"] != [NSNull null]) {
		self.speaker = [dict objectForKey:@"who"];
	}
	
	NSDateFormatter *fmtLong = [[NSDateFormatter alloc] init];
	[fmtLong setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	NSDateFormatter *fmtShort =[[NSDateFormatter alloc] init];
	[fmtShort setDateFormat:@"yyyy-MM-dd"];
	
	NSString *dayStr = [dict objectForKey:@"day"];
	self.day = [fmtShort dateFromString:dayStr];
	
	NSString *sTime = [dict objectForKey:@"start_time"];				
	self.startTime = [fmtLong dateFromString:sTime];
	
	if ([dict objectForKey:@"end_time"] != [NSNull null]) {
		NSString *eTime = [dict objectForKey:@"end_time"];
		self.endTime = [fmtLong dateFromString:eTime];	
	}
	
	[fmtLong release];
	[fmtShort release];
	
	self.updatedAt = [NSDate date];
}

@end