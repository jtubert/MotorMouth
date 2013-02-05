//
//  PlateViewController.h
//  MotorMouth
//
//  Created by John Tubert on 12/22/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateViewController : UIViewController{

    IBOutlet UIImageView *imageView;
    IBOutlet UITextField *licensePlateNumber;
    UIImage* myImage;
    NSString* emotion;
    CLPlacemark* placemark;
}

@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;

- (void) setImage:(UIImage*)img;



- (IBAction)submit:(id)sender;
- (IBAction)happy:(id)sender;
- (IBAction)angry:(id)sender;

@end
