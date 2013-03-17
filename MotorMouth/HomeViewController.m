//
//  MainViewController.m
//  MotorMouth
//
//  Created by John Tubert on 3/4/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import "HomeViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "PlateViewController.h"
#import "mmObject.h"
#import "Consts.h"
#import "SettingsViewController.h"
#import "SaveLocalDataManager.h"

#define DEFAULTKEYS [self.itemsDic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define FILTEREDKEYS [self.filteredArrayKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize filteredArray;
@synthesize filteredArrayKeys;
@synthesize searchBar;
@synthesize searchDC;
@synthesize itemsDic;
@synthesize itemsArr;
@synthesize objArr;
@synthesize showAllEntries;
@synthesize showGridView;
@synthesize selectedSearchFilter;
@synthesize lastRefresh;
@synthesize tableView;

#pragma mark - viewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    int viewInt = [SaveLocalDataManager getInteger:@"changeViewSegment"];
    
    if(viewInt == 0){
        self.showGridView = YES;
    }else{
        self.showGridView = NO;
    }
    
    
    if(self.showGridView){
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.userInteractionEnabled = NO;
        
        [self.collectionView addSubview:self.searchBar];
        
        [self.collectionView reloadData];
    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.userInteractionEnabled = YES;
        
        [self.searchBar removeFromSuperview];
        self.tableView.tableHeaderView = self.searchBar;
    }
    
    [self.tableView reloadData];
    
    
    [self performSelector:@selector(hidesSearchBar) withObject:nil afterDelay:1];   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int viewInt = [SaveLocalDataManager getInteger:@"changeViewSegment"];
    
    if(viewInt == 0){
        self.showGridView = YES;
    }else{
        self.showGridView = NO;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageAdded:) name:@"addImage" object:nil];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);    
    self.itemsDic = [NSMutableDictionary dictionary];
    
    [self createTableViewForSearch];    
    [self createCameraButtonView];    
    [self addSettingsButton];
    
    
}

- (void) addSettingsButton{
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,27,25)];
    
    UIButton *settingsButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,27,25)];
    
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton2];

}

- (void) showSettings{
    //NSLog(@"showSettings");
    SettingsViewController* vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) createCameraButtonView{
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(60,0,103,44)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"header.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    self.navigationItem.titleView = logoView;
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-shield-homescreen.png"]];
    [self.view addSubview:iv];
    
    iv.frame = CGRectMake(0, self.view.frame.size.height - 130.0f, 320.0f, 110.0f);
    
    UIButton *captureButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0f - 166.0f)/2,self.view.frame.size.height - 115.0f,166,65)];
    [captureButton setBackgroundImage:[UIImage imageNamed:@"capture-start_off.png"] forState:UIControlStateNormal];
    [captureButton setBackgroundImage:[UIImage imageNamed:@"capture-start_on.png"] forState:UIControlStateHighlighted];
    [captureButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    captureButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:captureButton];
    
    camera = [Camera new];
    [camera setViewController:self];
    
    photoAlbum = [[PhotoAlbum alloc] initWithAlbumName:@"MotorMouth"];

}

- (void) createTableViewForSearch{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if(self.showGridView){
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.userInteractionEnabled = NO;
    }
    
	self.selectedSearchFilter = 4;
    
    // Create a search bar
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	
    
    if(self.showGridView){
        [self.collectionView addSubview:self.searchBar];
    }else{
        self.tableView.tableHeaderView = self.searchBar;
    }
    
    
    
    self.searchBar.delegate = self;
    
    NSArray* titles = [[NSArray alloc] initWithObjects:@"Plate",@"City",@"State",@"Zip",@"All", nil];
    
    self.searchBar.scopeButtonTitles = titles;
    self.searchBar.selectedScopeButtonIndex = 4;
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
}

