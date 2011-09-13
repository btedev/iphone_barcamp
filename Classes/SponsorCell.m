//
//  SponsorCell.m
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 Barry Ezell. All rights reserved.
//

#import "SponsorCell.h"

@implementation SponsorCell

@synthesize sponsor, nameLabel, linkLabel;

- (void)setSponsor:(Sponsor *)newSponsor {
	Sponsor *oldSponsor = sponsor;
	[oldSponsor release];
	sponsor = [newSponsor retain];
	
	nameLabel.text = sponsor.name;
	linkLabel.text = sponsor.link;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)dealloc {
	[nameLabel release];
	[linkLabel release];
	[sponsor release];
    [super dealloc];
}


@end
