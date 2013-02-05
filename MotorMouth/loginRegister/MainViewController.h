//
//  SubclassConfigViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//


#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Camera.h"
#import "PhotoAlbum.h"


@interface MainViewController : UIViewController {
    Camera* camera;
    PhotoAlbum* photoAlbum;
    IBOutlet UIButton *login;
    
}

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UILabel *FBButtonLabel;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;




- (IBAction)logOutButtonTapAction:(id)sender;

@end
