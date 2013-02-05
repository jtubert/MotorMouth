//
//  SubclassConfigViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "MainViewController.h"
#import "Camera.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+RoundedCornerAdditions.h"
#import "Consts.h"
#import "PlateViewController.h"


@implementation MainViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    if ([PFUser currentUser]) {
              
    } else {
       
    }
    
    
    
    
    /*
    
    [PFCloud callFunctionInBackground:@"hello" withParameters:@{} block:^(NSString *result, NSError *error) {
        if (!error) {
            // result is @"Hello world!"
        }
    }];
     */
    
    
    
}


- (BOOL) isLoggedIn{
    if ([PFUser currentUser]) {
        NSLog(@"user is logged in: %@",[[PFUser currentUser] username]);
        return YES;
    } else {
        NSLog(@"user is NOT logged in");
        return NO;
    }
    
}



-(IBAction) getPhoto:(id) sender {
	[camera photoCaptureButtonAction:sender];
}


- (void)saveToAlbum:(UIImage*)img{
    //UIImage *img=[self.delegate getImage];
	
	//saves photo to album
	//UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);//
    
    //http://stackoverflow.com/questions/10954380/save-photos-to-custom-album-in-iphones-photo-library
    
    
    /*
    //saves in parse.com
    [self shouldUploadImage:img];
	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your sketch was saved successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
     */
}




- (void) onImageAdded:(NSNotification*)notification{
	
    
    UIImage *img = (UIImage*)[notification object];
    NSLog(@"img: %@",img);
    
    //add to photoalbum
    
    [photoAlbum saveImage:img andAlbumName:@"MotorMouth"];
    
    
	PlateViewController* pvc = [[PlateViewController alloc] initWithNibName:@"PlateViewController" bundle:nil];
    NSLog(@"pvc: %@",pvc);
    [pvc setImage:img];
    
    

    
    [[self navigationController] pushViewController:pvc animated:YES];
    
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
	
    [Flurry logEvent:@"MAIN_VIEW"];
    [TestFlight passCheckpoint:@"MAIN_VIEW"];
    
    
    
    
    //self.title = NSLocalizedString(@"MotorMouth", @"MotorMouth");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    //self.tabBarItem.title = @"first";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageAdded:) name:@"addImage" object:nil];

    camera = [Camera new];
    [camera setViewController:self];
    
    photoAlbum = [[PhotoAlbum alloc] initWithAlbumName:@"MotorMouth"];
    
    
    
    [self onFacebookLogin];
}

#pragma mark - Login mehtods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"photo_upload", @"publish_stream",@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
        
        
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            [Flurry setUserID:[user username]];
            NSLog(@"User with facebook signed up and logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            [self onFacebookLogin];
        } else {
            [Flurry setUserID:[user username]];
            NSLog(@"User with facebook logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            [self onFacebookLogin];
        }
    }];
    
    //[_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (void) onFacebookLogin{
    // Create request for user's facebook data
    NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status";
    
    // Send request to Facebook
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            //NSString *facebookId = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            // Set received values if they are not nil and reload the table
            if (location) {
                NSLog(@"%@",location);
            }
            
            if (gender) {
                NSLog(@"%@",gender);
            }
            
            if (birthday) {
                NSLog(@"%@",birthday);
            }
            
            if (relationship) {
                NSLog(@"%@",relationship);
            }
            
            [Flurry setUserID:userData[@"id"]];
            
            [_FBButtonLabel setText:@"Log out"];
            [login addTarget:self action:@selector(logoutButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [PFUser user].username = name;
                       
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"addImage" object:[UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]]];
            
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}

- (void)logoutButtonTouchHandler:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    [_FBButtonLabel setText:@"Log in"];
    //[login setTitle:@"Log in" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
}



#pragma mark - Logout button handler

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    
    
}




@end
