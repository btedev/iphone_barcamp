//
//  SponsorsViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SponsorsViewController.h"
#import "BarCampAppDelegate.h"
#import "Sponsor.h"

@implementation SponsorsViewController

- (void)viewDidLoad {
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];
	NSURL *url = [NSURL URLWithString:[[delegate baseUrl] stringByAppendingString:@"/sponsors.json"]];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(sponsorRequestDone:)];
	[request start];

	NSString *response = [request responseString];
	sponsors = [Sponsor loadSponsorsFromJsonString:response];
	[sponsors retain];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sponsors count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SponsorCell";
    
	SponsorCell *cell = (SponsorCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self createNewSponsorCellFromNib];
    }
    
    Sponsor *s = [sponsors objectAtIndex:indexPath.row];
	cell.sponsor = s;
    return cell;
}


- (SponsorCell *) createNewSponsorCellFromNib {
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"SponsorCell" owner:self options:nil];
	NSEnumerator* nibEnumerator = [nibContents objectEnumerator];
	SponsorCell* sponsorCell = nil;
	NSObject* nibItem = nil;
	while((nibItem = [nibEnumerator nextObject]) != nil) {
		if ([nibItem isKindOfClass: [SponsorCell class]]) {
			sponsorCell = (SponsorCell *) nibItem;
		}
	}
	
	return sponsorCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
	Sponsor *s = [sponsors objectAtIndex:indexPath.row];
	if (s.link) {
		[[UIApplication sharedApplication] openURL:s.link];
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


- (void)dealloc {
	[sponsors release];
    [super dealloc];
}


@end
