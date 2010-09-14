//
//  TalkCell.m
//  BarCamp
//
//  Created by Barry Ezell on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TalkCell.h"

static NSArray *colors = nil;

@implementation TalkCell

@synthesize talk, favButton, backgroundColorView;

//Using Kuler color set based on "Ocean" by papapac
+ (void)createColorArray {
	NSMutableArray *tmpColors = [NSMutableArray arrayWithCapacity:5];
		
	[tmpColors addObject:[UIColor colorWithRed:0.0470 green:0.1176 blue:0.9098 alpha:1.0]];
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
	//[backgroundColorView setBackgroundColor:[self colorForRoomId:talk.objectID]];
	
	[formatter release];
	
	//[self setFavoriteImage];
}

//to help differentiate each room, we'll use a simple scheme for assigning a limited selection
//of colors by id
- (UIColor *)colorForRoomId:(int)rId {		
	int i = (rId % 5);	
	if (!colors) [TalkCell createColorArray];			
	return [colors objectAtIndex:i];	
}

#pragma mark FavoriteChangeDelegate method

- (void)favoriteStatusChanged {
	[self setFavoriteImage];
}

- (void)setFavoriteImage {
	[favButton setBackgroundImage:[talk favoriteStatusImage] forState:UIControlStateNormal];
}

//note: since this is a FavoriteChangeDelegate the event will be received 
//that way which will cause the image to be changed
- (void)favoriteButtonWasPressed {
	//talk.favorite = !talk.favorite;	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
	//[super setSelected:selected animated:animated];

    // Configure the view for the selected state
	//[self bringSubviewToFront:favButton];
}


- (void)dealloc {
	[talk release];
	[favButton release];
	[backgroundColorView release];
    [super dealloc];
}


@end
