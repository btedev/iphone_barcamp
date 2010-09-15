//
//  Day.h
//  BarCamp
//
//  Created by Barry Ezell on 9/14/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Day : NSObject {
}
	
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *description;

+ (NSArray *)plistDaysArray;
+ (Day *)logicalDay:(NSArray *)days forDate:(NSDate *)date;
+ (Day *)logicalDay:(NSArray *)days;

@end
