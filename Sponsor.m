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

@implementation Sponsor 

@dynamic name;
@dynamic link;

//Request an array of sponsors from the web service and update the array
//of persisted Sponsor objects in requestFinished:
+ (void)refreshSponsors {
	BarCampAppDelegate *delegate = (BarCampAppDelegate *) [[UIApplication sharedApplication] delegate];		
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",delegate.baseUrlStr,@"sponsors.json"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

+ (void)requestFinished:(ASIHTTPRequest *)request {
	NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
	NSString *responseString = [request responseString];
	//DLog(@"%@",responseString);
		
	NSData *jsonData = [responseString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"sponsors"]) {
		NSArray *sponsors = [dictionary objectForKey:@"sponsors"];
		for (NSDictionary *sponsor in sponsors) {
			NSDictionary *innerDict = [sponsor valueForKey:@"sponsor"];
            BOOL isDeleted = ([innerDict objectForKey:@"deleted_at"] == [NSNull null] ? NO : YES);
			
			//check for existing sponsor with same name
			Sponsor *sLocal = [Sponsor findFirstByAttribute:@"name" withValue:[innerDict objectForKey:@"name"]];
			
			if (!sLocal && !isDeleted) {
				DLog(@"Adding sponsor %@",[innerDict objectForKey:@"name"]);				
				Sponsor *sNew = [NSEntityDescription insertNewObjectForEntityForName:@"Sponsor" 
															  inManagedObjectContext:context];
				sNew.name = [innerDict objectForKey:@"name"];
				sNew.link = [innerDict objectForKey:@"homepage"];				
			} else if (sLocal && isDeleted) {
                //delete local file
                DLog(@"Deleting local sponsor %@ to reflect server delete",sLocal.name);
                [context deleteObject:sLocal];
            }             		
		}//sponsors loop
	}//json sanity test
	
	if ([context hasChanges]) {
		if(![context save:&error]) {
			DLog(@"Failed to save to data store: %@", [error localizedDescription]);
		}
	}
}

+ (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	DLog(@"Sponsor request failed: %@",[error localizedDescription]);
}

@end
