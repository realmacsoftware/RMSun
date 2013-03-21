//
//  RMAppDelegate.m
//  RMSunTest
//
//  Created by Ted Bradley on 13/03/2013.
//  Copyright (c) 2013 Realmac Software. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMViewController.h"
#import "RMSun.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// Override point for customization after application launch.
	self.viewController = [[RMViewController alloc] initWithNibName:@"RMViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

@end
