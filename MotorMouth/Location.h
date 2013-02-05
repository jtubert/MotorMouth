//
//  Location.h
//  MotorMouth
//
//  Created by John Tubert on 12/22/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLPlacemark* placemark;
}

- (void) getLocation;

- (CLPlacemark*) getCurrentLocation;
- (void) startUpdatingLocation;

@end
