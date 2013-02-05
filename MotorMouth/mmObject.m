//
//  mmObject.m
//  MotorMouth
//
//  Created by John Tubert on 12/26/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import "mmObject.h"

@implementation mmObject

@synthesize objId;
@synthesize ISOcountryCode;
@synthesize administrativeArea;
@synthesize contry;
@synthesize emotion;
@synthesize geoPoint;
@synthesize image;
@synthesize licensePlateNumber;
@synthesize locality;
@synthesize postalCode;
@synthesize subLocality;
@synthesize subThoroughfare;
@synthesize thumbnail;
@synthesize user;
@synthesize object;
//@synthesize updatedAt;


- (id)initWithObject:(PFObject *)aObject{
    
    object = aObject;
    
    objId = [aObject objectId];
    
    //updatedAt = [aObject updatedAt];
    ISOcountryCode = [aObject objectForKey:@"ISOcountryCode"];
    administrativeArea = [aObject objectForKey:@"administrativeArea"];
    contry = [aObject objectForKey:@"contry"];
    emotion = [aObject objectForKey:@"emotion"];
    geoPoint = [aObject objectForKey:@"geoPoint"];
    image = [aObject objectForKey:@"image"];
    licensePlateNumber = [aObject objectForKey:@"licensePlateNumber"];
    
    //NSLog(@"licensePlateNumber %@",licensePlateNumber);
    
    locality = [aObject objectForKey:@"locality"];
    postalCode = [aObject objectForKey:@"postalCode"];
    subLocality = [aObject objectForKey:@"subLocality"];
    subThoroughfare = [aObject objectForKey:@"subThoroughfare"];
    thumbnail = [aObject objectForKey:@"thumbnail"];
    user = [aObject objectForKey:@"user"];
    
    
    return self;
}

- (NSString*) description{
    return @"mmObject";
}

@end
