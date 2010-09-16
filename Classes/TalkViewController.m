 //
//  TalkViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TalkViewController.h"

@implementation TalkViewController

@synthesize talkVCDelegate, talk, whatLabel, whoLabel, whereLabel, whenLabel, interestedButton, twitterButton;

- (void)dealloc {	
	[talk release];
	[whatLabel release];
	[whoLabel release];
	[whereLabel release];
	[whenLabel release];
	[interestedButton release];
	[twitterButton release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	[self setUILabelWithTopAlign:whatLabel 
					withMaxFrame:CGRectMake(75,106,225,91)
						withText:talk.title];		 
	whoLabel.text = talk.speaker;	
	whereLabel.text = talk.roomName;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	NSString *sString = [formatter stringFromDate:talk.startTime];
	NSString *eString = (talk.endTime ? [formatter stringFromDate:talk.endTime] : nil);
	NSString *timeString = (eString ? [NSString stringWithFormat:@"%@ - %@",sString,eString] : sString);	
	[formatter release];
	whenLabel.text = timeString;		
	
	//enable the twitter button if the speaker's name begins with an @
	//(button in xib is disabled with alpha == 1.0)
	if ([talk.speaker length] > 0 && [[talk.speaker substringToIndex:1] isEqualToString:@"@"]) {
		self.twitterButton.enabled = YES;
	} else {
		self.twitterButton.alpha = 0.0;
	}
	
	[self setInterestedButtonImage];
}

//UILabel has property for HAlign but not VAlign and defaults to centered.  This will adjust VAlign by just
//resizing the label to fit the text.
- (void)setUILabelWithTopAlign:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText {
	
	CGSize stringSize = [theText sizeWithFont:myLabel.font constrainedToSize:maxFrame.size lineBreakMode:myLabel.lineBreakMode];
		
	myLabel.frame = CGRectMake(myLabel.frame.origin.x, 
							   myLabel.frame.origin.y, 
							   myLabel.frame.size.width, 
							   stringSize.height);
	myLabel.text = theText;
}

- (void)interestedButtonWasPressed {
	if ([talk.interestLevel intValue] == 0) {
		talk.interestLevel = [NSNumber numberWithInt:1];
	} else {
		talk.interestLevel = [NSNumber numberWithInt:0];
	}
	
	[self setInterestedButtonImage];
	
	//persist changes now
	NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];	
	NSError *error = nil;
	if ([context hasChanges]) {
		if(![context save:&error]) {
			DLog(@"Failed to save talk to data store: %@", [error localizedDescription]);
		}
	}	
}

- (void)setInterestedButtonImage {
	NSString *imgName = ([talk.interestLevel intValue] == 1 ? @"checkButtonInterested.png" : @"checkButtonNotInterested.png");		
	[self.interestedButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)twitterButtonWasPressed {
	NSString *profileString = [NSString stringWithFormat:@"http://twitter.com/%@",[self.talk.speaker substringFromIndex:1]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:profileString]];
}

@end
