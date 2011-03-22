//
//  JockeysTableViewController.m
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import "BigRaceClientAppDelegate.h"
#import "JockeysTableViewController.h"
#import "ServersTableViewController.h"

@implementation JockeysTableViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	jockeys = [[NSArray alloc] initWithObjects:@"Aral Balkan",
			   @"Cathy Shive",
			   @"Colin Wheeler",
			   @"Daniel Jalkut",
			   @"Dave Addey",
			   @"Dave Wiskus",
			   @"Drew McCormack",
			   @"Graham Lee",
			   @"Jiva Devoe",
			   @"John Fox",
			   @"Jonathan Dann",
			   @"Jonathan Freeman",
			   @"Kevin Hoctor",
			   @"Marcus Zarra",
			   @"Matt Gemmell",
			   @"Mike Lee",
			   @"Nicolas Seriot",
			   @"Saul Mora",
			   @"Scotty",
			   @"Tim Isted",
			   @"Trevor Squires",
			   @"Uli Kuster",
			   nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"UpdatingBonjourServices" object:nil];
}

- (void)reloadTableView {
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		BigRaceClientAppDelegate *appDelegate = (BigRaceClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([appDelegate currentNetService] != nil) {
			return 2;
		}
		return 1;
	}
    return [jockeys count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// Configure the cell...
	if (indexPath.section == 0) 
	{
		UITableViewCell *pairingCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		pairingCell.textLabel.textAlignment = UITextAlignmentCenter;
		if (indexPath.row == 0) {
			pairingCell.textLabel.text = @"Pair with Bonjour Server";
		} else {
			BigRaceClientAppDelegate *appDelegate = (BigRaceClientAppDelegate *)[[UIApplication sharedApplication] delegate];
			pairingCell.textLabel.text = [NSString stringWithFormat:@"Connected To: %@",[[appDelegate currentNetService] name]];
			pairingCell.textLabel.textColor = [UIColor blueColor];
			[pairingCell setSelected:NO animated:NO];
		} 
		return pairingCell;
	}
	else 
	{
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = [jockeys objectAtIndex:indexPath.row];
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[jockeys objectAtIndex:indexPath.row]]];
		return cell;
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if (indexPath.section == 0) {
		ServersTableViewController *serversTableViewController = [[ServersTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		serversTableViewController.jockeysTableViewController = self;
		serversTableViewController.title = @"Big Race Servers";
		UINavigationController *serverNavigationController = [[UINavigationController alloc] initWithRootViewController:serversTableViewController];
		[serversTableViewController release];
		[self presentModalViewController:serverNavigationController animated:YES];
		[serverNavigationController release];
	} else {
		// Deselect row, make it appear to be quick
		UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
		[selectedCell setSelected:NO animated:NO];
		
		// Check if we have a service, then send the data to run!
		// Else, throw up a silly alert
		BigRaceClientAppDelegate *appDelegate = (BigRaceClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([appDelegate currentNetService] != nil) {
			[self runJockeyRun:[NSString stringWithFormat:@"%i",indexPath.row]];
		} else {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Ummm, no Big Race Server"
								  message:@"Please choose a Big Race Server and do make sure you are on the same Wi-Fi network as the server."
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil,nil];
			[alert show];
			[alert autorelease];	
		}
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 1) {
			return nil; // don't select the Connected to
		}
	}
	return indexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"The Big Race";
	}
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		return @"After pairing with the Big Race Server, tap your Jockey as many times as you can to make them run down the race track.";
	}
	return nil;
}

#pragma mark -
#pragma mark Send XML to Big Race Server

- (void)runJockeyRun:(NSString *)jockeyID 
{
	BigRaceClientAppDelegate *appDelegate = (BigRaceClientAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSOutputStream *outStream;
	[[appDelegate currentNetService] getInputStream:nil outputStream:&outStream];
	[outStream open];

	NSMutableString *xml = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
	[xml appendFormat:@"<jockey id=\"%@\"></jockey>",jockeyID];
	NSData *xmlData = [xml dataUsingEncoding:NSUTF8StringEncoding];
	[outStream write:[xmlData bytes] maxLength:[xmlData length]];
	[outStream close];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end