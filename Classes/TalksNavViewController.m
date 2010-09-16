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

//see http://davidebenini.it/2009/01/03/viewwillappear-not-being-called-inside-a-uinavigationcontroller/
-(void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	[navigationController viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated { 
	[super viewWillDisappear:animated];
	[navigationController viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated { 
	[super viewDidAppear:animated];
	[navigationController viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated { 
	[super viewDidDisappear:animated];
	[navigationController viewDidDisappear:animated];
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
