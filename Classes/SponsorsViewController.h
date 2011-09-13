//
//  SponsorsViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Sponsor.h"
#import "SponsorCell.h"

@interface SponsorsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (SponsorCell *) createNewSponsorCellFromNib;
- (void)refreshSponsors;

@end
