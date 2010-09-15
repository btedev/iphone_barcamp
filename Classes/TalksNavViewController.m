//
//  TalksNavViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 9/14/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import "TalksNavViewController.h"


@implementation TalksNavViewController

@synthesize navigationController;

- (void)dealloc {
	[navigationController release];
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addSubview:[navigationController view]];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
