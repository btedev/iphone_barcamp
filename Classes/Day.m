//
//  Day.m
//  BarCamp
//
//  Created by Barry Ezell on 9/14/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import "Day.h"


@implementation Day

@synthesize date, description;

- (void)dealloc {
	[date release];
	[description release];
	[super dealloc];
}

//Create an array of Day objects from the Days plist
+ (NSArray *)plistDaysArray {	
	NSMutableArray *arr = [NSMutableArray array];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Days" ofType:@"plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	NSArray *daysDict = [dict objectForKey:@"Days"];
	for (NSDictionary *day in daysDict) {
		Day *d = [[Day alloc] init];
		d.date = [formatter dateFromString:[day objectForKey:@"Date"]];
		d.description = [day objectForKey:@"Description"];
		[arr addObject:d];
		[d release];
	}
	
	[formatter release];	
	return arr;
}

//Given the passed array of days objects,
//choose the "logical" day for today. 
//If the current day is <= the first day, choose the first,
//if it's after the last day, choose the last, etc...
+ (Day *)logicalDay:(NSArray *)days forDate:(NSDate *)date {
	
	//test to see if date is < first day
	Day *firstDay = [days objectAtIndex:0];
	if ([date compare:firstDay.date] == NSOrderedAscending) {
		return firstDay;
	} 
	
	//loop over values and return a given day if date is == day
	for(Day *aDay in days) {
		if ([date compare:aDay.date] == NSOrderedSame || [date compare:aDay.date] == NSOrderedDescending) {
			return aDay;
		}
	}
	
	//test to see if date is > last day
	Day *lastDay = [days objectAtIndex:[days count] - 1];
	if ([date compare:lastDay.date] == NSOrderedDescending) {
		return lastDay;
	}
	
	return nil;
}

+ (Day *)logicalDay:(NSArray *)days {
	return [Day logicalDay:days forDate:[NSDate date]];
}

@end
