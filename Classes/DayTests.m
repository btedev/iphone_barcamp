//
//  DayTests.m
//  BarCamp
//
//  Created by Barry Ezell on 9/14/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import "DayTests.h"
#import "Day.h"

@implementation DayTests
                
- (void)testLogicalDaySelection {
	
	//create an array of two days and test the selection of which day should be displayed
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
		
	Day *d1 = [[Day alloc] init];
	d1.date = [formatter dateFromString:@"2010-09-25"];
	d1.description = @"Media Day";
		
	Day *d2 = [[Day alloc] init];
	d2.date = [formatter dateFromString:@"2010-09-26"];
	d2.description = @"Dev Day";
		
	NSArray *days = [NSArray arrayWithObjects:d1,d2,nil];
	
	//test one week before event
	Day *dt1 = [Day logicalDay:days forDate:[formatter dateFromString:@"2010-09-18"]];
	STAssertNotNil(dt1,@"received day");
	STAssertEquals(d1.date,dt1.date,@"One week before event should return first day");
	
	//test day of first event
	Day *dt2 = [Day logicalDay:days forDate:[formatter dateFromString:@"2010-09-25"]];
	STAssertEquals(d1.date,dt2.date,@"Day of first event should return first day");
	
	//test day of second event
	Day *dt3 = [Day logicalDay:days forDate:[formatter dateFromString:@"2010-09-26"]];
	STAssertEquals(d2.date,dt3.date,@"Day of second event should yield second day");
	
	//test week after second event
	Day *dt4 = [Day logicalDay:days forDate:[formatter dateFromString:@"2010-10-03"]];
	STAssertEquals(d2.date,dt4.date,@"Week after event should return last day");
	
	[formatter release];	
}

@end
