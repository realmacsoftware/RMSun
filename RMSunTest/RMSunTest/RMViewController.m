//
//  RMViewController.m
//  RMSunTest
//
//  Created by Ted Bradley on 13/03/2013.
//  Copyright (c) 2013 Realmac Software. All rights reserved.
//

#import "RMViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "RMSun.h"

@interface RMViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSDateFormatter* formatter;
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation RMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.locationManager = [CLLocationManager new];
	self.locationManager.delegate = self;
	[self.locationManager startMonitoringSignificantLocationChanges];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentLocaleDidChange:) name:NSCurrentLocaleDidChangeNotification object:nil];
	[self currentLocaleDidChange:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)currentLocaleDidChange:(NSNotification*)notification
{
	self.formatter = [NSDateFormatter new];
	self.formatter.dateStyle = NSDateFormatterMediumStyle;
	self.formatter.timeStyle = NSDateFormatterShortStyle;
	
	[NSTimeZone resetSystemTimeZone];
	self.disclaimer.text = [NSString stringWithFormat:@"Times displayed in: %@", [NSTimeZone systemTimeZone]];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
	CLLocation* location = [locations lastObject];
	
	self.latitude.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
	self.longitude.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[self.locationManager stopMonitoringSignificantLocationChanges];
}

- (IBAction)calculate:(id)sender
{
	// Dismiss the keyboard if its up
	[self tappedView:nil];
	
	double latitude = [self.latitude.text doubleValue];
	double longitude = [self.longitude.text doubleValue];
	NSDate* sunriseDate = RMSunCalculateSunrise(latitude, longitude, self.date.date, RMSunZenithOfficial);
	if(sunriseDate == nil)
	{
		// This can occur in the extremes of the upper and lower hemispheres at certain times of year
		self.sunrise.text = @"No sunrise today";
	}
	else
	{
		self.sunrise.text = [self.formatter stringFromDate:sunriseDate];
	}
	
	NSDate* sunsetDate = RMSunCalculateSunset(latitude, longitude, self.date.date, RMSunZenithOfficial);
	if(sunsetDate == nil)
	{
		// This can occur in the extremes of the upper and lower hemispheres at certain times of year
		self.sunset.text = @"No sunset today";
	}
	else
	{
		self.sunset.text = [self.formatter stringFromDate:sunsetDate];
	}
}

- (IBAction)tappedView:(id)sender
{
	[self.latitude resignFirstResponder];
	[self.longitude resignFirstResponder];
}

@end
