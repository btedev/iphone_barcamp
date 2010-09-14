//
//  TalkCell.h
//  BarCamp
//
//  Created by Barry Ezell on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Talk.h"

@interface TalkCell : UITableViewCell {
	IBOutlet UILabel *roomLabel;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *timeLabel;	
	UIButton *favButton;
	UIView *backgroundColorView;
	Talk *talk;
}

@property (nonatomic, retain) Talk *talk;
@property (nonatomic, retain) UIButton *favButton;
@property (nonatomic, retain) UIView *backgroundColorView;

+ (void)createColorArray;

- (UIColor *)colorForRoomId:(int)rId;
- (void)favoriteButtonWasPressed;
- (void)setFavoriteImage;

@end
