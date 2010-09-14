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
@dynamic speaker;
@dynamic endTime;
@dynamic notes;
@dynamic title;
@dynamic startTime;
@dynamic serverId;
@dynamic updatedAt;

/*[{"talk": {"room_id": 1, "name": "Connecting print and the digital world", "end_time": "2000-01-01T09:55:00Z", "created_at": "2009-09-26T13:23:22Z", "updated_at": "2009-09-26T13:23:35Z", "deleted_at": null, "url": "", "id": 2, "day": "2010-09-25", "who": "Steve Tingiris + Jody Haneke", "description": "", "start_time": "2000-01-01T09:30:00Z"}}, {"talk": {"room_id": 1, "name": "Web Hooks", "end_time": "2000-01-01T10:25:00Z", "created_at": "2009-09-26T13:24:03Z", "updated_at": "2009-09-26T13:24:03Z", "deleted_at": null, "url": "", "id": 3, "day": "2010-09-25", "who": "@ryantxr", "description": "", "start_time": "2000-01-01T10:00:00Z"}}, {"talk": {"room_id": 1, "name": "iPhone Developer Secrets = a Panel", "end_time": "2000-01-01T13:55:00Z", "created_at": "2009-09-26T13:24:30Z", "updated_at": "2009-09-26T13:31:51Z", "deleted_at": null, "url": "", "id": 4, "day": "2010-09-25", "who": "Tampa iPhone Developers", "description": "", "start_time": "2000-01-01T13:00:00Z"}}, {"talk": {"room_id": 1, "name": "Tampa Bay Microcontroller + Robotics Group", "end_time": "2000-01-01T14:25:00Z", "created_at": "2009-09-26T13:24:57Z", "updated_at": "2009-09-26T13:32:01Z", "deleted_at": null, "url": "", "id": 5, "day": "2010-09-25", "who": "", "description": "", "start_time": "2000-01-01T14:00:00Z"}}, {"talk": {"room_id": 1, "name": "Future of programming from the perspective of the microcontroller", "end_time": "2000-01-01T14:55:00Z", "created_at": "2009-09-26T13:25:39Z", "updated_at": "2009-09-26T13:32:14Z", "deleted_at": null, "url": "", "id": 6, "day": "2010-09-25", "who": "", "description": "NULL", "start_time": "2000-01-01T14:30:00Z"}}, {"talk": {"room_id": 1, "name": "Open Discussion on Hacker Spaces", "end_time": "2000-01-01T15:55:00Z", "created_at": "2009-09-26T13:25:58Z", "updated_at": "2009-09-26T13:32:27Z", "deleted_at": null, "url": "", "id": 7, "day": "2010-09-25", "who": "", "description": "", "start_time": "2000-01-01T15:00:00Z"}}, {"talk": {"room_id": 2, "name": "Beginning iPhone Development", "end_time": "2000-01-01T10:15:00Z", "created_at": "2009-09-26T13:33:20Z", "updated_at": "2009-09-26T13:33:20Z", "deleted_at": null, "url": "", "id": 8, "day": "2010-09-25", "who": "NULL", "description": "", "start_time": "2000-01-01T09:30:00Z"}}, {"talk": {"room_id": 2, "name": "Adobe Flash Platform (Intro + Resources)", "end_time": "2000-01-01T11:35:00Z", "created_at": "2009-09-26T13:33:54Z", "updated_at": "2009-09-26T13:33:54Z", "deleted_at": null, "url": "", "id": 9, "day": "2010-09-25", "who": "Greg Wilson", "description": "", "start_time": "2000-01-01T10:30:00Z"}}, {"talk": {"room_id": 2, "name": "RSS Could", "end_time": "2000-01-01T12:00:00Z", "created_at": "2009-09-26T13:37:22Z", "updated_at": "2009-09-26T13:37:22Z", "deleted_at": null, "url": "", "id": 10, "day": "2010-09-25", "who": "Chuck Palm", "description": "", "start_time": "2000-01-01T11:35:00Z"}}, {"talk": {"room_id": 2, "name": "Augmented Reality", "end_time": "2000-01-01T14:05:00Z", "created_at": "2009-09-26T13:37:51Z", "updated_at": "2009-09-26T13:37:51Z", "deleted_at": null, "url": "", "id": 11, "day": "2010-09-25", "who": "Sean Carey", "description": "", "start_time": "2000-01-01T13:00:00Z"}}]
 */

+ (void)refreshTalks {
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];	
	DDLogVerbose(@"%@",delegate.baseUrlStr);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",delegate.baseUrlStr,@"talks.json"]];
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
	
	if ([dict objectForKey:@"room_name"] != [NSNull null]) {
		self.roomName = [dict objectForKey:@"room_name"];	
	}
	
	if ([dict objectForKey:@"who"] != [NSNull null]) {
		self.speaker = [dict objectForKey:@"who"];
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	
	NSString *sTime = [dict objectForKey:@"start_time"];				
	self.startTime = [formatter dateFromString:sTime];
	
	if ([dict objectForKey:@"end_time"] != [NSNull null]) {
		NSString *eTime = [dict objectForKey:@"end_time"];
		self.endTime = [formatter dateFromString:eTime];	
	}
	
	[formatter release];
	
	self.updatedAt = [NSDate date];
}