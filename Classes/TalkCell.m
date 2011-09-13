//
//  TalkCell.m
//  BarCamp
//
//  Created by Barry Ezell on 8/26/09.
//  Copyright 2009 Barry Ezell. All rights reserved.
//

#import "TalkCell.h"

static NSArray *colors = nil;

@implementation TalkCell

@synthesize talk, roomLabel, timeLabel, nameLabel, checkImageView;

- (void)dealloc {
	[talk release];
	[timeLabel release];
	[nameLabel release];
	[roomLabel release];
	[checkImageView release];	
    [super dealloc];
}

//Using Kuler color set based on "Ocean" by papapac
+ (void)createColorArray {
	NSMutableArray *tmpColors = [NSMutableArray array];
		
	[tmpColors addObject:[UIColor colorWithRed:0.0 green:0.6039 blue:1.0 alpha:1.0]];
	[tmpColors addObject:[UIColor colorWithRed:0.0 green:1.0 blue:0.3019 alpha:1.0]];
	[tmpColors addObject:[UIColor colorWithRed:0.4549 green:0.0 blue:1.0 alpha:1.0]];	
	[tmpColors addObject:[UIColor colorWithRed:0.031 green:0.659 blue:0.576 alpha:1.0]];	
	
	colors = tmpColors;	
	[colors retain];
}

- (void)setTalk:(Talk *)newTalk {
	Talk *oldTalk = talk;
	[oldTalk release];
	talk = [newTalk retain];
	
	nameLabel.text = talk.title;
	roomLabel.text = talk.roomName;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	timeLabel.text = [formatter stringFromDate:talk.startTime];
	roomLabel.text = talk.roomName;
	roomLabel.textColor = [self colorForRoomId:[talk.roomId intValue]];
		
	[formatter release];
	
	//show or hide the checkmark depending on whether this talk is "interesting"
	self.checkImageView.alpha = ([talk.interestLevel intValue] == 1 ? 1.0 : 0.0);	
}

//to help differentiate each room, we'll use a simple scheme for assigning a limited selection
//of colors by id
- (UIColor *)colorForRoomId:(int)rId {		
	int i = (rId % 4);	
	if (!colors) [TalkCell createColorArray];			
	return [colors objectAtIndex:i];	
}

@end
