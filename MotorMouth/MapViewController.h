//
//  MapViewController.h
//  MotorMouth
//
//  Created by John Tubert on 12/24/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>{
    CLPlacemark* placemark;
}

@property (nonatomic, strong) PFObject *detailItem;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *imageButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
