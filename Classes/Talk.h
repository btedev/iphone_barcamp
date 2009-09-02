//
//  Talk.h
//  BarCamp
//
//  Created by Barry Ezell on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"

@interface NSString (md5)
+ (NSString *) md5:(NSString *)str;
@end

@protocol FavoriteChangeDelegate
@required
- (void)favoriteStatusChanged;
@end

@interface Talk : NSObject {
	int talkId;
	NSString *room;
	int roomId;
	NSString *name;
	NSString *description;
	NSString *who;
	NSURL *link;
	NSDate *startTime;
	NSDate *endTime;
	BOOL favorite;
	id delegate;
}

@property(nonatomic, assign) int talkId;
@property(nonatomic, retain) NSString *room;
@property(nonatomic, assign) int roomId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *who;
@property(nonatomic, retain) NSURL *link;
@property(nonatomic, retain) NSDate *startTime;
@property(nonatomic, retain) NSDate *endTime;
@property(nonatomic, assign) BOOL favorite;
@property(nonatomic, assign) id<FavoriteChangeDelegate> delegate;

+ (BOOL)loadTalksFromJsonString:(NSString *)jsonString;
+ (NSArray *)talksBetweenTimeA:(NSDate *)a andTimeB:(NSDate *)b;
+ (NSDate *)earliestTalkTime;
+ (NSDate *)latestTalkTime;
+ (int)talksCount;

- (id)initWithDictionary:(NSDictionary *)dict andFavorites:(NSArray *)favs;
- (NSDate *)parseTimeString:(NSString *)timeString;
- (NSString *)startTimeString;
- (NSString *)endTimeString;
- (UIImage *)favoriteStatusImage;

@end
