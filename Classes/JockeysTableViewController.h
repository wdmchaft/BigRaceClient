//
//  JockeysTableViewController.h
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JockeysTableViewController : UITableViewController {

	NSArray *jockeys;
}
- (void)runJockeyRun:(NSString *)jockeyID;


@end
