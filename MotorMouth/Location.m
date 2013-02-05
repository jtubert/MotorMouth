//
//  Location.m
//  MotorMouth
//
//  Created by John Tubert on 12/22/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import "Location.h"

@implementation Location


- (void) getLocation{
    // this creates the CCLocationManager that will find your current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self startUpdatingLocation];
    
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (void) startUpdatingLocation{
    NSLog(@"startUpdatingLocation");
    [locationManager startUpdatingLocation];
}

- (CLPlacemark*) getCurrentLocation{
    return placemark;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    NSLog(@"locationManager");
    
    [locationManager stopUpdatingLocation];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       
                       placemark = [placemarks objectAtIndex:0];
                       
                       
                       
                       //[[NSNotificationCenter defaultCenter] postNotificationName:@"onLocation" object:placemark];
                       /*
                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       NSLog(@"placemark.country %@",placemark.country);
                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                       NSLog(@"placemark.locality %@",placemark.locality);
                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                       */
                   }];

    }


@end
