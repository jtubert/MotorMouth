//
//  DetailViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Consts.h"
#import "MapViewController.h"
#import "GeoPointAnnotation.h"
#import "AppDelegate.h"
#import "ZoomViewController.h"

@implementation MapViewController
@synthesize detailItem = _detailItem;
@synthesize mapView = _mapView;
@synthesize imageButton = _imageButton;
@synthesize textView = _textView;

#pragma mark - UIViewController


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.detailItem) {
        // obtain the geopoint
        PFGeoPoint *geoPoint = [self.detailItem objectForKey:@"geoPoint"];
        
        NSLog(@"%f %f",geoPoint.latitude, geoPoint.longitude);
        
        // center our map view around this geopoint
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude), MKCoordinateSpanMake(0.01, 0.01))];
        
        // add the annotation
        GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] initWithObject:self.detailItem];
        [self.mapView addAnnotation:annotation];
        
        
        //set image
        PFFile *file = [self.detailItem objectForKey:kPAPPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                [self.imageButton setImage:image forState:UIControlStateNormal];
                [self.imageButton addTarget:self action:@selector(showZoomViewController:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                NSLog(@"Error on fetching file");
            }
        }];
        
        //set text
        NSString* lic = [self.detailItem objectForKey:@"licensePlateNumber"];
        NSString* state = [self.detailItem objectForKey:@"administrativeArea"];
        NSString* country = [self.detailItem objectForKey:@"country"];
        NSString* zip = [self.detailItem objectForKey:@"postalCode"];
        NSString* city = [self.detailItem objectForKey:@"subLocality"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSDate* d = [self.detailItem updatedAt];
        NSString* date = [dateFormatter stringFromDate:d];
        

        NSString* str = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@", date,lic, state, country, city,zip];
        
        self.textView.text = str;
        
    }
}

- (void) showZoomViewController:(id)sender{
    ZoomViewController* zvc = [[ZoomViewController alloc] initWithImage:self.imageButton.currentImage];
    [self.navigationController pushViewController:zvc animated:YES];
}




- (void)updateLocations {
    CGFloat kilometers = 1.0f;
    
    PFQuery *query = [PFQuery queryWithClassName:@"mmObject"];
    [query setLimit:1000];
    [query whereKey:@"geoPoint"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude:placemark.location.coordinate.latitude
                                           longitude:placemark.location.coordinate.longitude]
   withinKilometers:kilometers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Count: %u",objects.count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            for (PFObject *object in objects) {
                GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc]
                                                          initWithObject:object];
                [self.mapView addAnnotation:geoPointAnnotation];
            }
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [Flurry logEvent:@"MAP_VIEW"];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    placemark =  [delegate getCurrentLocation];
    
    [self updateLocations];
    
    self.title = [self.detailItem objectForKey:@"licensePlateNumber"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
}

@end
