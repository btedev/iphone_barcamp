//
//  RootViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "Talk.h"
#import "TalkCell.h"
#import "Day.h"

@interface TalksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, MBProgressHUDDelegate> {
	
	MBProgressHUD *HUD;
	BOOL suspendingUpdates;
	
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Day *currentDay;
@property (nonatomic, retain) NSArray *days;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)performInitialTalkRequest;
- (TalkCell *) createNewTalkCellFromNib;
- (void)forwardButtonWasPressed;
- (void)backButtonWasPressed;
- (void)dayChangeByIncrement:(int)incr;
- (void)refreshTalks;

@end
