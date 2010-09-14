// 
//  Sponsor.m
//  BarCamp
//
//  Created by Barry Ezell on 9/11/10.
//  Copyright 2010 Dockmarket LLC. All rights reserved.
//

#import "Sponsor.h"
#import "BarCampAppDelegate.h"
#import "CJSONDeserializer.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation Sponsor 

@dynamic name;
@dynamic link;

//Request an array of sponsors from the web service and update the array
//of persisted Sponsor objects in requestFinished:
+ (void)refreshSponsors {
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];	
	DDLogVerbose(@"%@",delegate.baseUrlStr);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",delegate.baseUrlStr,@"sponsors.json"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

+ (void)requestFinished:(ASIHTTPRequest *)request {
	NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
	NSString *responseString = [request responseString];
	DDLogVerbose(@"%@",responseString);
		
	NSData *jsonData = [responseString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	
	BOOL newObjects = NO;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"sponsors"]) {
		NSArray *sponsors = [dictionary objectForKey:@"sponsors"];
		for (NSDictionary *sponsor in sponsors) {
			NSDictionary *innerDict = [sponsor valueForKey:@"sponsor"];
			
			//check for existing sponsor with same name
			Sponsor *sTest = [Sponsor findFirstByAttribute:@"name" withValue:[innerDict objectForKey:@"name"]];
			
			if (!sTest) {
				DDLogInfo(@"Adding sponsor %@",[innerDict objectForKey:@"name"]);				
				Sponsor *sNew = [NSEntityDescription insertNewObjectForEntityForName:@"Sponsor" 
															  inManagedObjectContext:context];
				sNew.name = [innerDict objectForKey:@"name"];
				sNew.link = [innerDict objectForKey:@"homepage"];
				newObjects = YES;
			}//isNew			
		}//sponsors loop
	}//json sanity test
	
	if (newObjects) {
		if(![context save:&error]) {
			DDLogError(@"Failed to save to data store: %@", [error localizedDescription]);
		}
	}
}

+ (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	DDLogVerbose(@"Sponsor request failed: %@",[error localizedDescription]);
}

@end
