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
}

@property (nonatomic, retain) Talk *talk;
@property (nonatomic, retain) IBOutlet UILabel *roomLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *checkImageView;

+ (void)createColorArray;
- (UIColor *)colorForRoomId:(int)rId;

@end
