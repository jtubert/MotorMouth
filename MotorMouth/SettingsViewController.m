//
//  SettingsViewController.m
//  MotorMouth
//
//  Created by John Tubert on 3/8/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import "SettingsViewController.h"
#import "SaveLocalDataManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)logout:(id)sender{
    [PFUser logOut];
    logoutButton.hidden=YES;
}


-(IBAction)changeViewSeg{
    [SaveLocalDataManager saveInteger:changeViewSegment.selectedSegmentIndex andKey:@"changeViewSegment"];
}

-(IBAction)changeSortSeg{
	[SaveLocalDataManager saveInteger:changeSortSegment.selectedSegmentIndex andKey:@"changeSortSegment"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    int viewInt = [SaveLocalDataManager getInteger:@"changeViewSegment"];
    int sortInt = [SaveLocalDataManager getInteger:@"changeSortSegment"];
    
    changeViewSegment.selectedSegmentIndex = viewInt;
    changeSortSegment.selectedSegmentIndex = sortInt;
    
    //NSLog(@"%@",[SaveLocalDataManager getString:@"test"]);
    
    if (![PFUser currentUser]) {
        logoutButton.hidden=YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
