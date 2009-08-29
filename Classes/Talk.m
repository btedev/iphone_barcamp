//
//  Talk.m
//  BarCamp
//
//  Created by Barry Ezell on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Talk.h"
#import <CommonCrypto/CommonDigest.h> //for MD5 function (see end of this file)

static NSMutableArray *allObjects = nil;
static NSString *lastHash = nil;
static NSDate *earliestTalk = nil;
static NSDate *latestTalk = nil;

@implementation Talk

@synthesize talkId, room, roomId, name, description, who, link, startTime, endTime, favorite, delegate;

//Loads an array of Talk objects from a JSON array.  
//Returns whether any change was detected from the last invocation.
+ (BOOL)loadTalksFromJsonString:(NSString *)jsonString {	
	
	//since the app is refreshing data with some frequency, first determine if the schedule has changed since
	//the last time this method was invoked.  Calculate the MD5 hash of the string and proceed if it's different
	//than the last run.
	NSString *hash = [NSString md5:jsonString];
	if (lastHash && [lastHash isEqual:hash]) return NO;
	lastHash = hash;
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	
	//Get stored array of favorites if it exists and apply to results
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *allFavs = nil;
	if ([prefs arrayForKey:@"favs"]) allFavs = [NSMutableArray arrayWithArray:[prefs arrayForKey:@"favs"]];
					
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"talks"]) {
		NSArray *talks = [dictionary objectForKey:@"talks"];
		for (NSDictionary *talk in talks) {
			Talk *t = [[Talk alloc] initWithDictionary:talk andFavorites:allFavs];
			[objects addObject:t];
						
			//Track earliest and latest dates because these will be used by ScheduleViewController as bounds for display.
			//Only record them if they are on the hour (e.g., record 9:00 but not 8:30)
			if (earliestTalk == nil) earliestTalk = t.startTime;
			else if ([t.startTime compare:earliestTalk] == NSOrderedAscending) {
				NSDateComponents *comps = [cal components:(NSMinuteCalendarUnit) fromDate:t.startTime];
				if ([comps minute] == 0) earliestTalk = t.startTime;
			}
			
			if (latestTalk == nil) latestTalk = t.startTime;
			else if ([t.startTime compare:latestTalk] == NSOrderedDescending) {				
				NSDateComponents *comps = [cal components:(NSMinuteCalendarUnit) fromDate:t.startTime];
				if ([comps minute] == 0) latestTalk = t.startTime;		
			}
		}
	}	
		
	[allObjects release];
	[objects retain];
	allObjects = objects;
	
	return YES;
}

+ (NSArray *)talksBetweenTimeA:(NSDate *)a andTimeB:(NSDate *)b {	
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	for(Talk *t in allObjects) {
		NSComparisonResult compareStart = [t.startTime compare:a];
		NSComparisonResult compareEnd = [t.startTime compare:b];
				
		//NSComparisonResult {NSOrderedAscending = -1, NSOrderedSame, NSOrderedDescending};
		if (compareStart != -1 && compareEnd != 1) {
			[objects addObject:t];
		}
	}
	return objects;
}

+ (NSDate *)earliestTalkTime {
	return earliestTalk;
}

+ (NSDate *)latestTalkTime {
	return latestTalk;
}


//Create Talk instance from JSON Dictionary
- (id)initWithDictionary:(NSDictionary *)dict andFavorites:(NSArray *)favs{
	self = [super init];
	if (self) {
		NSString *sId = [dict objectForKey:@"id"];
		self.talkId = [sId intValue];
		
		NSString *sRoomId = [dict objectForKey:@"room_id"];
		self.roomId = [sRoomId intValue];
		
		self.name = [dict objectForKey:@"name"];
		self.room = [dict objectForKey:@"room_name"];
		self.description = [dict objectForKey:@"description"];
		self.who = [dict objectForKey:@"who"];
				
		NSString *sTime = [dict objectForKey:@"start_time"];		
		self.startTime = [self parseTimeString:sTime];
		
		NSString *eTime = [dict objectForKey:@"end_time"];
		self.endTime = [self parseTimeString:eTime];	
		
		if (favs && [favs indexOfObject:[NSNumber numberWithInt:self.talkId]] != NSNotFound) self.favorite = YES;
		else self.favorite = NO;
	}
	
	return self;
}

//Parse time string like "10:30" into NSDate.
//This is probably not the most elegant solution.
//Doing subtraction of hours and minutes back to midnight from now
//ostensibly worked but led to NSDate compare errors with other dates.
//TODO: Fix this
- (NSDate *)parseTimeString:(NSString *)timeString {
		
	NSArray *timeParts = [timeString componentsSeparatedByString:@":"];
	
	//build up a string date using now's year, month, and day, with passed-in string's hour and minute
	NSDate *now = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	NSString *sDate = [NSString stringWithFormat:@"%d-%02d-%02d %@:%@:00",
					   [comps year],[comps month],[comps day],[timeParts objectAtIndex:0],[timeParts objectAtIndex:1]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	
	NSDate *date = [df dateFromString:sDate];
	[df release];			
	
	return date;
}

- (NSString *)startTimeString {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"h:mm"];
	NSString *dateStr = [df stringFromDate:startTime];
	[df release];
	return dateStr;
}

- (NSString *)endTimeString {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"h:mm"];
	NSString *dateStr = [df stringFromDate:endTime];
	[df release];
	return dateStr;	
}

//Update favorite attribute of this object and persist in user defaults.
//Since favorites is not technically a default, it should more correctly 
//be persisted to a prefs file or a DB, but since the file will have very limited
//scope, it shouldn't be a problem.
- (void)changeFavorite:(BOOL)isFavorite {	
	self.favorite = isFavorite;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *allFavs;
	if (![prefs arrayForKey:@"favs"]) {
		allFavs = [[[NSMutableArray alloc] init] autorelease];
	
	} else {
		allFavs = [NSMutableArray arrayWithArray:[prefs arrayForKey:@"favs"]];
	}
		
	if (favorite) {
		if ([allFavs indexOfObject:[NSNumber numberWithInt:talkId]] == NSNotFound) [allFavs addObject:[NSNumber numberWithInt:talkId]];
	} else {
		if ([allFavs indexOfObject:[NSNumber numberWithInt:talkId]] != NSNotFound) [allFavs removeObject:[NSNumber numberWithInt:talkId]];
	}
	
	[prefs setObject:allFavs forKey:@"favs"];
	[prefs synchronize];
				
	//notify any delegate of change
	if (delegate) [delegate favoriteStatusChanged];
}

- (NSString *)description {
	NSString *desc = [NSString stringWithFormat:@"Talk: %@ by: %@",name,who];
	return desc;
}

- (void)dealloc {
	[room release];
	[name release];
	[description release];
	[who release];
	[link release];
	[startTime release];
	[endTime release];
	[super dealloc];
}

@end


@implementation NSString (md5)

+ (NSString *) md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

@end

