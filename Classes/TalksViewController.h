//
//  RootViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Talk.h"
#import "TalkCell.h"

@interface TalksViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (TalkCell *) createNewTalkCellFromNib;

@end
