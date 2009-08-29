//
//  ScheduleViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 8/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "BarCampAppDelegate.h"
#import "TalkViewController.h"

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[tableView setFrame:CGRectMake(0,0,320,368)];
	
	//create a NSOperationQueue for background HTTP requests
	queue = [[NSOperationQueue alloc] init];
	[queue retain];
	
	UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
	rButton.bounds = CGRectMake(0,0,36,36);
	[rButton setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
	[rButton addTarget:self action:@selector(forwardButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];		
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rButton];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem release];
	
	UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
	lButton.bounds = CGRectMake(0,0,36,36);
	[lButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[lButton addTarget:self action:@selector(backButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];		
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:lButton];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];

	[self refreshSchedule];
}

//Get full schedule of talks from server as JSON string and call static method on 
//Talk class to create array of Talk objects.
- (void)refreshSchedule {	
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];
	NSURL *url = [NSURL URLWithString:[[delegate baseUrl] stringByAppendingString:@"/talks.json"]];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(scheduleRequestDone:)];
	[request setDidFailSelector:@selector(scheduleRequestError:)];
	[queue addOperation:request];
}

- (void)scheduleRequestDone:(ASIHTTPRequest *)request {	
	NSString *response = [request responseString];
	BOOL changed = [Talk loadTalksFromJsonString:response];	
	
	if (changed) {
		[self refreshHour];
	}
	
	//create timer to recheck schedule in 120 seconds if timer doesn't yet exist
	if (!refreshTimer) {
		refreshTimer = [NSTimer scheduledTimerWithTimeInterval:120 
														target:self 
													  selector:@selector(refreshSchedule) 
													  userInfo:nil 
													   repeats:YES];		
	}
}

- (void)scheduleRequestError:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSString *msg = [NSString stringWithFormat:@"A problem occurred when trying to contact the server. Please check your internet connection and try again. Error: %@",
					 [error localizedDescription]];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

//Refresh the data in the current hour displayed.  
//If no current hour set, choose a time with the following rules:
//  If the current time if between the earliest and latest scheduled talk, use that
//  If current time < earliest time, use earliest time
//  Else if current time > latest time, use latest time
//  Else default to floor of nearst hour (e.g., 10:07 would be 10:00)
- (void)refreshHour {
	if (currentHour == nil) {
		NSDate *now = [NSDate date];
		if ([now compare:[Talk earliestTalkTime]] == NSOrderedAscending) {
			currentHour = [Talk earliestTalkTime];
		} else if ([now compare:[Talk latestTalkTime]] == NSOrderedDescending) {
			currentHour = [Talk latestTalkTime];
		} else {
			//construct new date from string because doing this using NSDateComponents and subtraction always led to 
			//a ~ 1 second error that would hose comparisons when calling [Talk talksBetweenTimeA: andTimeB:]
			//Format is like 2009-08-28 09:54:25 -0400, will reformat to 2009-08-28 09:00:00 -0400			
			NSString *curDesc = [now description];
			NSArray *parts = [curDesc componentsSeparatedByString:@":"];
			NSString *beginningOfHour = [NSString stringWithFormat:@"%@:00:00 %@",
													[parts objectAtIndex:0],
										  [[parts objectAtIndex:2] substringFromIndex:3]];			
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
			currentHour = [df dateFromString:beginningOfHour];
			[df release];			
		}		
		
		[currentHour retain];
	}

	talks = [Talk talksBetweenTimeA:currentHour andTimeB:[currentHour addTimeInterval:(59*60)]];
	[tableView reloadData];			
			
	//change the nav item title
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"h:mm"];
	NSString *dateStr = [df stringFromDate:currentHour];
	[df release];
	
	self.navigationItem.title = dateStr;	
}
	
//decrement current hour by one if any talks exist for that hour
- (void)backButtonWasPressed {
	if ([Talk earliestTalkTime] && [currentHour compare:[Talk earliestTalkTime]] == NSOrderedDescending) {		
		NSDate *newCurrent = [currentHour addTimeInterval:-(60*60)];
		[currentHour release];
		currentHour = [newCurrent retain];		
		[self refreshHour];
	}
}

//increment current hour by one if any talks exist for that hour
- (void)forwardButtonWasPressed {
	if ([Talk latestTalkTime] && [currentHour compare:[Talk latestTalkTime]] == NSOrderedAscending) {		
		NSDate *newCurrent = [currentHour addTimeInterval:(60*60)];
		[currentHour release];
		currentHour = [newCurrent retain];		
		[self refreshHour];
	}
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [talks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 78.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"TalkCell";
    
    TalkCell *cell = (TalkCell *) [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [self createNewTalkCellFromNib];        
    }
    
    // Set up the cell...
	Talk *t = [talks objectAtIndex:indexPath.row];
	cell.talk = t;
    return cell;
}

- (TalkCell *) createNewTalkCellFromNib {
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"TalkCell" owner:self options:nil];
	NSEnumerator* nibEnumerator = [nibContents objectEnumerator];
	TalkCell* talkCell = nil;
	NSObject* nibItem = nil;
	while((nibItem = [nibEnumerator nextObject]) != nil) {
		if ([nibItem isKindOfClass: [TalkCell class]]) {
			talkCell = (TalkCell *) nibItem;
		}
	}
	
	//Add colored background view. Color will be set in cell's setTalk 
	UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
	talkCell.backgroundColorView = colorView;
	[talkCell addSubview:colorView];
	[talkCell sendSubviewToBack:colorView];
	[colorView release];
	
	//add favorite button
	UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
	talkCell.favButton = favButton;
	[favButton setFrame:CGRectMake(12,30,36,36)];
	[favButton setBackgroundImage:[UIImage imageNamed:@"star_unselected.png"] forState:UIControlStateNormal];
	[favButton addTarget:talkCell action:@selector(favoriteButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
	[talkCell addSubview:favButton];
	
	return talkCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
	TalkViewController *tvc = [[TalkViewController alloc] initWithNibName:@"TalkView" bundle:nil];
	Talk *talk = [talks objectAtIndex:indexPath.row];	
	tvc.talk = talk;
	[self.navigationController pushViewController:tvc animated:YES];	
	[tvc release];
}


- (void)dealloc {
	[currentHour release];	
	[queue release];
    [super dealloc];
}


@end