#pragma mark - table stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    mmObject *item;
    
    
    if(tView == self.tableView){
        item = [self.objArr objectAtIndex:indexPath.row];
    }else{
        NSString *key = [FILTEREDKEYS objectAtIndex:indexPath.row];
        item = [self.itemsDic objectForKey:key];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate* d = [item.object updatedAt];
    NSString* date = [dateFormatter stringFromDate:d];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Plate#: %@, (%@)",item.licensePlateNumber, date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",item.subLocality, item.locality, item.postalCode];
    PFFile *file = item.thumbnail;
    
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image =image;
        } else {
            NSLog(@"Error on fetching file");
        }
    }];
    
    return cell;
    
}

// Return how many rows in the table
- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section
{
	if (tView == self.tableView){
        if(self.showGridView){
            return 0;
        }else{
            return self.objArr.count;
        }
        
    }
    
    //@"Plate",@"City",@"State",@"Zip",@"All"
    
    NSPredicate *predicate;
    
    
    switch (self.selectedSearchFilter) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@", self.searchBar.text];
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"subLocality contains[cd] %@", self.searchBar.text];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"administrativeArea contains[cd] %@", self.searchBar.text];
            break;
        case 3:
            predicate = [NSPredicate predicateWithFormat:@"postalCode contains[cd] %@", self.searchBar.text];
            break;
        case 4:
            predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@ OR subLocality contains[cd] %@ OR postalCode contains[cd] %@ OR administrativeArea contains[cd] %@", self.searchBar.text, self.searchBar.text, self.searchBar.text, self.searchBar.text];
            break;
            
        default:
            
            break;
    }
    
    
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY @allValues contains[cd] %@", self.searchBar.text];
    self.filteredArray = [self.objArr filteredArrayUsingPredicate:predicate];
    self.filteredArrayKeys = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < self.filteredArray.count; i++) {
        mmObject *item = [self.filteredArray objectAtIndex:i];
        [self.filteredArrayKeys addObject:item.object.objectId];
    }
 
	return self.filteredArray.count;
}




- (void) objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    if(error){
        NSLog(@"error: %@",error);
    }
    
    [self performSelector:@selector(hidesSearchBar) withObject:nil afterDelay:1];
    
    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.itemsArr = [NSArray arrayWithArray:self.objects];
    self.objArr = [[NSMutableArray alloc] init];
    
    NSLog(@"count:  :::::::%u",self.itemsArr.count);
    
    for (int i=0; i < self.itemsArr.count; i++) {
        PFObject *item = [self.itemsArr objectAtIndex:i];
        mmObject *obj = [[mmObject alloc] initWithObject:item];
        //NSString *str = [item objectForKey:@"licensePlateNumber"];
        NSString *str = [item objectId];
        [self.itemsDic setObject:obj forKey:str];
        
        [self.objArr addObject:obj];
    }
    
    [self.tableView reloadData];
    
    
}

- (void) takePicture:(id) sender{
    //[PFUser logOut];
    if ([PFUser currentUser]) {
        [camera photoCaptureButtonAction:sender];
    }else{
        [self checkIfUserLogedIn];
    }
}

- (void) onImageAdded:(NSNotification*)notification{    
    UIImage *img = (UIImage*)[notification object];    
    //add to photoalbum    
    [photoAlbum saveImage:img andAlbumName:@"MotorMouth"];    
	PlateViewController* pvc = [[PlateViewController alloc] initWithNibName:@"PlateViewController" bundle:nil];
    NSLog(@"pvc: %@",pvc);
    [pvc setImage:img];   
    [[self navigationController] pushViewController:pvc animated:YES];    
}


- (void) checkIfUserLogedIn{
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton];
        
        // Customize the Sign Up View Controller
        MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
        [signUpViewController setDelegate:self];
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
        [logInViewController setSignUpController:signUpViewController];
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

#pragma mark - searchBar

-(void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [Flurry logEvent:@"searchBarSearchButtonClicked"];
    NSLog(@"searchBarSearchButtonClicked %@", _searchBar.text);
}

