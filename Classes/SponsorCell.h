//
//  SponsorCell.h
//  BarCamp
//
//  Created by Barry Ezell on 8/30/09.
//  Copyright 2009 Barry Ezell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sponsor.h"

@interface SponsorCell : UITableViewCell {
	Sponsor *sponsor;
}

@property (nonatomic, retain) Sponsor *sponsor;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *linkLabel;


@end
