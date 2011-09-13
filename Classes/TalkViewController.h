//
//  TalkViewController.h
//  BarCamp
//
//  Created by Barry Ezell on 8/27/09.
//  Copyright 2009 Barry Ezell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Talk.h"

@protocol TalkViewControllerDelegate
@required
- (void)returningFromTalkViewController;
@end


@interface TalkViewController : UIViewController {		
}

@property (nonatomic, assign) id <TalkViewControllerDelegate> talkVCDelegate;
@property (nonatomic, retain) Talk *talk;
@property (nonatomic, retain) IBOutlet UILabel *whatLabel;
@property (nonatomic, retain) IBOutlet UILabel *whoLabel;
@property (nonatomic, retain) IBOutlet UILabel *whereLabel;
@property (nonatomic, retain) IBOutlet UILabel *whenLabel;
@property (nonatomic, retain) IBOutlet UIButton *interestedButton;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;

- (void)setUILabelWithTopAlign:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText;
- (IBAction)interestedButtonWasPressed;
- (void)setInterestedButtonImage;
- (IBAction)twitterButtonWasPressed;

@end
