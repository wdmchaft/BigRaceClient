//
//  ServersTableViewController.m
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import "BigRaceClientAppDelegate.h"
#import "JockeysTableViewController.h"
#import "ServersTableViewController.h"


@implementation ServersTableViewController

@synthesize jockeysTableViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	appDelegate = (BigRaceClientAppDelegate *)[[UIApplication sharedApplication] delegate];

	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked)] autorelease];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"UpdatingBonjourServices" object:nil];
}

- (void)reloadTableView {
	[self.tableView reloadData];
}

- (void)doneClicked {
	[self dismissModalViewControllerAnimated:YES];
	[jockeysTableViewController.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[appDelegate availableServices] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([[appDelegate availableServices] count] > 0) {
		cell.textLabel.text = [[[appDelegate availableServices] objectAtIndex:0] name];
	}
	
	if ([[appDelegate currentNetService] isEqual:(NSNetService *)[[appDelegate availableServices] objectAtIndex:indexPath.row]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	if ([[appDelegate currentNetService] isEqual:(NSNetService *)[[appDelegate availableServices] objectAtIndex:indexPath.row]]) {
		[appDelegate setCurrentNetService:nil];
	} else {
		[appDelegate setCurrentNetService:(NSNetService *)[[appDelegate availableServices] objectAtIndex:indexPath.row]];
	}
	[self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0 && [[appDelegate availableServices] count] == 0) {
		return @"Cannot find any available Bonjour services with the Big Race service type.";
	}
	return nil;
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