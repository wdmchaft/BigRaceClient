//
//  ServersTableViewController.h
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BigRaceClientAppDelegate;
@class JockeysTableViewController;

@interface ServersTableViewController : UITableViewController {
	BigRaceClientAppDelegate *appDelegate;
	JockeysTableViewController *jockeysTableViewController;
}

@property (nonatomic, assign) JockeysTableViewController *jockeysTableViewController;

@end
