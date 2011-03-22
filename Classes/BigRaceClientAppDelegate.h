//
//  BigRaceClientAppDelegate.h
//  BigRaceClient
//
//  Created by Jonathan Freeman on 3/20/11.
//  Copyright 2011 Widget Press, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigRaceClientAppDelegate : NSObject <UIApplicationDelegate, NSNetServiceBrowserDelegate> {
    UIWindow *window;
	NSNetService *currentNetService;
	NSNetServiceBrowser *serviceBrowser;
	NSMutableArray *availableServices;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSNetService *currentNetService;
@property (nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, retain) NSMutableArray *availableServices;

@end

