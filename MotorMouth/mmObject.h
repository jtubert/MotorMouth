//
//  mmObject.h
//  MotorMouth
//
//  Created by John Tubert on 12/26/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mmObject : PFObject

- (id)initWithObject:(PFObject *)aObject;

@property (nonatomic, copy) NSString *objId;
@property (nonatomic, copy) NSString *ISOcountryCode;
@property (nonatomic, copy) NSString *administrativeArea;
@property (nonatomic, copy) NSString *contry;
@property (nonatomic, copy) NSString *emotion;
@property (nonatomic, copy) PFGeoPoint *geoPoint;
@property (nonatomic, copy) PFFile *image;
@property (nonatomic, copy) NSString *licensePlateNumber;
@property (nonatomic, copy) NSString *locality;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *subLocality;
@property (nonatomic, copy) NSString *subThoroughfare;
@property (nonatomic, copy) PFFile *thumbnail;
@property (nonatomic, copy) NSString *user;
//@property (nonatomic, copy) NSDate *updatedAt;


@property (nonatomic, copy) PFObject *object;

@end
