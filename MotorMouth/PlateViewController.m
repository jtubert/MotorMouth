//
//  PlateViewController.m
//  MotorMouth
//
//  Created by John Tubert on 12/22/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import "PlateViewController.h"
#import "Consts.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+RoundedCornerAdditions.h"
#import "Location.h"
#import "AppDelegate.h"


@interface PlateViewController ()

@end

@implementation PlateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) setImage:(UIImage*)img{
    myImage = img;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate startUpdatingLocation];

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    [Flurry logEvent:@"PLATE_VIEW"];
    
    
    [imageView setImage:myImage];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate startUpdatingLocation];
   
        
}

- (IBAction)submit:(id)sender{
    [self shouldUploadImage:myImage];
    
    [Flurry logEvent:@"PLATE_SUBMIT"];
}

- (IBAction)happy:(id)sender{
    emotion = @"happy";
    [Flurry logEvent:@"PLATE_EMOTION_HAPPY"];
}

- (IBAction)angry:(id)sender{
    emotion = @"angry";
    [Flurry logEvent:@"PLATE_EMOTION_ANGRY"];
}

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    
    // create a mmObject object
    PFObject *mmObject = [PFObject objectWithClassName:@"mmObject"];
    if([PFUser currentUser]){
        [mmObject setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
    }
    if(emotion){
        [mmObject setObject:emotion forKey:@"emotion"];
    }
    if(licensePlateNumber.text){
        [mmObject setObject:licensePlateNumber.text forKey:@"licensePlateNumber"];
    }
    
    
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    placemark =  [delegate getCurrentLocation];
    
    
    
    //save place information
    if(placemark){
        if(placemark.ISOcountryCode)[mmObject setObject:placemark.ISOcountryCode forKey:@"ISOcountryCode"];
        if(placemark.country)[mmObject setObject:placemark.country forKey:@"country"];
        if(placemark.postalCode)[mmObject setObject:placemark.postalCode forKey:@"postalCode"];
        if(placemark.administrativeArea)[mmObject setObject:placemark.administrativeArea forKey:@"administrativeArea"];
        if(placemark.locality)[mmObject setObject:placemark.locality forKey:@"locality"];
        if(placemark.subLocality)[mmObject setObject:placemark.subLocality forKey:@"subLocality"];
        if(placemark.subThoroughfare)[mmObject setObject:placemark.subThoroughfare forKey:@"subThoroughfare"];
        
        
        CLLocation *location = placemark.location;
        CLLocationCoordinate2D coordinate = [location coordinate];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
        
        [mmObject setObject:geoPoint forKey:@"geoPoint"];
        
    }
    
    //save photos
    [mmObject setObject:self.photoFile forKey:kPAPPhotoPictureKey];
    [mmObject setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];
    
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    mmObject.ACL = photoACL;
    [mmObject saveInBackground];
    
    [self onSubmit];
    
    
    return YES;
}

- (void)onSubmit{
	[[[UIAlertView alloc] initWithTitle:@"MotorMouth"
								 message:@"Thanks for your submition!"
								delegate:self
					   cancelButtonTitle:nil
					   otherButtonTitles:@"OK",nil] show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == alertView.firstOtherButtonIndex)
		[[self navigationController] popViewControllerAnimated:YES];
}






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    
    
    
    
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    
    
    
    if (textField.tag == 1) {
        //UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        //[passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
