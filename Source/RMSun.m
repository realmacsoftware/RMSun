//
//  RMSun.m
//
//  Created by Ted Bradley on 13/03/2013.
//  Copyright (c) 2013 Realmac Software. All rights reserved.
//	Algorithm adapted from: http://williams.best.vwh.net/sunrise_sunset_algorithm.htm
//

#import "RMSun.h"

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)

float RMSunZenithOfficial = 90.83;
float RMSunZenithCivil = 96;
float RMSunZenithNautical = 102;
float RMSunZenithAstronomical = 108;

static float adjustToMax(float input, float max)
{
	float L = input;
	
	while (L < 0.0f)
	{
		L += max;
	}
	while(L > max)
	{
		L -= max;
	}
	
	return L;
}

NSDate* RMSunCalculateSunrise(double latitude, double longitude, NSDate* date, float zenith)
{
	// Split the date into components
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSCalendarUnit unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	NSDateComponents* components = [calendar components:unitFlags fromDate:date];
	
	// Get the day of the year
	NSUInteger dayOfYear = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
	
	// Convert the longitude to hour value and calculate an approximate time
	float lngHour = longitude / 15;
	float t = dayOfYear + ((6 - lngHour) / 24);
	
	// Calculate the Sun's mean anomaly
	float M = (0.9856 * t) - 3.289;
	
	// Calculate the Sun's true longitude
	float L = M + (1.916 * sin(DEGREES_TO_RADIANS(M))) + (0.020 * sin(2 * DEGREES_TO_RADIANS(M))) + 282.634;
	L = adjustToMax(L, 360.0f);
	
	// Calculate the Sun's right ascension
	float sunRA = RADIANS_TO_DEGREES(atan(0.91764 * tan(DEGREES_TO_RADIANS(L))));
	sunRA = adjustToMax(sunRA, 360.0f);
	
	// Right ascension needs to be in the same quadrant as L
	float lQuadrant = floor(L / 90) * 90;
	float raQuadrant = floor(sunRA / 90) * 90;
	sunRA = sunRA + (lQuadrant - raQuadrant);
	
	// Convert right ascension to hours
	sunRA = sunRA / 15;
	
	// Calculate the Sun's declination
	float sinDec = 0.39782 * sin(DEGREES_TO_RADIANS(L));
	float cosDec = cos(asin(sinDec));
	
	// Calculate the Sun's local hour angle
	float cosH = (cos(DEGREES_TO_RADIANS(zenith)) - (sinDec * sin(DEGREES_TO_RADIANS(latitude)))) / (cosDec * cos(DEGREES_TO_RADIANS(latitude)));
	if(cosH > 1)
	{
		// The sun never rises here on this date
		return nil;
	}
	
	// Finish calculating H and convert into hours
	float H = 360 - RADIANS_TO_DEGREES(acos(cosH));
	H = H / 15;
	
	// Calculate local mean time of rising / setting
	float T = H + sunRA - (0.06571 * t) - 6.622;
	
	// Adjust back to UTC
	float UT = (T - lngHour);
	UT = adjustToMax(UT, 24);
	
	// Create a date from the components and a UT calendar
	float hour = floorf(UT);
	float minute = floorf((UT - hour) * 60.0f);
	float second = (((UT - hour) * 60.0f) - minute) * 60.0f;
	
	components.hour = hour;
	components.minute = minute;
	components.second = second;
	
	NSDate* theDate = [calendar dateFromComponents:components];
	
	return theDate;
}

NSDate* RMSunCalculateSunset(double latitude, double longitude, NSDate* date, float zenith)
{
	// Split the date into components
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSCalendarUnit unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit);
	NSDateComponents* components = [calendar components:unitFlags fromDate:date];
	
	// Get the day of the year
	NSUInteger dayOfYear = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
	
	// Convert the longitude to hour value and calculate an approximate time
	float lngHour = longitude / 15;
	float t = dayOfYear + ((18 - lngHour) / 24);
	
	// Calculate the Sun's mean anomaly
	float M = (0.9856 * t) - 3.289;
	
	// Calculate the Sun's true longitude
	float L = M + (1.916 * sin(DEGREES_TO_RADIANS(M))) + (0.020 * sin(2 * DEGREES_TO_RADIANS(M))) + 282.634;
	L = adjustToMax(L, 360.0f);
	
	// Calculate the Sun's right ascension
	float sunRA = RADIANS_TO_DEGREES(atan(0.91764 * tan(DEGREES_TO_RADIANS(L))));
	sunRA = adjustToMax(sunRA, 360.0f);
	
	// Right ascension needs to be in the same quadrant as L
	float lQuadrant = floor(L / 90) * 90;
	float raQuadrant = floor(sunRA / 90) * 90;
	sunRA = sunRA + (lQuadrant - raQuadrant);
	
	// Convert right ascension to hours
	sunRA = sunRA / 15;
	
	// Calculate the Sun's declination
	float sinDec = 0.39782 * sin(DEGREES_TO_RADIANS(L));
	float cosDec = cos(asin(sinDec));
	
	// Calculate the Sun's local hour angle
	float cosH = (cos(DEGREES_TO_RADIANS(zenith)) - (sinDec * sin(DEGREES_TO_RADIANS(latitude)))) / (cosDec * cos(DEGREES_TO_RADIANS(latitude)));
	if(cosH < -1)
	{
		// The sun never sets on this location on this date
		return nil;
	}
	
	// Finish calculating H and convert into hours
	float H = RADIANS_TO_DEGREES(acos(cosH));
	H = H / 15;
	
	// Calculate local mean time of rising / setting
	float T = H + sunRA - (0.06571 * t) - 6.622;
	
	// Adjust back to UTC
	float UT = (T - lngHour);
	UT = adjustToMax(UT, 24);
	
	// Create a date from the components and a UT calendar
	float hour = floorf(UT);
	float minute = floorf((UT - hour) * 60.0f);
	float second = (((UT - hour) * 60.0f) - minute) * 60.0f;
	
	components.hour = hour;
	components.minute = minute;
	components.second = second;
	
	NSDate* theDate = [calendar dateFromComponents:components];
	
	return theDate;
}
