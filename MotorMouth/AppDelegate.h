//
//  AppDelegate.h
//  MotorMouth
//
//  Created by John Tubert on 12/17/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    Location* loc;
    
}

@property (strong, nonatomic) UINavigationController* navController;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) UITabBarController *tabBarController2;



@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

- (CLPlacemark*) getCurrentLocation;
- (void) startUpdatingLocation;

void uncaughtExceptionHandler(NSException *exception);

@end
