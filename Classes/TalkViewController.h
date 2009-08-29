//
//  TalkViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Talk.h"

@interface TalkViewController : UIViewController {
	IBOutlet UILabel *whatLabel;
	IBOutlet UILabel *whoLabel;
	IBOutlet UILabel *whereLabel;
	IBOutlet UILabel *whenLabel;
	UIButton *favButton;
	Talk *talk;
}

@property (nonatomic, retain) Talk *talk;

- (void)setUILabelWithTopAlign:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText;
- (void)favoriteButtonWasPressed;

@end
