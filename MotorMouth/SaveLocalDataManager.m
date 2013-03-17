//
//  SaveLocalDataManager.m
//  MotorMouth
//
//  Created by John Tubert on 3/17/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import "SaveLocalDataManager.h"

@implementation SaveLocalDataManager


//Saving
+ (void) saveInteger:(int)intValue andKey:(NSString*)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an NSInteger
    [prefs setInteger:intValue forKey:key];

    [prefs synchronize];
    
}


+ (void) saveString:(NSString*)str andKey:(NSString*)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an NSString
    [prefs setObject:str forKey:key];
    
    /*
    // saving an NSInteger
    [prefs setInteger:42 forKey:@"integerKey"];
    
    // saving a Double
    [prefs setDouble:3.1415 forKey:@"doubleKey"];
    
    // saving a Float
    [prefs setFloat:1.2345678 forKey:@"floatKey"];
    */

    [prefs synchronize];
     
}

+ (int) getInteger:(NSString*)key {
    //Retrieving
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs integerForKey:key];
}

+ (NSString*) getString:(NSString*)key {
    //Retrieving

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // getting an NSString
    return [prefs stringForKey:key];
    /*
     // getting an NSInteger
     NSInteger myInt = [prefs integerForKey:@"integerKey"];

     // getting an Float
     float myFloat = [prefs floatForKey:@"floatKey"];
     */
}
@end
