//
//  RMSun.h
//
//  Created by Ted Bradley on 13/03/2013.
//  Copyright (c) 2013 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern float RMSunZenithOfficial;
extern float RMSunZenithCivil;
extern float RMSunZenithNautical;
extern float RMSunZenithAstronomical;

extern NSDate* RMSunCalculateSunrise(double latitude, double longitude, NSDate* date, float zenith);
extern NSDate* RMSunCalculateSunset(double latitude, double longitude, NSDate* date, float zenith);
