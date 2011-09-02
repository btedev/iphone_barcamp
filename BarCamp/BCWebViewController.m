//
//  BCWebViewController.m
//  BarCamp
//
//  Created by Barry Ezell on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BCWebViewController.h"

@implementation BCWebViewController

@synthesize webView;

- (void)dealloc {
    [webView release]; webView = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
       
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://barcamptampabay.org/schedule"]]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end
