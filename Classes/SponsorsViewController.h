//
//  SponsorsViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SponsorCell.h"

@interface SponsorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	NSArray *sponsors;
}

- (SponsorCell *) createNewSponsorCellFromNib;

@end