/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [Flurry logEvent:@"searchBar_textDidChange"];
    
    
    if (searchText.length > 2) {
        
        NSPredicate *predicate;
        
        switch (self.selectedSearchFilter) {
            case 0:
                predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@", self.searchBar.text];
                break;
            case 1:
                predicate = [NSPredicate predicateWithFormat:@"subLocality contains[cd] %@", self.searchBar.text];
                break;
            case 2:
                predicate = [NSPredicate predicateWithFormat:@"administrativeArea contains[cd] %@", self.searchBar.text];
                break;
            case 3:
                predicate = [NSPredicate predicateWithFormat:@"postalCode contains[cd] %@", self.searchBar.text];
                break;
            case 4:
                predicate = [NSPredicate predicateWithFormat:@"licensePlateNumber contains[cd] %@ OR subLocality contains[cd] %@ OR postalCode contains[cd] %@ OR administrativeArea contains[cd] %@", self.searchBar.text, self.searchBar.text, self.searchBar.text, self.searchBar.text];
                break;
                
            default:
                
                break;
        }
        
        
        
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY @allValues contains[cd] %@", self.searchBar.text];
        self.filteredArray = [self.objects filteredArrayUsingPredicate:predicate];
        self.filteredArrayKeys = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.filteredArray.count; i++) {
            PFObject *item = [self.filteredArray objectAtIndex:i];
            [self.filteredArrayKeys addObject:item.objectId];
        }
        
        NSLog(@"self.filteredArray.count: %u",self.filteredArray.count);

    }
}
*/
- (void)hidesSearchBar{
    if(self.showGridView){
        //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }else{
        CGSize searchSize = self.searchDC.searchBar.bounds.size;
        //not complete
        //[self.tableView setContentOffset:CGPointMake(0, searchSize.height)];
    }
    
    
    //NSLog(@"count: %u",self.collectionView.visibleCells.count);
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //[self.tableView reloadData];
    [self hidesSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    //@"Plate",@"City",@"State",@"Zip",@"All"
    self.selectedSearchFilter = selectedScope;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //NSLog(@"searchBarCancelButtonClicked");
	[self.searchBar setText:@""];
    [Flurry logEvent:@"SEARCH_CANCEL_BUTTON_PRESSED"];
}



#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:^{
        [camera photoCaptureButtonAction:nil];
        
    }];
    
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to log in!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];

}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForCollection
{
    PFQuery *queryMMObject = [PFQuery queryWithClassName:@"mmObject"];
    
    NSLog(@"showAllEntries: %u",showAllEntries);
    
    
    if(showAllEntries){
        [queryMMObject whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    }
    
    [queryMMObject orderByDescending:@"createdAt"];
    
    
    //[queryMMObject setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        NSLog(@"Loading from cache");
        [queryMMObject setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    
    return queryMMObject;
    
    //return [PFQuery queryWithClassName:@"mmObject"];
}

# pragma mark - Collection View data source


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //[super collectionView:collectionView numberOfItemsInSection:section];
    NSLog(@"");
    
   if(self.showGridView){
       return self.objects.count;
   }else{
       return 0;
   }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    
    static NSString *cellIdentifier = @"cvCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
        
    //Add label
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    [titleLabel setText:object[@"licensePlateNumber"]];   
    
    //add thumbnail
    PFFile *file = object[@"thumbnail"];    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            
            UIImageView *imageV = (UIImageView *)[cell viewWithTag:100];
            imageV.image = image;            
        } else {
            NSLog(@"Error on fetching file");
        }
    }];   
    
        
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"xxxxx %@", [self objectAtIndexPath:indexPath]);
    
    //UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor blueColor];
    
    //http://stackoverflow.com/questions/13029340/uiactivityitemsource-protocole-set-complex-object
    NSString* someText = @"this is some text to share";
    NSArray* dataToShare = @[someText];  // ...or whatever pieces of data you want to share.
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    
    /*
     NSString *textToShare = @”I just shared this from my App”;
     UIImage *imageToShare = [UIImage imageNamed:@"Image.png"];
     NSURL *urlToShare = [NSURL URLWithString:@"http://www.bronron.com"];
     NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
     UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
     [self presentViewController:activityVC animated:TRUE completion:nil];
     */
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //cell.iv.image = [self.results objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithPatternImage:[self.results objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [self.results objectAtIndex:indexPath.row];
    return CGSizeMake(image.size.width, image.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 90, 10);
}
*/



@end
