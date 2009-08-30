//
//  SponsorCell.m
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SponsorCell.h"


@implementation SponsorCell

@synthesize sponsor;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSponsor:(Sponsor *)newSponsor {
	Sponsor *oldSponsor = sponsor;
	[oldSponsor release];
	sponsor = [newSponsor retain];
	
	nameLabel.text = sponsor.name;
	levelLabel.text = sponsor.level;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[sponsor release];
    [super dealloc];
}


@end
