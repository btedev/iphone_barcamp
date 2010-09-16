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

@implementation Talk 

@dynamic roomName;
@dynamic roomId;
@dynamic speaker;
@dynamic endTime;
@dynamic interestLevel;
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
	//DLog(@"%@",responseString);
		
	NSData *jsonData = [responseString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"talks"]) {
		NSArray *talks = [dictionary objectForKey:@"talks"];
		for (NSDictionary *talk in talks) {			
			NSDictionary *innerDict = [talk valueForKey:@"talk"];
			BOOL isDeleted = ([innerDict objectForKey:@"deleted_at"] == [NSNull null] ? NO : YES);
			
			//check for existing talk with same serverId
			NSNumber *serverId = [innerDict objectForKey:@"id"];
			Talk *tLocal = [Talk findFirstByAttribute:@"serverId" withValue:serverId];
			
			//three conditions on which we'll act
			//1.  Talk that's not present in CD and is not deleted on the server (create)			
			//2.  Talk that's present and deleted on the server (delete)
			//3.  Talk that's present in CD and was updated before the server object (update)
			if (!tLocal && !isDeleted) {
				@try {
					[Talk createInstance:innerDict];
				}
				@catch (NSException * e) {
					DLog(@"Error creating talk: %@",innerDict);
				}								
			} else if (tLocal && isDeleted) {
				//delete local file
				DLog(@"Deleting local talk %@ to reflect server delete",tLocal.title);
				[context deleteObject:tLocal];
			} else if (tLocal) {
				//compare updatedAt values and possibly update
				NSDate *serverUpdated = [formatter dateFromString:[innerDict objectForKey:@"updated_at"]];
				
				//TODO: fix this awful TZ hack
				//some issues: formatter won't work as is if Rails is set to use a non-UTC TZ,
				//this hack assumes the server is two hours ahead of the phone even though they both insist they're "GMT" #fml
				NSTimeInterval secondsInFourHours = -4 * 60 * 60;
				serverUpdated = [serverUpdated dateByAddingTimeInterval:secondsInFourHours];
				
				if ([tLocal.updatedAt compare:serverUpdated] == NSOrderedAscending) {
					DLog(@"Updating local talk with updateAt: %@ to match server talk with updatedAt: %@",tLocal.updatedAt,serverUpdated);
					[tLocal populateFromDictionary:innerDict];
				} 
			}
		}//talks loop
	}//json sanity test
	
	if ([context hasChanges]) {
		if(![context save:&error]) {
			DLog(@"Failed to save talk to data store: %@", [error localizedDescription]);
		}
	}
	
	[formatter release];
}

+ (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	DLog(@"Talk request failed: %@",[error localizedDescription]);
}

//Create Talk instance from a NSDictionary
+ (Talk *)createInstance:(NSDictionary *)dict {
	DLog(@"Adding talk %@",[dict objectForKey:@"name"]);
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