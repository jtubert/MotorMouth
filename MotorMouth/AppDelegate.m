//
//  AppDelegate.m
//  MotorMouth
//
//  Created by John Tubert on 12/17/12.
//  Copyright (c) 2012 John Tubert. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
//#import "CollectionViewController.h"
#import "Reachability.h"
#import "MainViewController.h"


@implementation AppDelegate



void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Flurry startSession:@"GSCXRM9J9HWPQ2DVXP9D"];
    
    [Crashlytics startWithAPIKey:@"4cec3d27c1349378ab58efe369f3e0d9fdd80d3f"];
    
    /// ****************************************************************************
    [Parse setApplicationId:@"MkCa8uRKkUogNYne4C1kpPVhF5T2JYzSJNlde69U"
                  clientKey:@"d7umRR7rHEaXslpl3PteKoiNHw5yD343uTpoXyS4"];
    [PFFacebookUtils initializeWithApplicationId:@"391180904300694"];
    [PFTwitterUtils initializeWithConsumerKey:@"apsU2L5pi69ih0mM72FrhQ" consumerSecret:@"jBL4zmySLvR9Dvr51EANtcPPRHv2uB5vsGuGXIs30ME"];
    // ****************************************************************************
    [TestFlight takeOff:@"27e131b36ab4427e18c1245d124d9b61_MTY2Mjc0MjAxMi0xMi0xMyAxODozOTowMy42NTA1NDQ"];
    
    
    // Set defualt ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }


    UIViewController *viewController1 = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    
    UIViewController *viewController2 = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain];
    //UIViewController *viewController2 = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController, navController2];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Add"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Search"];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"first.png"]];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"second.png"]];
    
    
    loc = [Location new];
    [loc getLocation];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self handlePush:launchOptions];
    
    
    return YES;
}

- (void)handlePush:(NSDictionary *)launchOptions {
    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"the app was launched in response to a push notification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channel"];
    if ([PFUser currentUser]) {
        // Make sure they are subscribed to their private push channel
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:@"user"];
        if (privateChannelName && privateChannelName.length > 0) {
            NSLog(@"Subscribing user to %@", privateChannelName);
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channel"];
        }
    }
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"didReceiveRemoteNotification" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
    [alert show];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [PF_FBSession.activeSession handleDidBecomeActive];
    
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
}


- (CLPlacemark*) getCurrentLocation{
    return [loc getCurrentLocation];
}

- (void) startUpdatingLocation {
    [loc startUpdatingLocation];
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
