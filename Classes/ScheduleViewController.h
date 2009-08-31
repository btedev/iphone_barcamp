//
//  ScheduleViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 8/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Talk.h"
#import "TalkCell.h"

@interface ScheduleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	UIActivityIndicatorView *spinner;
	NSArray *talks;
	NSDate *currentHour;
	NSTimer *refreshTimer;
	NSOperationQueue *queue;
}

- (void)refreshSchedule;
- (void)scheduleRequestDone:(ASIHTTPRequest *)request;
- (void)scheduleRequestError:(ASIHTTPRequest *)request;
- (void)refreshHour;
- (TalkCell *) createNewTalkCellFromNib;
- (void)backButtonWasPressed;
- (void)forwardButtonWasPressed;

@end
