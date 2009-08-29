//
//  BarCampAppDelegate.m
//  BarCamp
//
//  Created by Barry Ezell on 8/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BarCampAppDelegate.h"

@implementation BarCampAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
		
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}

//So this isn't littered around the app
- (NSString *)baseUrl {
	return @"http://localhost:3000";
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

