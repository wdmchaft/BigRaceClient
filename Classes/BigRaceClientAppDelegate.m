//
//  BigRaceClientAppDelegate.m
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import "BigRaceClientAppDelegate.h"
#import "JockeysTableViewController.h"

@implementation BigRaceClientAppDelegate

@synthesize window;
@synthesize currentNetService;
@synthesize serviceBrowser;
@synthesize availableServices;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	JockeysTableViewController *jockeysTVC = [[JockeysTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.window addSubview:[jockeysTVC view]];
	[self.window makeKeyAndVisible];
    
	// Set up Bonjour iVars
	serviceBrowser = [[NSNetServiceBrowser alloc] init];
	availableServices = [[NSMutableArray array] retain];
	
	[serviceBrowser setDelegate:self];
	[serviceBrowser searchForServicesOfType:@"_BigRace._tcp." inDomain:@"local."];
	
    return YES;
}

#pragma mark -
#pragma mark NSNetServiceBrowser Delegates Methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing 
{
	if(![availableServices containsObject:aNetService])
	{
		[availableServices addObject:aNetService];
		[aNetService resolveWithTimeout:5.0];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatingBonjourServices" object:nil];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing 
{
	[self setCurrentNetService:nil];
	[availableServices removeObject:aNetService];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatingBonjourServices" object:nil];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
