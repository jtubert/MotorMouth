//
//  SaveLocalDataManager.h
//  MotorMouth
//
//  Created by John Tubert on 3/17/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveLocalDataManager : NSObject

+ (void) saveString:(NSString*)str andKey:(NSString*)key;
+ (NSString*) getString:(NSString*)key;
+ (int) getInteger:(NSString*)key;
+ (void) saveInteger:(int)intValue andKey:(NSString*)key;

@end
