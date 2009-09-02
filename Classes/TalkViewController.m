//
//  TalkViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TalkViewController.h"


@implementation TalkViewController

@synthesize talk;

- (void)setTalk:(Talk *)t {	
	talk = t;
	[talk retain];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	[self setUILabelWithTopAlign:whatLabel 
					withMaxFrame:CGRectMake(75,106,225,91)
						withText:talk.name];		 
	whoLabel.text = talk.who;	
	whereLabel.text = talk.room;
	whenLabel.text = [NSString stringWithFormat:@"%@ - %@",[talk startTimeString],[talk endTimeString]];
	
	favButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[favButton setFrame:CGRectMake(25,205,36,36)];
	[favButton setBackgroundImage:[talk favoriteStatusImage] forState:UIControlStateNormal];
	[favButton addTarget:self action:@selector(favoriteButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:favButton];
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

- (void)favoriteButtonWasPressed {
	talk.favorite = !talk.favorite;	
	[favButton setBackgroundImage:[talk favoriteStatusImage] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[talk release];
    [super dealloc];
}


@end
