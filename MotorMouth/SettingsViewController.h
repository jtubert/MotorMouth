//
//  SettingsViewController.h
//  MotorMouth
//
//  Created by John Tubert on 3/8/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
    IBOutlet UISegmentedControl *changeViewSegment;
    IBOutlet UISegmentedControl *changeSortSegment;
    IBOutlet UIButton *logoutButton;
}

-(IBAction)changeViewSeg;

-(IBAction)changeSortSeg;

- (IBAction)logout:(id)sender;


@end
