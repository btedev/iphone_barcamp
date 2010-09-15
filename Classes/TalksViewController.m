//
//  RootViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TalksViewController.h"
#import "BarCampAppDelegate.h"
#import "TalkViewController.h"
#import "Reachability.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface TalksViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TalksViewController

@synthesize tableView, currentDay, days;
@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

- (void)dealloc {
	[days release];
	[currentDay release];	
	[tableView release];
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//add left and right buttons.  Note: see README regarding button images.  They are commercial and are not included
	//in the source posted on github
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
	
	//Get the array of BarCamp days
	self.days = [Day plistDaysArray];	
	
	//Set the current day to the logical date and update the navigation item
	self.currentDay = [Day logicalDay:days];
	self.navigationItem.title = self.currentDay.description;
		
	//set the MOC
	BarCampAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	self.managedObjectContext = delegate.managedObjectContext;
	
	//Check for inet connectivity and raise alert if none, else refresh talks	
	//(unable to get Reachability working correctly on LAN so skip check when debug)
	BOOL shouldCheckInet = YES;
#ifdef DEBUG
	shouldCheckInet = NO;
#endif

	Reachability *reachability = [Reachability reachabilityWithHostName:delegate.baseUrlStr];
	NetworkStatus netStatus = [reachability currentReachabilityStatus];
	if (netStatus == NotReachable && shouldCheckInet) {			
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Problem" 
														message:@"Please check your internet connection and try again" 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		//Request Talk to update its collection
		[self refreshTalks];		
	}
	
	//Schedule a 120s timer to refresh talks (note: we won't bug user with inet error alerts for 
	//subsequent request attempts)
	[NSTimer scheduledTimerWithTimeInterval:120 
							target:self 
						  selector:@selector(refreshTalks) 
						  userInfo:nil 
						   repeats:YES];
}

// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

#pragma mark -
#pragma mark Refresh method

- (void)refreshTalks {
	DDLogVerbose(@"Refreshing talk schedule");
	[Talk refreshTalks];
}

#pragma mark -
#pragma day movement methods

- (void)forwardButtonWasPressed {
	[self dayChangeByIncrement:1];
}

- (void)backButtonWasPressed {
	[self dayChangeByIncrement:-1];
}

//change days by increment amount 
//if requested day is available
- (void)dayChangeByIncrement:(int)incr {
	
	//obtain current day index
	int idx = [self.days indexOfObject:self.currentDay];
	idx += incr;
	
	//change if possible
	if (idx >= 0 && idx <= [days count] - 1) {
		self.currentDay = [days objectAtIndex:idx];
		DDLogInfo(@"Changing day to %@", self.currentDay.description);
		self.navigationItem.title = self.currentDay.description;
		
		fetchedResultsController_ = nil;
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark Table view data source

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    Talk *talk = (Talk *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    TalkCell *talkCell = (TalkCell *) cell;
	talkCell.talk = talk;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TalkCell";
    
    TalkCell *cell = (TalkCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self createNewTalkCellFromNib];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
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
	
	return talkCell;
}	

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TalkViewController *talkVC = [[TalkViewController alloc] initWithNibName:@"TalkViewController" 
																	 bundle:nil];
	Talk *talk = (Talk *) [self.fetchedResultsController objectAtIndexPath:indexPath];
	talkVC.talk = talk;
	[self.navigationController pushViewController:talkVC animated:YES];
	[talkVC release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
	
	//avoid nasty crashes for "inconsistent cache"
	[NSFetchedResultsController deleteCacheWithName:@"Talks"];
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Talk" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
	
	//Only present results from the currentDay
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@",self.currentDay.date];
	[fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:self.managedObjectContext 
																								  sectionNameKeyPath:nil 
																										   cacheName:@"Talks"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
       
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

